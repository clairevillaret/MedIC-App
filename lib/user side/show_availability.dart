import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/hospital_search.dart';

class ShowAvailability extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const ShowAvailability({Key? key, required this.documentSnapshot}) : super(key: key);

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
              Navigator.pop(context);
            },
          ),
          title: const Text("Availability of Services",
            style: TextStyle(
            ),
          )
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 2),
        padding: const EdgeInsets.all(10),
        // height: 140.0,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage('images/placeholder.png'), // Placeholder
                  foregroundImage: NetworkImage(documentSnapshot['Pic_url']), // Pr
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        documentSnapshot["Name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          //height: 2.0,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: [
                          const Text('Emergency Room: '),
                          Text(
                            documentSnapshot['use_services']["Emergency Room"]["availability"].toString())
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Text('Private Room: '),
                          Text(
                            documentSnapshot['use_services']["Private Room"]["availability"].toString(),
                            )
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Text('Labor Room: '),
                          Text(
                            documentSnapshot['use_services']["Labor Room"]["availability"].toString(),
                            )
                        ],
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Text('General Ward: '),
                          Text(
                            documentSnapshot['use_services']["General Ward"]["availability"].toString(),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
