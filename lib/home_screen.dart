import 'package:flutter/material.dart';
import 'package:medic/triage_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TriageForm()));
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFba181b),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: const Text('EMERGENCY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),)
              ),
            ),
          ],
        ),
        )
    );
  }
}

