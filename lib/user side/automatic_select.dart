import 'package:flutter/material.dart';

class AutoSelect extends StatelessWidget {
  final String hospital;
  const AutoSelect({Key? key, required this.hospital}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 2),
      padding: const EdgeInsets.all(10),
      height: 140.0,
      child: Column(
        children: [
          Text("Sending a request to $hospital")
        ],
      ),
    );
  }
}
