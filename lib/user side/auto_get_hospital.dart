import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';


class AutoGetHospital{
  String startLat;
  String startLong;
  AutoGetHospital({required this.startLat, required this.startLong});

  final CollectionReference hospitals = FirebaseFirestore.instance.collection('hospitals');

  final Map<String, dynamic> hospitalMap = {};

  String nearestHospital = "nearest hospital";

  Future computeDistance({
    required String startLatitude,
    required String startLongitude,
    required String endLatitude,
    required String endLongitude,
    required String trafficModel,
    required String departureTime,
  }) async {
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLatitude,$endLongitude&origins=$startLatitude,$startLongitude&traffic_model=$trafficModel&departure_time=$departureTime&key=AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA';
    //String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&&traffic_model=$trafficModel&departure_time=$departureTime&key=AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA';

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        //print(response.data);
        for (var row in response.data['rows']) {
          for (var element in row['elements']) {
            //print(element['duration_in_traffic']['value']);
            return (element['duration_in_traffic']['value']);
          }
        }
      }
      else {
        return;
      }
    }
    catch (e) {
      print(e);
    }
  }


  Future<String> main() async {
    var data = await FirebaseFirestore.instance.collection('hospitals').get();
    for (var document in data.docs) {
      Map<String, dynamic> data = document.data();

      var timeTravel = await computeDistance(
        startLatitude: startLat,
        startLongitude: startLong,
        endLatitude: data['Location']['Latitude'],
        endLongitude: data['Location']['Longitude'],
        trafficModel: 'best_guess', //integrates live traffic information
        departureTime: 'now',
      );


      hospitalMap.addAll({data['Name']: timeTravel});
    }
    print(hospitalMap);
    var nearest = hospitalMap.values.cast<num>().reduce(min);

    hospitalMap.forEach((key, value) {
      if (value == nearest) {
        nearestHospital = key;
      }
    });
    //print(hospitalMap);
    //print(nearestHospital);
    return nearestHospital;
  }

}

