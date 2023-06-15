import 'package:cloud_firestore/cloud_firestore.dart';
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

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFba181b),
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              iconSize: 25.0,
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()),  (Route<dynamic> route) => false,);
              },
            ),
            title: const Text("Settings",
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("User Information",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 2.0,
                  ),
                  Text("Logged in as ${user.email!}",textAlign: TextAlign.center,),
                  const SizedBox(height: 10.0,),
                  FutureBuilder(
                      future: users.where('Email', isEqualTo: user.email).get(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        else if(snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Name:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data?.docs[0].get('Full Name'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    const Text("Birthdate:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data?.docs[0].get('Birthdate'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Text("Contact Number:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data?.docs[0].get('Contact Number'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Text("Email:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data?.docs[0].get('Email'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Text("Address:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data?.docs[0].get('Address'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),

                                  ],
                                );
                              },
                            ),
                          );
                        }
                        return Text('An error has occurred: ${snapshot.error}');
                      }
                  ),
                  RawMaterialButton(
                    fillColor: const Color(0xFFba181b),
                    elevation: 0.0,
                    padding: const EdgeInsets.all(15),
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
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
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

