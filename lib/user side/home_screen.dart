import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medic/user%20side/fellowSelf_page.dart';
import 'package:medic/user%20side/hospital_search.dart';
import 'package:medic/user%20side/settings.dart';
import '../paramedic user/paramedic_profile.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DateTime backPressedTime = DateTime.now();
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  var userRole;

  final users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    getConnectivity();
    super.initState();
    getUserRole();
  }


  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      },
    );

  }

  Future<void> getUserRole() async {
    var role = await users.where('Email', isEqualTo: user.email).get();
    userRole = role.docs[0].get('Role');
  }



  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(backPressedTime);
        backPressedTime = DateTime.now();

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()),(route) => false);

        if(difference >= const Duration(seconds: 2)){
          Fluttertoast.showToast(msg: 'Click again to close the app');
          return false;
        }else{
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
      child: MaterialApp(
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/grid_background.jpg",),
                  fit: BoxFit.cover)),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFba181b),
              title: const Text("MedIC",
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalSearch()));
                  },
                  icon: const Icon(Icons.search,color: Colors.white,),
                ),
                IconButton(
                  onPressed: () {
                      if(userRole == "Paramedic"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ParamedPage()));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                      }
                    },
                  icon: const Icon(Icons.settings,color: Colors.white,),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 280.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Flexible(
                              child: Text('press this button ',
                                style: TextStyle(
                                  color: Color(0xFFba181b),
                                ),),
                            ),
                            Icon(Icons.arrow_downward,color: Color(0xFFba181b), size: 20.0,),
                            Text(' for emergency',
                              style: TextStyle(
                                color: Color(0xFFba181b),
                              ),),
                          ],
                        ),
                      ),
                      Container(
                        //margin: const EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 50.0),
                        height: 150,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/lifeline.jpg',
                              ),
                              opacity: 0.4,
                              fit: BoxFit.cover,)
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                              !isDeviceConnected
                                  ? () {Fluttertoast.showToast(msg: 'Internet Connection is required to proceed.'); null;}()
                                  : () {Navigator.push(context, MaterialPageRoute(builder: (context) => const FellowSelf()));}();

                            },
                            child: Image.asset('images/emergency_button.png',
                              height: 300.0,
                              width: 300.0,
                            ),
                          ),
                        ],
                      ),
                    ],
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
  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('Try again'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()),(route) => false);
          },
          child: const Text('Go to Homepage'),

        ),
      ],
    ),
  );

  Future<bool> onButtonClicked(BuildContext context) async {
    final difference = DateTime.now().difference(backPressedTime);
    backPressedTime = DateTime.now();

    if(difference >= const Duration(seconds: 2)){
      Fluttertoast.showToast(msg: 'Click again to close the app');
      return false;
    }else{
      //SystemNavigator.pop(animated: true);
      Fluttertoast.cancel();
      return true;
    }
  }
}
