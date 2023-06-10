import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:medic/user%20side/UI%20screens/emergency_result.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/private_widget.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';

import 'ambulance_widget.dart';


class DisplaySelectedHospital extends StatefulWidget {
  final Map<String, dynamic> hospitalList;
  final String currentHospital;
  final String userID;
  const DisplaySelectedHospital({Key? key, required this.hospitalList, required this.currentHospital, required this.userID}) : super(key: key);

  @override
  State<DisplaySelectedHospital> createState() => _DisplaySelectedHospitalState();
}

class _DisplaySelectedHospitalState extends State<DisplaySelectedHospital> {
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
    userId = widget.userID;
    print("init state $userId");
    hospital = widget.currentHospital;
    print("init state $hospital");
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

  generatingForHospital(currentHospital, currentUid){
    timeOver = false;
    Map hospitals = widget.hospitalList;

    hospitals.remove(currentHospital);
    print(hospitals);

    var nearest = hospitals.values.cast<num>().reduce(min);
    hospitals.forEach((key, value) async {
      if (value == nearest) {
        hospital = key;
        print(hospital);
        // add the patient to the database of that hospital
        String name = context.read<SaveTriageResults>().userName;
        String birthday = context.read<SaveTriageResults>().userBirthday;
        String number = context.read<SaveTriageResults>().userNumber;
        String age = context.read<SaveTriageResults>().userAge;
        String sex = context.read<SaveTriageResults>().userSex;
        String address = context.read<SaveTriageResults>().userAddress;
        String mainConcern = context.read<SaveTriageResults>().mainConcern;
        List symptoms = context.read<SaveTriageResults>().symptoms;
        String triageCategory = context.read<SaveTriageResults>().triageCategory;
        String travelMode = context.read<SaveTriageResults>().travelMode;
        String status = context.read<SaveTriageResults>().status;
        String userLat = context.read<SaveTriageResults>().userLatitude;
        String userLong = context.read<SaveTriageResults>().userLongitude;

        await patients.add({
          'Name': name,
          'Birthday': birthday,
          'Contact Number': number,
          'Sex': sex,
          'Main Concerns': mainConcern,
          'Symptoms': symptoms.toList(),
          'triage_result': triageCategory,
          'Travel Mode': travelMode,
          'Age': age,
          'Address': address,
          'hospital_user_id': hospital,
          'Status': status,
          'Location' : {
            'Latitude' : userLat.toString(),
            'Longitude': userLong.toString(),
          },
          'requested_time': Timestamp.now(),
        }).then((value) {
          userId = value.id;
          if (hospitals.isNotEmpty){
            patients.doc(userId).update({"Status": "pending"});
            patients.doc(currentUid).update({"Status": "rejected"});
          }else{
            patients.doc(userId).update({"Status": "pending"});
          }
          print(userId);

          setState(() {
            userId = value.id;
          });
        });
      }
    });
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
              if(snapshot.hasData){
                if(widget.hospitalList.length > 1) {
                  if (data!['Status'] == "pending"){
                    var currentHospital = data['hospital_user_id'];
                    startTimer();
                    if (!timeOver){
                      return pendingWidget(data: currentHospital);
                    }else if(timeOver){
                      timer.cancel();
                      print(timeOver);
                      print("timer canceled");
                      generatingForHospital(hospital, userId);

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
                      SchedulerBinding.instance.addPostFrameCallback((_) async{
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
                      var currentHospital = data['hospital_user_id'];
                      noAmbulance(data: currentHospital);
                    });
                  }

                  if (data['Status'] == "rejected"){
                    timer.cancel();
                    print(timeOver);
                    print("timer canceled");

                    generatingForHospital(hospital, userId);
                  }
                }
                else if (widget.hospitalList.length == 1){
                  if (data!['Status'] == "pending"){
                    var currentHospital = data['hospital_user_id'];
                    startTimer();
                    if (!timeOver){
                      return pendingWidget(data: currentHospital);
                    }else if(timeOver){
                      timer.cancel();
                      print(timeOver);
                      print("timer canceled");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                            child: Text("Sorry, we didn't find any hospital that can accommodate you as of the moment."),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                            child: Text("Please wait for a few more minutes and try selecting a hospital again."),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Go back"),
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

                    if (data['Travel Mode'] == "AMBULANCE"){
                      SchedulerBinding.instance.addPostFrameCallback((_) async {
                        paramedicID = await getValues();
                        print(paramedicID);
                        if (!mounted) return;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AmbulanceWidget(hospital: currentHospital, paramedicId: paramedicID, userId: userId,)));
                        deletePreviousRecord(userId);
                      });
                    }
                    else{
                      SchedulerBinding.instance.addPostFrameCallback((_) async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrivateWidget(hospital: currentHospital, userId: userId,)));
                        deletePreviousRecord(userId);
                      });
                    }
                  }

                  if (data['Status'] == "No Ambulance"){
                    timer.cancel();
                    print(timeOver);
                    print("timer canceled");
                    SchedulerBinding.instance.addPostFrameCallback((_) async {
                      var currentHospital = data['hospital_user_id'];
                      noAmbulanceLast(data: currentHospital);
                    });
                  }

                  if (data['Status'] == "rejected"){
                    timer.cancel();
                    print(timeOver);
                    print("timer canceled");
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Text("Sorry, we didn't find any hospital that can accommodate you as of the moment."),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: Text("Please wait for a few more minutes and try selecting a hospital again."),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //deletePreviousRecord(userId);
                          },
                          child: const Text("Go back"),
                        )
                      ],
                    );
                  }
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
          child: Text("We are currently contacting $data, please wait for a moment...",
          ),
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


  Object noAmbulance({required data}) {
    return showCupertinoDialog<String>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("$data has no available ambulance as of the moment"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                patients.doc(userId).update({"Status": "pending"});
                patients.doc(userId).update({"Travel Mode": "Private Vehicle"});


              },
              child: const Text("Switch to private vehicle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                generatingForHospital(hospital, userId);

              },
              child: const Text("Go to next hospital"),
            ),

          ],
        )
    );
  }

  Object noAmbulanceLast({required data}) {
    return showCupertinoDialog<String>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("$data has no ambulance available as of the moment"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                patients.doc(userId).update({"Status": "pending"});
                patients.doc(userId).update({"Travel Mode": "Private Vehicle"});


              },
              child: const Text("Switch to private vehicle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                deletePreviousRecord(userId);

              },
              child: const Text("Cancel request"),
            ),

          ],
        )
    );
  }




}
