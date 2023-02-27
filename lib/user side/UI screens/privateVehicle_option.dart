import 'package:flutter/material.dart';
import 'package:medic/user%20side/ambulance_request.dart';


class CarArrival extends StatefulWidget {
  const CarArrival({Key? key}) : super(key: key);

  @override
  State<CarArrival> createState() => _CarArrivalState();
}

class _CarArrivalState extends State<CarArrival> {
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
                          image: AssetImage('images/car.png',
                          ),
                          fit: BoxFit.cover,)
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  const Text("DO NOT CLOSE THE APPLICATION",
                    style: TextStyle(
                      color: Color(0xFFba181b),
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0,),
                  const Text("We'll be waiting for your arrival",
                    style: TextStyle(
                        color: Color(0xFFba181b),
                      fontSize: 20.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 90.0,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
