import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medic/user%20side/ambulance_request.dart';
import 'package:medic/user%20side/fellowSelf_page.dart';
import 'package:medic/user%20side/hospital_search.dart';
import 'package:medic/user%20side/settings.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AmbulanceRequest()));
                },
                icon: const Icon(Icons.home,color: Colors.white,),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
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
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FellowSelf()));
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
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

