import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medic/user%20side/UI%20screens/emergency_result.dart';
import 'package:medic/user%20side/UI%20screens/non-urgent_result.dart';
import 'package:medic/user%20side/fetch_database.dart';
import 'package:medic/user%20side/triage_form.dart';
import 'dart:math';


class EmergencyCase extends StatefulWidget {
  const EmergencyCase({Key? key}) : super(key: key);

  @override
  //_EmergencyCaseState createState() => _EmergencyCaseState();
  State<EmergencyCase> createState() => _EmergencyCaseState();
}

class _EmergencyCaseState extends State<EmergencyCase>{
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('hospitals');

  List<Hospital> hospitalList = [];
  final Map<String, double> hospitalMap = {};
  var distances = [];

  String currentAddress = 'My Address';
  Position? _currentPosition;

  String nearestHospital = 'Nearest Hospital';

  @override
  void initState() {
    determinePosition();
    retrieveHospitalData();
    getDistance();
    showConnection();
    super.initState();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      Fluttertoast.showToast(msg: 'Please keep your location on');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        Fluttertoast.showToast(msg: 'Location Permission is denied');
      }
    }

    if(permission == LocationPermission.deniedForever){
      Fluttertoast.showToast(
          msg:
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try{
      List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];

      setState(() {
        _currentPosition = position;
        currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

      });
    }catch(e) {
      print(e);
    }
    throw '';
  }

  retrieveHospitalData() async {
    final snapshot = await FirebaseDatabase.instance.ref('hospitals').get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      final hospital = Hospital.fromMap(value);
      hospitalList.add(hospital);
      setState(() {});
    });
  }

  getDistance() async {
    Position currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = currentUserPosition;
    });

    for(int i = 0 ; i < hospitalList.length ; i++){
      double storedLat = hospitalList[i].latitude;
      double storedLong = hospitalList[i].longitude;

      var distance = Geolocator.distanceBetween(
          _currentPosition!.latitude, _currentPosition!.longitude, storedLat, storedLong);

      hospitalMap.addAll({hospitalList[i].name:distance});

    }
    debugPrint(hospitalMap.toString());

    var nearest = hospitalMap.values.cast<num>().reduce(min);

    hospitalMap.forEach((key, value){
      if(value == nearest){
        //debugPrint(key);
        setState(() {
          nearestHospital = key;
        });
      }
    });
  }

  // getTimeTravel() async {
  //   ByRoadDistanceCalculator distance = ByRoadDistanceCalculator();
  //
  //
  //   var distance = await distance.getDistance('YOUR API KEY',
  //       startLatitude,
  //       startLongitude,
  //       destinationLatitude,
  //       destinationLongitude,
  //       travelMode: TravelModes.bicycling);
  // }



  Future showConnection() async {
    await Future.delayed(const Duration(seconds: 3));

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("We will send you to $nearestHospital ",
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK",
                style: TextStyle(fontSize: 25.0),))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Triage Results"),
          const Text("TESTING PAGE",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.red)
          ),
          const SizedBox(height: 30.0,),
          const Text("Current Location:"),
          Text(currentAddress),
          Text(_currentPosition.toString()),
          Text('Latitude = ${_currentPosition?.latitude}'),
          Text('Longitude = ${_currentPosition?.longitude}'),
          RawMaterialButton(
            onPressed: () {},
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFba181b),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: const EdgeInsets.all(15.0),
                child: const Text('We are connecting you to a nearby hospital. Please wait...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),)
            ),
          ),
          RawMaterialButton(
            constraints: const BoxConstraints(),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyResult()));
            },
            child: const Text('Back',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
              ),
            ),
          ),
          // for(int i = 0 ; i < hospitalList.length ; i++)
          //   hospitalWidget(hospitalList[i]),
        ],
      )
      ),
    );
  }




}
