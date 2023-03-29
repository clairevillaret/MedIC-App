import 'package:flutter/material.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';
import 'saveTriageResults_class.dart';

class ReceiveData extends StatefulWidget {
  const ReceiveData({Key? key, required this.payload,}) : super(key: key);

  final String payload;

  @override
  State<ReceiveData> createState() => _ReceiveDataState();
}

class _ReceiveDataState extends State<ReceiveData> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          //height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("PATIENT INFORMATION",
                  style: TextStyle(
                    color: Color(0xFFba181b),
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 30.0,),
              const Text("Name:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.getName,
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),);
                  },
                ),
              ),
              const Text("Age:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.getAge,
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),);
                  },
                ),
              ),
              const Text("Sex:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.getSex,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),);
                  },
                ),
              ),
              const Text("Address:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.getAddress,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),);
                  },
                ),
              ),
              const Text("Main Complaint/s:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.getConcerns,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),);
                  },
                ),
              ),
              const Text("Symptoms:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text("${SaveTriageResults.getSymptoms}",
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600));
                  },
                ),
              ),
              const Text("Triage Result:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.triageCategory,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xFFba181b) ));
                  },
                ),
              ),
              const Text("Travel mode:", style: TextStyle(fontSize: 16.0),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SaveTriageResults>(
                  builder: (context, SaveTriageResults, child) {
                    return Text(SaveTriageResults.travelMode,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color(0xFFba181b)));
                  },
                ),
              ),
              const SizedBox(height: 40.0,),
              Center(
                child: RawMaterialButton(
                  fillColor: const Color(0xFFba181b),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Color(0xFFba181b)),
                  ),
                  onPressed: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const GetUserLocation()));
                  },
                  child: const Text('OKAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
