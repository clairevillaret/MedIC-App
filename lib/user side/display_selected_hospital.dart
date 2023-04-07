import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    userId = widget.userID;
    print("init state $userId");
    hospital = widget.currentHospital;
    print("init state $hospital");
    super.initState();
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
          'Triage Result': triageCategory,
          'Travel Mode': travelMode,
          'Age': age,
          'Address': address,
          'Hospital User ID': hospital,
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
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong, sorry.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading..."));
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if(widget.hospitalList.length > 1){
                if (data!['Status'] == "pending"){
                  return const Center(child: Text("We are currently contacting the nearest hospital that can accommodate you..."));
                }
                if (data['Status'] == "accepted"){
                  var currentHospital = data['Hospital User ID'];
                  return Center(child: Text("We will send you to $currentHospital"));
                }
                if (data['Status'] == "rejected"){
                  generatingForHospital(hospital, userId);
                }
              }
              else if (widget.hospitalList.length == 1){
                if (data!['Status'] == "pending"){
                  return const Center(child: Text("We are currently contacting the nearest hospital that can accommodate you..."));
                }
                if (data['Status'] == "accepted"){
                  var currentHospital = data['Hospital User ID'];
                  return Column(
                    children: [
                      Text("We will send you to $currentHospital"),
                      TextButton(
                          onPressed: () {
                            //SystemNavigator.pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                          },
                          child: const Text("Confirm arrival"),
                      ),
                      //const Text("Confirming your arrival will exit you from the application"),
                    ],
                  );
                }
                if (data['Status'] == "rejected"){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sorry, we didn't find any hospital that can accommodate you as of the moment."),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                        },
                        child: const Text("Go to Homepage"),
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



}
