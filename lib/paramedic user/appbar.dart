import 'package:flutter/material.dart';
import 'package:medic/paramedic user/paramedic_profile.dart';
import 'package:medic/user%20side/hospital_search.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFba181b),
      title: Text(title,
        style: const TextStyle(
          fontSize: 20.0,
          letterSpacing: 2.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalSearch()));
          },
          icon: const Icon(Icons.search,color: Colors.white,),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ParamedPage()));
          },
          // async {
          //   var snapshot = await FirebaseFirestore.instance
          //       .collection('users')
          //       .doc(user.uid)
          //       .get();
          //   var fieldValue = snapshot.data()!['Role'];
          //   if (fieldValue == "Regular User") {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
          //   }else{
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => const ParamedPage()));
          //   }
          // },
          icon: const Icon(Icons.settings,color: Colors.white,),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
