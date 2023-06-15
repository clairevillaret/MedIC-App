import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';


class compute_distance_between{
  String startLat;
  String startLong;
  String destlat;
  String destlong;

  compute_distance_between({required this.startLat, required this.startLong, required this.destlat, required this.destlong});

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
            return (element['duration_in_traffic']['text']);
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
      String timeTravel = await computeDistance(
        startLatitude: startLat,
        startLongitude: startLong,
        endLatitude: destlat,
        endLongitude: destlong,
        trafficModel: 'best_guess', //integrates live traffic information
        departureTime: 'now',
      );
      return timeTravel;
  }

}