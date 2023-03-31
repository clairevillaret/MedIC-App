import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medic/user%20side/auto_get_hospital.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/hospital_select.dart';
import 'package:medic/user%20side/self_page.dart';
import 'package:medic/user%20side/userHospital_selection.dart';
import 'package:provider/provider.dart';

import '../manual_get_hospital.dart';
import '../saveTriageResults_class.dart';


class EmergencyResult extends StatefulWidget {
  final bool deviceLocation;

  const EmergencyResult({Key? key, required this.deviceLocation}) : super(key: key);

  @override
  State<EmergencyResult> createState() => _EmergencyResultState();
}

class _EmergencyResultState extends State<EmergencyResult> {
  String userAddress = "";
  String nearestHospital = "";
  String userLat = "";
  String userLong = "";
  String userID = "";

  saveHospital(hospital) async{
    FirebaseFirestore.instance.collection('hospitals_patients').doc(userID).update({"Hospital User ID": hospital});
    print("emergency result page saved: $userID");
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
                  const Text("EMERGENCY CASE",
                    style: TextStyle(
                        color: Color(0xFFba181b),
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 25.0,),
                  const Text("Needs Immediate Treatment",
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
                  const SizedBox(height: 50.0,),
                  //Text(widget.userId),
                  RawMaterialButton(
                    fillColor: const Color(0xFFba181b),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Color(0xFFba181b)),
                    ),
                    onPressed: () async {

                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const GetNearestHospital(startLat: userLat, startLong: startLong)));
                      //userAddress = context.read<SaveTriageResults>().userLatitude;

                      if (widget.deviceLocation == true){
                        userLat = context.read<SaveTriageResults>().userLatitude;
                        userLong = context.read<SaveTriageResults>().userLongitude;
                        nearestHospital = await AutoGetHospital(startLat: userLat, startLong: userLong).main();
                        print("nearest hospital: $nearestHospital");
                      }else{
                        userAddress = context.read<SaveTriageResults>().userAddress;
                        nearestHospital = await ManualGetHospital(userAddress).main();
                        print("nearest hospital: $nearestHospital");
                      }

                      setState(() {
                        userID = context.read<SaveTriageResults>().userId;
                      });
                      saveHospital(nearestHospital);

                    },
                    child: const Text('SELECT NEAREST HOSPITAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
