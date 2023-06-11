import 'package:flutter/material.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/self_page.dart';
import 'package:medic/user%20side/triage_form.dart';


class FellowSelf extends StatefulWidget {
  const FellowSelf({Key? key}) : super(key: key);

  @override
  State<FellowSelf> createState() => _FellowSelfState();
}

class _FellowSelfState extends State<FellowSelf>{
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
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()),  (Route<dynamic> route) => false,);
                },
              ),
            title: const Text("MedIC",
            style: TextStyle(
              letterSpacing: 2.0,
            ),
            )
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TriageForm()));
                            },
                            child: Image.asset('images/fellow.png',
                              height: 200.0,
                              width: 200.0,),
                          ),
                          const Text("Fill in personal data \nmanually",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          RawMaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SelfAutofill()));
                            },
                            child: Image.asset('images/self.png',
                              height: 200.0,
                              width: 200.0,),
                          ),
                          const Text("Auto-fill from personal \ninformation on app",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ))
                        ],
                      )
                    ),

                  ],
                ),
              ],
          ),
            )
        ),
      ),
      ),
    );
  }
}

