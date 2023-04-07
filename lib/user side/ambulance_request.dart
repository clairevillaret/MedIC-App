import 'package:flutter/material.dart';
import 'package:medic/user%20side/UI%20screens/connectTo_paramedic.dart';
import 'package:medic/user%20side/UI%20screens/connectedto_paramedic.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/UI%20screens/priority_result.dart';
import 'package:medic/user%20side/self_page.dart';

class AmbulanceRequest extends StatefulWidget {
  const AmbulanceRequest({Key? key}) : super(key: key);

  @override
  State<AmbulanceRequest> createState() => _AmbulanceRequestState();
}

class _AmbulanceRequestState extends State<AmbulanceRequest> {
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
          body: SafeArea(
            child: Container(
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
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/red_check.png',
                          ),
                          fit: BoxFit.cover,)
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  const Text("Request Accepted",
                    style: TextStyle(
                        color: Color(0xFFba181b),
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 25.0,),
                  const Text("Would you like an ambulance sent to your location?",
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
                  const SizedBox(height: 50.0,),
                  RawMaterialButton(
                    fillColor: const Color(0xFFba181b),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Color(0xFFba181b), width: 2.0),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectingToParamedic()));
                    },
                    child: const Text('YES, PLEASE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    //fillColor: const Color(0xFFba181b),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Color(0xFFba181b), width: 1.0),
                    ),
                    onPressed: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectedToParamedic()));
                    },
                    child: const Text('NO, THANK YOU',
                      style: TextStyle(
                        color: Color(0xFFba181b),
                        fontSize: 16.0,
                        letterSpacing: 1.5,
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
