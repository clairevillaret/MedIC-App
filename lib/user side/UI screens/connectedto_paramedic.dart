import 'package:flutter/material.dart';
import 'package:medic/user%20side/ambulance_request.dart';
import 'package:medic/user%20side/UI%20screens/confirm_arrival.dart';
import 'package:medic/user%20side/UI%20screens/privateVehicle_option.dart';
import 'package:medic/user%20side/chat_room.dart';


class ConnectedToParamedic extends StatefulWidget {
  const ConnectedToParamedic({Key? key}) : super(key: key);

  @override
  State<ConnectedToParamedic> createState() => _ConnectedToParamedicState();
}

class _ConnectedToParamedicState extends State<ConnectedToParamedic> {
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
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/red_check.png',
                          ),
                          fit: BoxFit.cover,)
                    ),
                  ),
                  const SizedBox(height: 18.0,),
                  const Text("You are now connected to a paramedic.",
                    style: TextStyle(
                      color: Color(0xFFba181b),
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0,),
                  const Text("DO NOT CLOSE THE APPLICATION UNTIL AMBULANCE HAS ARRIVED",
                    style: TextStyle(
                      fontSize: 15.0,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 70.0,),
                  const Text("The ambulance is coming. \nYou can send them a message!",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25.0,),
                  RawMaterialButton(
                    fillColor: Colors.white,
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmArrival()));
                    },
                    child: const Text('MESSAGE',
                      style: TextStyle(
                        color: Colors.green,
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
