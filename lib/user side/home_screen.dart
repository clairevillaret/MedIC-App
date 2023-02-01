import 'package:flutter/material.dart';
import 'package:medic/user%20side/fellowSelf_page.dart';
import 'package:medic/user%20side/settings.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/grid_background.jpg",),
                fit: BoxFit.cover)),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFba181b),
            leading: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              iconSize: 25.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
          backgroundColor: Colors.transparent,
          body: SafeArea(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    //margin: const EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 50.0),
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/lifeline.jpg',
                          ),
                          opacity: 0.4,
                          fit: BoxFit.cover,)
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FellowSelf()));
                        },
                        child: Image.asset('images/emergency_button.png',
                          height: 300.0,
                          width: 300.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ),
      ),
      ),
    );
  }
}

