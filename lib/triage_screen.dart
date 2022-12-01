import 'package:flutter/material.dart';
import 'package:medic/home_screen.dart';
import 'package:medic/select_hospital.dart';


class TriageForm extends StatefulWidget {
  const TriageForm({Key? key}) : super(key: key);

  @override
  //_TriageFormState createState() => _TriageFormState();
  State<TriageForm> createState() => _TriageFormState();
}

class _TriageFormState extends State<TriageForm>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Triage Form"),
          RawMaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectHospital()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFba181b),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(15.0),
                child: const Text('Submit Form',
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
