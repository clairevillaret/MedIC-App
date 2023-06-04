import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class AmbulanceWidget extends StatefulWidget {
  final String hospital;
  final String paramedicId;
  final String userId;
  const AmbulanceWidget({Key? key, required this.hospital, required this.paramedicId, required this.userId}) : super(key: key);

  @override
  State<AmbulanceWidget> createState() => _AmbulanceWidgetState();
}

class _AmbulanceWidgetState extends State<AmbulanceWidget> {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference patients = FirebaseFirestore.instance.collection('hospitals_patients');

  String hospital = "";
  String paramedicId = "";
  String userId = "";

  @override
  void initState() {
    hospital = widget.hospital;
    print("init state $hospital");
    paramedicId = widget.paramedicId;
    print("init state $paramedicId");
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
      body: StreamBuilder(
        stream: users.doc(paramedicId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var data = snapshot.data;
          if (snapshot.data != null) {
            if (!snapshot.data!.exists){
              return Container(
                color: Colors.white,
              );
            }
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong, sorry.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasData){
            return Container(
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
                  Text("$hospital \n will accommodate you/the patient.",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 70.0,),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/ambulance.png',
                          ),
                          fit: BoxFit.cover,)
                    ),
                  ),
                  const SizedBox(height: 18.0,),
                  const Text("The ambulance is coming...",
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0,),
                  Text("Estimated to arrive in: ${data!['time remaining']}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFFba181b),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50.0,),
                  const Text("Please confirm if the ambulance has arrived.",
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
            );
          }
          return const Center(child: Text('Error'));

        }
      ),
    );

  }
}
