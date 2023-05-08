import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/display_manual_hospital.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:medic/user%20side/show_availability.dart';
import 'package:provider/provider.dart';

class HospitalSelect extends StatefulWidget {
  const HospitalSelect({Key? key}) : super(key: key);

  @override
  State<HospitalSelect> createState() => _HospitalSelectState();
}

class _HospitalSelectState extends State<HospitalSelect> {
  final CollectionReference hospitals = FirebaseFirestore.instance.collection('hospitals');

  TextEditingController searchController = TextEditingController();
  String selectedHospital = "";
  String userID = "";

  createDocument(hospital) async {
    String name = context.read<SaveTriageResults>().userName;
    String birthday = context.read<SaveTriageResults>().userBirthday;
    String age = context.read<SaveTriageResults>().userAge;
    String sex = context.read<SaveTriageResults>().userSex;
    String address = context.read<SaveTriageResults>().userAddress;
    String mainConcern = context.read<SaveTriageResults>().mainConcern;
    List symptoms = context.read<SaveTriageResults>().symptoms;
    String triageCategory = context.read<SaveTriageResults>().triageCategory;
    String travelMode = context.read<SaveTriageResults>().travelMode;
    String status = context.read<SaveTriageResults>().status;
    String userLat = context.read<SaveTriageResults>().userLatitude;
    String userLong = context.read<SaveTriageResults>().userLongitude;

    await FirebaseFirestore.instance.collection('hospitals_patients').add({
      'Name:': name,
      'Birthday': birthday,
      'Sex': sex,
      'Main Concerns': mainConcern,
      'Symptoms': symptoms.toList(),
      'triage_result': triageCategory,
      'Travel Mode': travelMode,
      'Age': age,
      'Address': address,
      'hospital_user_id': hospital,
      'Status': status,
      'Location' : {
        'Latitude' : userLat.toString(),
        'Longitude': userLong.toString(),
      },
      'requested_time': Timestamp.now(),
    }).then((value) {
      //Provider.of<SaveTriageResults>(context, listen: false).saveUserId(value.id);
      userID = value.id;
      print(userID);
    });
    return userID;
  }

  sortHospitals() {
    String triageCategory = context.read<SaveTriageResults>().triageCategory;
    if (triageCategory == "Emergency Case"){
      return hospitals.orderBy("use_services.Emergency Room.availability", descending: true).snapshots();
    }
    else if (triageCategory == "Priority Case"){
      return hospitals.orderBy("use_services.Emergency Room.availability", descending: true).snapshots();
    }else{
      return hospitals.orderBy("use_services.General Ward.availability", descending: true).snapshots();
    }

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
                    controller: searchController,
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: sortHospitals(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }else{
              final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = docs[index];
                    final name = documentSnapshot['Name'];
                    //print(name);
                    if (searchController.text.isEmpty){
                      return customWidget(documentSnapshot: documentSnapshot);
                    }
                    else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                      return customWidget(documentSnapshot: documentSnapshot);
                    }else{
                      return Container(
                        color: Colors.white,
                      );
                    }
                  }
              );
            }

          }
      ),
    );
  }

  Widget customWidget({required documentSnapshot}){
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: const EdgeInsets.all(10),
      height: 160.0,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RawMaterialButton(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(documentSnapshot['Pic_url']),
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
                                documentSnapshot['Name'],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.call, size: 20.0,color: Colors.red,),
                                  Text(
                                    documentSnapshot['Contact_num'].toString(),
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
                                      documentSnapshot['Address'].toString(),
                                      style: const TextStyle(fontSize: 16.0),
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                RawMaterialButton(
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowAvailability(documentSnapshot: documentSnapshot,)));
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const ListHospital()));
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
                        )
                    )
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Select this hospital",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            selectedHospital = documentSnapshot['Name'];

                            print(selectedHospital);
                            userID = await createDocument(selectedHospital);

                            if (!mounted) return;
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ManualDisplayHospital(currentHospital:selectedHospital, userID: userID,)));
                          },
                          child: const Text("YES",
                            style: TextStyle(fontSize: 25.0),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("NO",
                            style: TextStyle(fontSize: 25.0),),
                        ),
                      ],
                    ),
                  );

                },
              ),
            ),
          ),
        ],
      ),
    );

  }

}
