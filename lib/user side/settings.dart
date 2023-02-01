import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/login_page.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  final user = FirebaseAuth.instance.currentUser!;

  // Future<void> signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFba181b),
            title: const Text("MedIC",
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search,color: Colors.white,),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
                icon: const Icon(Icons.home,color: Colors.white,),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
                icon: const Icon(Icons.settings,color: Colors.white,),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Logged in as ${user.email!}"),
                RawMaterialButton(
                  fillColor: const Color(0xFFba181b),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Color(0xFFba181b)),
                  ),
                  onPressed: () {
                    //signOut();
                    FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()),(route) => false));
                    },
                  child: const Text('Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],

            ),
          ),
    );
  }
}

