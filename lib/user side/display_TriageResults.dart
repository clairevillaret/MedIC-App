import 'package:flutter/material.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';

class TriageResults extends StatelessWidget {
  final String name;
  final String age;
  final String concern;
  final String sex;
  final List selectedItems;
  const TriageResults({Key? key, required this.name, required this.age, required this.concern, required this.sex, required this.selectedItems}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var symptoms = selectedItems.toString().replaceAll('[', '').replaceAll(']', '');

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Age: $age'),
            Text('Sex: $sex'),
            Text('Concerns: $concern'),
            Text('Symptoms: $symptoms'),
          ],
        ),
      ),
    );
  }
}
