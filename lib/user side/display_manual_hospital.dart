
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ManualDisplayHospital extends StatefulWidget {
  final String currentHospital;
  final String userID;
  const ManualDisplayHospital({Key? key, required this.currentHospital, required this.userID}) : super(key: key);

  @override
  State<ManualDisplayHospital> createState() => _ManualDisplayHospitalState();
}

class _ManualDisplayHospitalState extends State<ManualDisplayHospital> {
  final CollectionReference patients = FirebaseFirestore.instance.collection('hospitals_patients');
  String hospital = "";
  String userId = "";

  @override
  void initState() {
    hospital = widget.currentHospital;
    print("init state $hospital");
    userId = widget.userID;
    print("init state $userId");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: patients.doc(userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              var data = snapshot.data;
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong, sorry.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading..."));
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData){
                if (data!['Status'] == "pending"){
                  return const Center(child: Text("We are currently contacting the hospital you selected to accommodate you..."));
                }
                if (data['Status'] == "accepted"){
                  var currentHospital = data['Hospital User ID'];
                  return Center(child: Text("We will send you to $currentHospital"));
                }
                if (data['Status'] == "rejected"){
                  //generatingForHospital(hospital, userId);
                  return Column(
                    children: [
                      const Center(child: Text("The hospital you selected cannot accommodate you as of the moment. Please select a new hospital.")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Go back")
                      )
                    ],
                  );
                }
              }

              return const Center(child: Text('Error'));
            }
        )
    );
  }
}
