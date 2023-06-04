import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class PrivateWidget extends StatefulWidget {
  final String hospital;
  final String userId;
  const PrivateWidget({Key? key, required this.hospital, required this.userId}) : super(key: key);

  @override
  State<PrivateWidget> createState() => _PrivateWidgetState();
}

class _PrivateWidgetState extends State<PrivateWidget> {
  final CollectionReference patients = FirebaseFirestore.instance.collection('hospitals_patients');
  String hospital = "";
  String userId = "";

  @override
  void initState() {
    hospital = widget.hospital;
    print("init state $hospital");
    userId = widget.userId;
    print("init state $userId");
    super.initState();
  }

  deletePreviousRecord(previousUid) {
    // delete patient record in last hospital
    patients.doc(previousUid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/red_check.png',
                    ),
                    fit: BoxFit.cover,)
              ),
            ),
            const SizedBox(height: 18.0,),
            Text("$hospital \n will accommodate you/the patient.",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50.0,),
            const Text("Thank you, we will be waiting for your arrival at the hospital.",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70.0,),
            const Text("Please confirm if you have arrived at the hospital",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0,),
            RawMaterialButton(
              fillColor: Colors.white,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(color: Colors.green, width: 2.0),
              ),
              onPressed: (){

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()),(route) => false);
                deletePreviousRecord(userId);
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
          ],
        ),
      ),
    );

  }
}
