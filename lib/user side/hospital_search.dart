import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/show_availability.dart';

class HospitalSearch extends StatefulWidget {
  const HospitalSearch({Key? key}) : super(key: key);

  @override
  State<HospitalSearch> createState() => _HospitalSearchState();
}

class _HospitalSearchState extends State<HospitalSearch> {
  final CollectionReference hospitals = FirebaseFirestore.instance.collection('hospitals');

  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }



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
        centerTitle: true,
        title: const Text(
          'Hospitals',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(5, 50),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  // height: 40.0,
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
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: hospitals.orderBy("Name").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
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
      ),
    );
  }

  Widget customWidget({required documentSnapshot}){
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: const EdgeInsets.all(10),
      //height: 160.0,
      // height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('images/placeholder.png'), // Placeholder
                foregroundImage: NetworkImage(documentSnapshot['Pic_url']), // Profile
              ),
              const SizedBox(width: 8.0),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        documentSnapshot['Name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Icon(Icons.call, size: 20.0,color: Colors.red,),
                          Text(
                            documentSnapshot['Contact_num'].toString())
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, size: 20.0, color: Colors.red,),
                          Flexible(
                            child: Text(
                              documentSnapshot['Address'].toString(),
                              overflow: TextOverflow.visible,
                              style: const TextStyle(height: 1.3),
                            ),
                          ),
                        ],
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
        ],
      ),
    );

  }

}
