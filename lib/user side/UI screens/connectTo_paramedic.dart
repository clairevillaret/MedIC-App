import 'package:flutter/material.dart';
import 'package:medic/user%20side/ambulance_request.dart';


class ConnectingToParamedic extends StatefulWidget {
  const ConnectingToParamedic({Key? key}) : super(key: key);

  @override
  State<ConnectingToParamedic> createState() => _ConnectingToParamedicState();
}

class _ConnectingToParamedicState extends State<ConnectingToParamedic> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AmbulanceRequest()));
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
                    height: 120,
                    width: 120,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/ambulance.png',
                          ),
                          fit: BoxFit.cover,)
                    ),
                  ),
                  const SizedBox(height: 18.0,),
                  const Text("Connecting to a paramedic..",
                    style: TextStyle(
                        color: Color(0xFFba181b),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 90.0,),
                  const Text("DO NOT CLOSE THE APPLICATION",
                    style: TextStyle(
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40.0,),
                  const Text("An ambulance is on its way!",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFFba181b),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15.0,),
                  const Text("Please wait patiently, thank you",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
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
