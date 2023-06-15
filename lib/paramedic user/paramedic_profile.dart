import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medic/paramedic user/panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medic/paramedic user/appbar.dart';
import 'package:medic/paramedic user/paramedic_profile_SettingsButtons.dart';
import 'package:medic/user%20side/settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medic/paramedic user/get_patient_info.dart';
import '../user side/login_page.dart';




class ParamedPage extends StatefulWidget {
  const ParamedPage({Key? key}) : super(key: key);

  @override
  State<ParamedPage> createState() => _ParamedPageState();
}


class _ParamedPageState extends State<ParamedPage>{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;
  late bool serviceEnabled;
  late LocationPermission permission;

  void getLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      Fluttertoast.showToast(msg: 'Please keep your location on');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        Fluttertoast.showToast(msg: 'Location Permission is denied');
      }
    }

    if(permission == LocationPermission.deniedForever){
      Fluttertoast.showToast(
          msg:
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: const CustomAppBar('MedIC'),
          //Put content on body
          body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-0.05, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0.05, -0.8),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'images/ParaProfile.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: users.where('Email', isEqualTo: user.email).get(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              else
                              if (snapshot.connectionState == ConnectionState.done) {
                                return
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data?.docs[0].get('Full Name'),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                              }
                              return Text('An error has occurred: ${snapshot.error}');
                            }
                        ),
                        const Divider(
                          height: 1,
                          thickness: 4,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 150),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children:[
                                // CustomButton(
                                //     text: 'Profile Verification',
                                //     onPressed: () {
                                //     }
                                // ),
                                CustomButton(
                                    text: 'Profile Settings',
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                                    }
                                ),
                                // CustomButton(
                                //     text: 'Help',
                                //     onPressed: () {
                                //     }
                                // ),
                                CustomButton(
                                    text: 'Logout',
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut().then((value) =>
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()),(route) => false));
                                    }
                                ),
                                goOnline()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          )
      ),
    );
  }
}

class goOnline extends StatelessWidget {
  goOnline({super.key});

  //Patient Info, class initializations
  final patientID = patientId();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Report on Duty',
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content:
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
            child: Text(
              'Go Online?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inria Sans',
                color: Color(0xFFA60101),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(32.0))),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    patientID.updateUserStatusField("availability","Online","");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Online()));
                    },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Color.fromRGBO(123, 189,
                        99, 1)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent.withOpacity(
                        0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    width: 0,
                    thickness: 1,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text(
                    'No',
                    style: TextStyle(color: Color.fromRGBO(227, 0,
                        42, 1)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent.withOpacity(
                        0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
