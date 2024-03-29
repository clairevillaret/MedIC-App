import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/filter_class.dart';
import 'widget_class.dart';

class ListHospital extends StatefulWidget {
  const ListHospital({Key? key}) : super(key: key);


  @override
  State<ListHospital> createState() => _ListHospitalState();
}



class _ListHospitalState extends State<ListHospital>{
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
          title: const Text(
            'Select hospital',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
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
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text("Filter by: ",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),),
                      TextButton(
                        onPressed: (){},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Color(0xFFba181b))))

                        ),
                        child: const Text("Nearby",
                          style: TextStyle(
                            color: Color(0xFFba181b),
                            fontSize: 18.0,
                          ),),
                      ),
                      TextButton(
                        onPressed: () {
                          //Query public = dbRef.orderByChild('type').equalTo('public').once() as Query;
                          //final public = firebaseRef.orderByChild('type').equalTo('public');

                          FilterClass(dbRef:dbRef, category: 'public');
                          setState ((){

                          });

                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Color(0xFFba181b))))

                        ),
                        child: const Text("Public",
                          style: TextStyle(
                            color: Color(0xFFba181b),
                            fontSize: 18.0,
                          ),),
                      ),
                      TextButton(
                        onPressed: (){},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Color(0xFFba181b))))

                        ),
                        child: const Text("Private",
                          style: TextStyle(
                            color: Color(0xFFba181b),
                            fontSize: 18.0,
                          ),),
                      ),
                      TextButton(
                        onPressed: (){},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Color(0xFFba181b))))

                        ),
                        child: const Text("Availability",
                          style: TextStyle(
                            color: Color(0xFFba181b),
                            fontSize: 18.0,
                          ),),
                      ),
                      TextButton(
                        onPressed: (){},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Color(0xFFba181b))))

                        ),
                        child: const Text("Specialty",
                          style: TextStyle(
                            color: Color(0xFFba181b),
                            fontSize: 18.0,
                          ),),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    Map hospital = snapshot.value as Map;
                    hospital['key'] = snapshot.key;

                    final name = snapshot.child('name').value.toString();

                    if(controller.text.isEmpty){
                      return WidgetClass(hospital: hospital, name: name, db: dbRef,);
                    }
                    else if(name.toLowerCase().contains(controller.text.toLowerCase())){
                      return WidgetClass(hospital: hospital, name: name, db: dbRef,);
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

