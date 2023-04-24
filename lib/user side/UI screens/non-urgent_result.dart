import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/self_page.dart';
import 'package:provider/provider.dart';

import '../auto_get_hospital.dart';
import '../display_selected_hospital.dart';
import '../hospital_select.dart';
import '../manual_get_hospital.dart';
import '../saveTriageResults_class.dart';

class NonUrgentResult extends StatefulWidget {
  final bool deviceLocation;
  const NonUrgentResult({Key? key, required this.deviceLocation}) : super(key: key);

  @override
  State<NonUrgentResult> createState() => _NonUrgentResultState();
}

class _NonUrgentResultState extends State<NonUrgentResult> {
  final CollectionReference patients = FirebaseFirestore.instance.collection('hospitals_patients');

  String userAddress = "";
  String nearestHospital = "";
  String userLat = "";
  String userLong = "";
  String userID = "";

  Map<String, dynamic> hospitalMap = {};


  createDocument(hospital) async {
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
      //Provider.of<SaveTriageResults>(context, listen: false).saveUserId(value.id);
      userID = value.id;
      print(userID);
    });
    return userID;
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/grid_background.jpg",),
                fit: BoxFit.cover)),
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color(0xFFba181b),
              leading: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                iconSize: 25.0,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SelfAutofill()));
                },
              ),
              title: const Text("MedIC",
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              )
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
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
                  const Text("RESULT",
                    style: TextStyle(
                      color: Color(0xFFba181b),
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const Text("Triage Category:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                  const SizedBox(height: 70.0,),
                  const Text("NON-URGENT CASE",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 25.0,),
                  const Text("Can wait in the queue",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0,),
                  const Divider(
                    color: Colors.black12,
                    thickness: 2.0,
                  ),
                  const SizedBox(height: 30.0,),
                  const Text("Please choose the hospital that will accommodate you / the patient",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 45.0,),
                  RawMaterialButton(
                      fillColor: Colors.white,
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(color: Color(0xFFba181b), width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('images/nearest.png',
                            height: 60.0,
                            width: 60.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("NEAREST",
                                style: TextStyle(
                                  color: Color(0xFFba181b),
                                  fontSize: 18.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(" HOSPITAL",
                                style: TextStyle(
                                  color: Color(0xFFba181b),
                                  fontSize: 18.0,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      onPressed: () async {
                        if (widget.deviceLocation == true){
                          userLat = context.read<SaveTriageResults>().userLatitude;
                          userLong = context.read<SaveTriageResults>().userLongitude;
                          hospitalMap = await AutoGetHospital(startLat: userLat, startLong: userLong).main();
                          print("hospital list: $hospitalMap");

                          var nearest = hospitalMap.values.cast<num>().reduce(min);
                          hospitalMap.forEach((key, value) {
                            if (value == nearest) {
                              nearestHospital = key;
                            }
                          });
                          print(nearestHospital);

                          userID = await createDocument(nearestHospital);

                          if (!mounted) return;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplaySelectedHospital(hospitalList: hospitalMap, currentHospital: nearestHospital, userID: userID,)));

                        }else{
                          userAddress = context.read<SaveTriageResults>().userAddress;
                          hospitalMap = await ManualGetHospital(userAddress).main();
                          print("hospital list: $hospitalMap");

                          var nearest = hospitalMap.values.cast<num>().reduce(min);
                          hospitalMap.forEach((key, value) {
                            if (value == nearest) {
                              nearestHospital = key;
                            }
                          });
                          print(nearestHospital);

                          userID = await createDocument(nearestHospital);

                          if (!mounted) return;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplaySelectedHospital(hospitalList: hospitalMap, currentHospital: nearestHospital, userID: userID,)));
                        }
                      }
                  ),
                  const SizedBox(height: 10.0,),
                  RawMaterialButton(
                    fillColor: const Color(0xFFba181b),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Color(0xFFba181b)),
                    ),
                    onPressed: (){
                      //if (_formKey.currentState!.validate()){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalSelect()));
                      //}
                    },
                    child: const Text('SELECT HOSPITAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    constraints: const BoxConstraints(),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    },
                    child: const Text('CANCEL',
                      style: TextStyle(
                        color: Color(0xFFba181b),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
