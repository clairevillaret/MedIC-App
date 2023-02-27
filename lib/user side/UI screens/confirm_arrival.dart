import 'package:flutter/material.dart';
import 'package:medic/user%20side/ambulance_request.dart';
import 'package:medic/user%20side/home_screen.dart';


class ConfirmArrival extends StatefulWidget {
  const ConfirmArrival({Key? key}) : super(key: key);

  @override
  State<ConfirmArrival> createState() => _ConfirmArrivalState();
}

class _ConfirmArrivalState extends State<ConfirmArrival> {
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
                  const SizedBox(height: 15.0,),
                  const Text("Have you arrived at the hospital?",
                    style: TextStyle(
                      color: Color(0xFFba181b),
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60.0,),
                  RawMaterialButton(
                    fillColor: Colors.white,
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                  const Text("Confirming arrival will exit the application.",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20.0
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
