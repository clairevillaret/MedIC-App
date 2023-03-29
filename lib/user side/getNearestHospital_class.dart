import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class GetNearestHospital {
  late final String currentAddress;

  GetNearestHospital(this.currentAddress);

  final CollectionReference hospitals = FirebaseFirestore.instance.collection('hospitals');

  final Map<String, dynamic> hospitalData = {};
  final Map<String, dynamic> hospitalMap = {};

  String nearestHospital = "nearest hospital";

  Future computeDistance({
    required String destination,
    required String origin,
    required String trafficModel,
    required String departureTime,
  }) async {
    //String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLatitude,$endLongitude&origins=$startLatitude,$startLongitude&traffic_model=$trafficModel&departure_time=$departureTime&key=AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA';
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&&traffic_model=$trafficModel&departure_time=$departureTime&key=AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA';

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        // print(response.data);
        for (var row in response.data['rows']) {
          for (var element in row['elements']) {
            //print(element['duration_in_traffic']['value']);
            return (element['duration_in_traffic']['value']);
          }
        }
      }
      else {
        print(response.statusCode);
        return;
      }
    }
    catch (e) {
      print(e);
    }
  }


  Future<String> main() async {
    print("check $currentAddress");
    var data = await FirebaseFirestore.instance.collection('hospitals').get();
    for (var document in data.docs) {
      Map<String, dynamic> data = document.data();
      var timeTravel = await computeDistance(
        destination: data['Address'],
        origin: currentAddress,
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
    print(currentAddress);
    return nearestHospital;
  }

}

