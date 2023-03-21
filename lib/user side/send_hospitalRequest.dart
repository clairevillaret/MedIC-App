import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendHospitalRequest extends StatefulWidget {
  const SendHospitalRequest({Key? key}) : super(key: key);

  @override
  State<SendHospitalRequest> createState() => _SendHospitalRequestState();
}

class _SendHospitalRequestState extends State<SendHospitalRequest> {
  //DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('hospitals');

  final Map<String, double> hospitalMap = {};
  var distances = [];

  String currentAddress = 'My Address';
  String nearestHospital = 'Nearest Hospital';

  @override
  void initState() {
    showConnection();
    super.initState();
  }

  Future showConnection() async {
    await Future.delayed(const Duration(seconds: 2));
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("We will send you to $nearestHospital ",
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK",
                  style: TextStyle(fontSize: 25.0),))
          ],
        ));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("EMERGENCY CASE",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.red)
          ),
          const SizedBox(height: 30.0,),

          RawMaterialButton(
            constraints: const BoxConstraints(),
            onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyResult()));
            },
            child: const Text('Back',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
              ),
            ),
          ),
          // for(int i = 0 ; i < hospitalList.length ; i++)
          //   hospitalWidget(hospitalList[i]),
        ],
      )
      ),
    );
  }

}
