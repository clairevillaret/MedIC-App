import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medic/user%20side/UI%20screens/emergency_result.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';


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
  String hospital = "";
  String userId = "";
  late Timer timer;
  int time = 0;
  bool timeRunning = false;

  @override
  void initState() {
    userId = widget.userID;
    print("init state $userId");
    hospital = widget.currentHospital;
    print("init state $hospital");
    //startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) { });
    //timer = Timer(const Duration(minutes: 6), () {});
    timer.cancel();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  generatingForHospital(currentHospital, currentUid){
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
          'Name:': name,
          'Birthday': birthday,
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
          }
        }).then((value) {
          userId = value.id;
          patients.doc(userId).update({"Status": "pending"});
          print(userId);

          setState(() {
            userId = value.id;
          });
          //deletePreviousRecord(currentUid);
        });
      }
    });
  }

  deletePreviousRecord(previousUid) {
    // delete patient record in last hospital
    patients.doc(previousUid).delete();
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
                return const Center(child: Text("Loading..."));
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if(widget.hospitalList.length > 1) {
                if (data!['Status'] == "pending"){
                  startTimer();
                  while(timer.tick < 360){
                    print(timer.tick);
                    return pendingWidget();
                  }
                  generatingForHospital(hospital, userId);
                }

                if (data['Status'] == "accepted"){
                  timer.cancel();

                  var currentHospital = data['hospital_user_id'];
                  if (data['Travel Mode'] == "AMBULANCE"){
                    return ambulanceWidget(data: currentHospital);
                  }
                  return privateWidget(data: currentHospital);
                }
                if (data['Status'] == "rejected"){
                  timer.cancel();

                  generatingForHospital(hospital, userId);
                }
              }
              else if (widget.hospitalList.length == 1){
                if (data!['Status'] == "pending"){
                  startTimer();
                  while(timer.tick < 360){
                    print(timer.tick);
                    return pendingWidget();
                  }
                  generatingForHospital(hospital, userId);
                }
                if (data['Status'] == "accepted"){
                  timer.cancel();

                  var currentHospital = data['hospital_user_id'];
                  if (data['Travel Mode'] == "AMBULANCE"){
                    return ambulanceWidget(data: currentHospital);
                  }
                  return privateWidget(data: currentHospital);

                }
                if (data['Status'] == "rejected"){
                  timer.cancel();
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
              return const Center(child: Text('Loading..'));
            }
        )
    );
  }

  Widget pendingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("We are currently contacting the nearest hospital that can accommodate you..."),
        ),
        TextButton(
          onPressed: () {
            showDialog(context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are you sure you want to cancel the request?",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),),
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

  Widget ambulanceWidget({required data}){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 5  horizontally
              1.0, // Move to bottom 5 Vertically
            ),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/red_check.png',
                  ),
                  fit: BoxFit.cover,)
            ),
          ),
          const SizedBox(height: 18.0,),
          Text("$data \n will accommodate you/the patient.",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30.0,),
          const Text("An ambulance is coming for you. Please wait shortly for their arrival",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50.0,),
          RawMaterialButton(
            fillColor: Colors.white,
            elevation: 0.0,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: Colors.green, width: 2.0),
            ),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              deletePreviousRecord(userId);
            },
            child: const Text('CONFIRM ARRIVAL',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0,),
          const Text("Please confirm if the ambulance has arrived. Confirming will return you to the homepage.",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  }

  Widget privateWidget({required data}){
    return Container(
      width: double.infinity,
      //height: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 5  horizontally
              1.0, // Move to bottom 5 Vertically
            ),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/red_check.png',
                  ),
                  fit: BoxFit.cover,)
            ),
          ),
          const SizedBox(height: 18.0,),
          Text("$data \n will accommodate you/the patient.",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30.0,),
          const Text("Thank you, we will be waiting for you arrival at the hospital.",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50.0,),
          RawMaterialButton(
            fillColor: Colors.white,
            elevation: 0.0,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: Colors.green, width: 2.0),
            ),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Text('CONFIRM ARRIVAL',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0,),
          const Text("Please confirm if you have arrived. Confirming will return you to the homepage.",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  }


}
