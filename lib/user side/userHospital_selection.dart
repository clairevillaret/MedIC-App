import 'package:flutter/material.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';

class UserHospitalSelection extends StatefulWidget {
  const UserHospitalSelection({Key? key}) : super(key: key);

  @override
  State<UserHospitalSelection> createState() => _UserHospitalSelectionState();
}

class _UserHospitalSelectionState extends State<UserHospitalSelection> {

  var address = "";
  var nearestHospital = "";

  @override
  void initState() {
    //address = context.read<SaveTriageResults>().getAddress;
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const Text("Get nearest hospital"),
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
          TextButton(
              onPressed: () {
                //GetNearestHospital("mandurriao").getCoordinates();
              },
              child: const Text("Testing"),
          )






        ],
      ),
    );
  }
}
