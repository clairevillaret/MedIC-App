import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const FellowSelf()));
            },
          ),
          title: const Text("Availability of Services",
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          )
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 2),
        padding: const EdgeInsets.all(10),
        height: 140.0,
        child: Column(
          children: [
            Expanded(
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
                      children: [
                        Expanded(
                          child: Text(
                            documentSnapshot["Name"],
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              //height: 2.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('Emergency Room: ',style: TextStyle(fontSize: 16.0),),
                              Text(
                                documentSnapshot['use_services']["Emergency Room"]["availability"].toString(),
                                style: const TextStyle(fontSize: 16.0),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('Private Room: ',style: TextStyle(fontSize: 16.0),),
                              Text(
                                documentSnapshot['use_services']["Private Room"]["availability"].toString(),
                                style: const TextStyle(fontSize: 16.0),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('Labor Room: ',style: TextStyle(fontSize: 16.0),),
                              Text(
                                documentSnapshot['use_services']["Labor Room"]["availability"].toString(),
                                style: const TextStyle(fontSize: 16.0),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Text('General Ward: ',style: TextStyle(fontSize: 16.0),),
                              Text(
                                documentSnapshot['use_services']["General Ward"]["availability"].toString(),
                                style: const TextStyle(fontSize: 16.0),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
