import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/back_up/widgetClass_button.dart';
import 'package:medic/user%20side/filter_class.dart';
import 'widget_class.dart';

class SelectListHospital extends StatefulWidget {
  const SelectListHospital({Key? key}) : super(key: key);


  @override
  State<SelectListHospital> createState() => _SelectListHospitalState();
}



class _SelectListHospitalState extends State<SelectListHospital>{
  Query dbRef = FirebaseDatabase.instance.ref().child('hospitals');

  DatabaseReference firebaseRef = FirebaseDatabase.instance.ref().child('hospitals');

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFba181b),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size(5, 50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      /// code to search for hospital ///
                      controller: controller,
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "search hospital",
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    Map hospital = snapshot.value as Map;
                    hospital['key'] = snapshot.key;

                    final name = snapshot.child('name').value.toString();

                    if(controller.text.isEmpty){
                      return WidgetClassButton(hospital: hospital, name: name, db: dbRef,);
                    }
                    else if(name.toLowerCase().contains(controller.text.toLowerCase())){
                      return WidgetClassButton(hospital: hospital, name: name, db: dbRef,);
                    }
                    else{
                      return Container(
                        color: Colors.white,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}

