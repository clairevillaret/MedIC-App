import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saveTriageResults_class.dart';

class ReceiveData extends StatefulWidget {
  const ReceiveData({Key? key}) : super(key: key);

  @override
  State<ReceiveData> createState() => _ReceiveDataState();
}

class _ReceiveDataState extends State<ReceiveData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Consumer<SaveTriageResults>(
              builder: (context, SaveTriageResults, child) {
                return Text("Name: ${SaveTriageResults.getName}",
                style: const TextStyle(fontSize: 16.0),);
              },
            ),
            Consumer<SaveTriageResults>(
              builder: (context, SaveTriageResults, child) {
                return Text("Age: ${SaveTriageResults.getAge}",
                    style: const TextStyle(fontSize: 16.0),);
              },
            ),
            Consumer<SaveTriageResults>(
              builder: (context, SaveTriageResults, child) {
                return Text("Sex: ${SaveTriageResults.getSex}",
                  style: const TextStyle(fontSize: 16.0),);
              },
            ),
            Consumer<SaveTriageResults>(
              builder: (context, SaveTriageResults, child) {
                return Text("Main Complaint/s: ${SaveTriageResults.getConcerns}",
                  style: const TextStyle(fontSize: 16.0),);
              },
            ),
            Consumer<SaveTriageResults>(
              builder: (context, SaveTriageResults, child) {
                return Text("Symptoms: ${SaveTriageResults.symptoms}",
                  style: const TextStyle(fontSize: 16.0),);
              },
            ),
            Consumer<SaveTriageResults>(
              builder: (context, SaveTriageResults, child) {
                return Text("Triage Result: ${SaveTriageResults.triageCategory}",
                  style: const TextStyle(fontSize: 16.0),);
              },
            ),
          ],
        ),
      ),
    );
  }
}
