import 'package:flutter/material.dart';
import 'package:medic/user%20side/list_hospital.dart';
import 'package:medic/user%20side/triage_form.dart';

class SelectHospital extends StatefulWidget {
  const SelectHospital({Key? key}) : super(key: key);

  @override
  //_SelectHospitalState createState() => _SelectHospitalState();
  State<SelectHospital> createState() => _SelectHospitalState();
}

class _SelectHospitalState extends State<SelectHospital>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Triage Results"),
          const Text("EMERGENCY CASE",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.red)
          ),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ListHospital()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFba181b),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(15.0),
                child: const Text('Select a hospital',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),)
            ),
          ),
          RawMaterialButton(
            constraints: const BoxConstraints(),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TriageForm()));
            },
            child: const Text('Back',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
              ),
            ),
          ),

        ],
      )

        //Text("Triage Form"),

      ),
    );
  }

}
