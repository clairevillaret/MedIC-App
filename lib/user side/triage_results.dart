import 'package:flutter/material.dart';

class TriageResults extends StatelessWidget {
  final String name;
  final String age;
  final String concern;
  const TriageResults({Key? key, required this.name, required this.age, required this.concern}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $name'),
              Text('Birthdate $age'),
              Text('Concerns: $concern')
            ],
          ),
        ),
      ),
    );
  }
}
