import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WidgetClass extends StatelessWidget {
  final String name;
  final Query db;
  final dynamic hospital;
  const WidgetClass({Key? key, required this.name, required this.db, required this.hospital}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 2),
      padding: const EdgeInsets.all(10),
      height: 140.0,
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(hospital['pic_url']),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hospital["name"],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          height: 2.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ambulance: ',style: TextStyle(fontSize: 16.0),),
                          Text(
                            hospital['ambulance'],
                            style: const TextStyle(fontSize: 16.0),)
                        ],
                      ),
                      Row(
                        children: [
                          const Text('ER beds: ',style: TextStyle(fontSize: 16.0),),
                          Text(
                            hospital["er_bed"].toString(),
                            style: const TextStyle(fontSize: 16.0),)
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Private rooms: ',style: TextStyle(fontSize: 16.0),),
                          Text(
                            hospital["private_room"].toString(),
                            style: const TextStyle(fontSize: 16.0),)
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Wards: ',style: TextStyle(fontSize: 16.0),),
                          Text(
                            hospital["ward"].toString(),
                            style: const TextStyle(fontSize: 16.0),)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //const Divider(height: 5.0, color: Colors.black38,)
            ],
          ),
        ],
      ),
    );
  }
}
