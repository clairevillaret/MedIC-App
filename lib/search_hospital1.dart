import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/filter_class.dart';
import 'package:medic/user%20side/list_hospital.dart';
//import 'widget_class.dart';

class SearchHospital extends StatefulWidget {
  const SearchHospital({Key? key}) : super(key: key);


  @override
  State<SearchHospital> createState() => _SearchHospitalState();
}



class _SearchHospitalState extends State<SearchHospital>{
  Query dbRef = FirebaseDatabase.instance.ref().child('hospitals');
  DatabaseReference firebaseRef = FirebaseDatabase.instance.ref().child('hospitals');
  TextEditingController controller = TextEditingController();

  var filterSelected = 'All';

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
            'Hospitals',
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
                        child: const Text("All",
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
                      return customWidget(hospital: hospital);
                    }
                    else if(name.toLowerCase().contains(controller.text.toLowerCase())){
                      return customWidget(hospital: hospital);
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


  Widget customWidget({required Map hospital}){
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: const EdgeInsets.all(10),
      height: 160.0,
      //height: 200.0, 200 if we use expansion tile
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(hospital['pic_url']),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              hospital["name"],
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                height: 2.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.call, size: 20.0,color: Colors.red,),
                                Text(
                                  hospital["contact_num"].toString(),
                                  style: const TextStyle(fontSize: 16.0),)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, size: 20.0, color: Colors.red,),
                                Flexible(
                                  child: Text(
                                    hospital["location"].toString(),
                                    style: const TextStyle(fontSize: 16.0),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const Text("See Availability"),
                          Row(
                            children: [
                              RawMaterialButton(
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ListHospital()));
                                },
                                child: const Text('Check Availability',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFba181b),
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 20.0,color: Colors.red,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }

}

