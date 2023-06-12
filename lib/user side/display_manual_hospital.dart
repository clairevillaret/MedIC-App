
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:medic/user%20side/ambulance_widget.dart';
import 'package:medic/user%20side/private_widget.dart';



class ManualDisplayHospital extends StatefulWidget {
  final String currentHospital;
  final String userID;
  const ManualDisplayHospital({Key? key, required this.currentHospital, required this.userID}) : super(key: key);

  @override
  State<ManualDisplayHospital> createState() => _ManualDisplayHospitalState();
}

class _ManualDisplayHospitalState extends State<ManualDisplayHospital> {
  final CollectionReference patients = FirebaseFirestore.instance.collection('hospitals_patients');
  final CollectionReference hospitals = FirebaseFirestore.instance.collection('hospitals');

  String hospital = "";
  String userId = "";
  late Timer timer;
  int time = 0;
  bool timeOver = false;
  String paramedicID = "";

  @override
  void initState() {
    hospital = widget.currentHospital;
    print("init state $hospital");
    userId = widget.userID;
    print("init state $userId");
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      time ++;
      //print(time);
      if (time == 360){
        timer.cancel();
        setState(() {
          timeOver = true;
          time = 0;
        });
        print(timeOver);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  deletePreviousRecord(previousUid) {
    // delete patient record in last hospital
    patients.doc(previousUid).delete();
  }


  Future<String> getValues() async {
    String hospitalId = "";
    List<String> hospitalIds = [];

    QuerySnapshot hospitalsQuerySnapshot = await hospitals.where('Name', isEqualTo: hospital).get();
    hospitalsQuerySnapshot.docs.forEach((DocumentSnapshot doc) {
      hospitalIds.add(doc.id);
    });
    hospitalId = hospitalIds[0];
    print("hospital id $hospitalId");

    var acceptedPatient = hospitals.doc(hospitalId).collection('patient');

    var docSnapshot = await acceptedPatient.doc(userId).get();
    Map<String, dynamic>? data = docSnapshot.data();
    setState(() {
      paramedicID = data!['paramedic_id'];
    });

    print("paramedic $paramedicID");
    return paramedicID;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: patients.doc(userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              var data = snapshot.data;
              if (snapshot.data != null) {
                if (!snapshot.data!.exists){
                  return Container(
                    color: Colors.white,
                  );
                }
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong, sorry.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData){
                if (data!['Status'] == "pending"){
                  var selectedHospital = data['hospital_user_id'];
                  startTimer();
                  if (!timeOver){
                    return pendingWidget(data: selectedHospital);
                  }else if(timeOver){
                    timer.cancel();
                    print(timeOver);
                    print("timer canceled");
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("$selectedHospital is taking too long to respond. Please select a new hospital.",
                          textAlign: TextAlign.center,),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              patients.doc(userId).update({"Status": "rejected"});
                            },
                            child: const Text("Go back")
                        )
                      ],
                    );
                  }
                }

                if (data['Status'] == "accepted"){
                  timer.cancel();
                  print(timeOver);
                  print("timer canceled");
                  var currentHospital = data['hospital_user_id'];
                  hospital = currentHospital;

                  if (data['Travel Mode'] == "AMBULANCE"){
                    SchedulerBinding.instance.addPostFrameCallback((_) async {
                      paramedicID = await getValues();
                      print(paramedicID);
                      if (!mounted) return;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AmbulanceWidget(hospital: hospital, paramedicId: paramedicID, userId: userId,)));
                      deletePreviousRecord(userId);
                    });
                    }
                  else{
                      SchedulerBinding.instance.addPostFrameCallback((_){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrivateWidget(hospital: hospital, userId: userId,)));
                        deletePreviousRecord(userId);
                      });
                    }
                  }

                if (data['Status'] == "No Ambulance"){
                  timer.cancel();
                  print(timeOver);
                  print("timer canceled");
                  SchedulerBinding.instance.addPostFrameCallback((_) async {
                    noAmbulance();
                  });
                }

                if (data['Status'] == "rejected"){
                  timer.cancel();
                  print(timeOver);
                  print("timer canceled");
                  var currentHospital = data['hospital_user_id'];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("$currentHospital cannot accommodate you as of the moment. Please select a new hospital."),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            patients.doc(userId).update({"Status": "rejected"});
                          },
                          child: const Text("Go back")
                      )
                    ],
                  );
                }
              }

              return const Center(child: CircularProgressIndicator());
            }
        )
    );
  }

  Widget pendingWidget({required data}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("We are currently contacting $data, please wait for a moment..."),
        ),
        TextButton(
          onPressed: () {
            showCupertinoDialog<String>(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure you want to cancel the request?"),
                  actions: [
                    TextButton(onPressed: () {
                      timer.cancel();
                      print("timer canceled");
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      deletePreviousRecord(userId);

                    },
                        child: const Text("Yes")
                    ),
                    TextButton(onPressed: () {
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                        child: const Text("No")
                    ),
                  ],
                )
            );
          },
          child: const Text("Cancel"),
        ),

      ],
    );
  }

  Object noAmbulance() {
    return showCupertinoDialog<String>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("There is no available ambulance as of the moment"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                patients.doc(userId).update({"Status": "pending"});
                patients.doc(userId).update({"Travel Mode": "Private Vehicle"});


              },
              child: const Text("Switch to private vehicle", textAlign: TextAlign.center,),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                patients.doc(userId).update({"Status": "rejected"});
              },
              child: const Text("Cancel request"),
            ),

          ],
        )
    );
  }


}