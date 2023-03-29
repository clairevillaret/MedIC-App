import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_services_dart/googles_maps_services_dart.dart';
import 'package:medic/main.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';



class CalculateDistance extends StatefulWidget {
  const CalculateDistance({Key? key}) : super(key: key);

  @override
  State<CalculateDistance> createState() => _CalculateDistanceState();
}

class _CalculateDistanceState extends State<CalculateDistance> {
  //final api = GooglesMapsServicesDart().getDirectionsAPIApi();

  final CollectionReference hospitals = FirebaseFirestore.instance.collection('hospitals');

  final Map<String, dynamic> hospitalData = {};
  final Map<String, dynamic> hospitalMap = {};

  String nearestHospital = 'Nearest Hospital';
  String currentAddress = 'UP Visayas, Miagao, 5023 Iloilo';
  Position? _currentPosition;



  Future computeDistance ({
    required String destination,
    required String origin,
    // required String startLatitude,
    // required String startLongitude,
    // required String endLatitude,
    // required String endLongitude,
    required String trafficModel,
    required String departureTime,
  }) async {
    //String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLatitude,$endLongitude&origins=$startLatitude,$startLongitude&traffic_model=$trafficModel&departure_time=$departureTime&key=AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA';
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&&traffic_model=$trafficModel&departure_time=$departureTime&key=AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA';

      try {
        var response = await Dio().get(url);
        if (response.statusCode == 200) {
          //print(response.data);
            for(var row in response.data['rows']){
              for (var element in row['elements']){
                //print(element['duration_in_traffic']['value']);
                return(element['duration_in_traffic']['value']);
              }
            }
        }
        else{
          print(response.statusCode);
          return;
        }
      }
      catch (e) {
        print(e);
      }

    }


  void main() async {
    var data = await FirebaseFirestore.instance.collection('hospitals').get();
    for (var document in data.docs) {
      Map<String, dynamic> data = document.data();
      var timeTravel = await computeDistance(
        destination: data['Address'],
        origin: currentAddress,
        // startLatitude: '10.7167612',
        // startLongitude: '122.5340853',
        // endLatitude: '10.71825',
        // endLongitude: '122.536949',
        trafficModel: 'best_guess', //integrates live traffic information
        departureTime: 'now',
      );
      hospitalMap.addAll({data['Name']:timeTravel});
    }
    var nearest = hospitalMap.values.cast<num>().reduce(min);

    hospitalMap.forEach((key, value){
      if(value == nearest){
        //debugPrint(key);
        setState(() {
          nearestHospital = key;
        });
      }
    });
    print(hospitalMap);
    print(nearestHospital);
    print(currentAddress);
  }


  @override
  void initState() {
    main();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Response from Google API'),
            Text(currentAddress),
            Text(_currentPosition.toString()),
            Text('Latitude = ${_currentPosition?.latitude}'),
            Text('Longitude = ${_currentPosition?.longitude}'),
            Text(nearestHospital),
          ],
        ),
      ),
    );
  }
}
