import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medic/paramedic user/appbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medic/paramedic user/get_patient_info.dart';
import 'compute_distance.dart';


class Online extends StatefulWidget {
  const Online({Key? key}) : super(key: key);

  @override
  State<Online> createState() => _Online();
}

class _Online extends State<Online> {
  //Listening to changes
  late StreamSubscription<QuerySnapshot> _subscription;
  bool patient_complete = true;
  String fieldValue = '';
  String fieldValue1 = '';

  //patient id and hospital id and timeduration
  var patientinfoID;
  var hospitalinfoID;
  var computed_distance;
  var H_loc;
  var H_loc_Lat;
  var H_loc_Long;

  //User's Assigned patient
  String assignedPatientID = '';

  //Proximity Checking
  final double proximityThreshold = 100;
  bool showAlert = false;
  double destinationLat = 0;
  double destinationLong = 0;

  //Patient Info, class initializations
  final testService = FirebaseService();
  final patientID = patientId();
  final users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;

  //Polypoints or routes of the map between locations
  List<LatLng> _polylineCoordinates = [];

  Future<List<LatLng>> getPolyPoints(latitude1, longitude1, latitude2,
      longitude2) async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAS8T5voHU_bam5GCQIELBbWirb9bCZZOA",
      PointLatLng(latitude1, longitude1),
      PointLatLng(latitude2, longitude2),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  //Marker Section of the map
  Set<Marker> _markers = {};

  void _addMarker(LatLng position, String markerId) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
        ),
      );
    });
  }

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  //Position Values
  Position? currentPosition;
  LatLng newloc = LatLng(14.345999, 121);
  StreamSubscription<Position>? positionStream;

  @override
  void dispose() {
    positionStream?.cancel();
    _subscription?.cancel();
    patientID.updateUserStatusField("availability", "Offline", "");
    super.dispose();

    /// don't forget to cancel stream once no longer needed
  }

  @override
  void initState() {
    super.initState();
    listenToLocationChanges();
    listenToFieldValueUpdates();
    //streaming and listening to changes
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar('MedIC'),
      body: WillPopScope(
        onWillPop: () async {
          bool shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                  child: Text(
                    'Going Offline?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inria Sans',
                      color: Color(0xFFA60101),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(32.0))),
                actions: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          patientID.updateUserStatusField(
                              "availability", "Offline", "");
                          _markers.clear();
                          _polylineCoordinates.clear();
                          dispose();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Color.fromRGBO(123, 189,
                              99, 1)),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent.withOpacity(
                              0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: VerticalDivider(
                          width: 0,
                          thickness: 1,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text(
                          'No',
                          style: TextStyle(color: Color.fromRGBO(227, 0,
                              42, 1)),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent.withOpacity(
                              0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          return shouldPop;
        },
        child: SlidingUpPanel(
          // maxHeight: 550,
          panel: Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: users.where('Email', isEqualTo: user.email).get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var result1 = snapshot.data?.docs[0].get(
                              'assigned_patient')['assign_patient'];
                          var status = snapshot.data?.docs[0].get('status');
                          var availability = snapshot.data?.docs[0].get(
                              'availability');
                          var time = snapshot.data?.docs[0].get(
                              'time remaining');
                          var patientHospital = snapshot.data?.docs[0].get(
                              'assigned_patient')['hospital_id'];
                          patientinfoID = result1;
                          hospitalinfoID = patientHospital;
                          return Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(15, 15, 0, 0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Icon(
                                              Icons.medical_information,
                                              // Replace with your desired icon
                                              size: 30.0,
                                              // Customize the icon size
                                              color: Color(
                                                  0xFFba181b), // Customize the icon color
                                            ),
                                            const Text(
                                              'Paramedic Status',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    195, 0, 36, 1),
                                              ),
                                            ),
                                            Text(
                                              "$availability",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    54, 205, 1, 1),
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(15, 15, 15, 5),
                                      child: Row(
                                          children: [
                                            const Text(
                                              'Status: ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    195, 0, 36, 1),
                                              ),
                                            ),
                                            Text(
                                              "$status",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1),
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 0,
                                thickness: 2,
                              ),
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15, 15, 0, 0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Icon(
                                          Icons.personal_injury,
                                          // Replace with your desired icon
                                          size: 30.0, // Customize the icon size
                                          color: Color(
                                              0xFFba181b), // Customize the icon color
                                        ),
                                        Text(
                                          'Patient Information',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),
                                          ),
                                        ),
                                      ]
                                  )
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 5, 0, 0),
                                child:
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child:
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15, 5, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Name:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),),
                                        ),
                                        status == 'Unassigned' || status == '' ? const Text(
                                            "None") : patientInfo(
                                            "Name", "$result1",
                                            "$patientHospital"),
                                        Text(
                                          'Age: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),),
                                        ),
                                        status == 'Unassigned' || status == '' ? const Text(
                                            "None") : patientInfo(
                                            "Age", "$result1",
                                            "$patientHospital"),
                                        Text(
                                          'Sex:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),),
                                        ),
                                        status == 'Unassigned' || status == '' ? const Text(
                                            "None") : patientInfo(
                                            "Sex", "$result1",
                                            "$patientHospital"),
                                        Text(
                                          'Contact Number:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),),
                                        ),
                                        status == 'Unassigned' || status == '' ? const Text(
                                            "None") : patientInfo(
                                            "Contact Number", "$result1",
                                            "$patientHospital"),
                                        Text(
                                          'Concerns:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),),
                                        ),
                                        status == 'Unassigned' || status == '' ? const Text(
                                            "None") : patientInfo(
                                            "Main Concerns", "$result1",
                                            "$patientHospital"),
                                        Text(
                                          'Symptoms:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),),
                                        ),
                                        status == 'Unassigned' || status == '' ? const Text(
                                            "None") : patientInfo(
                                            "Symptoms", "$result1",
                                            "$patientHospital"),
                                      ],
                                    ),
                                  ),

                                ),
                              ),
                              const Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Divider(
                                  height: 0,
                                  thickness: 2,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      15, 15, 0, 5),
                                  child: Row(
                                      children: [
                                        Icon(
                                          Icons.alarm,
                                          // Replace with your desired icon
                                          size: 30.0, // Customize the icon size
                                          color: Color(
                                              0xFFba181b), // Customize the icon color
                                        ),
                                        Text(
                                          'ETA: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                195, 0, 36, 1),
                                          ),
                                        ),
                                        status == 'Unassigned' ? const Text(
                                            "None") : Text(
                                          "$time",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                      ]
                                  )
                              ),
                            ],
                          );
                        }
                        return CircularProgressIndicator();
                      }
                  ),
                ]
            ),
          ),
          body:
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: newloc, // Initial map position
              zoom: 5,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set.of(_markers),
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: _polylineCoordinates,
                color: Colors.blue,
                width: 4,
              ),
            },
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
    );
  }

  void listenToFieldValueUpdates() {
    // Replace 'users' with your actual Firestore collection
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: user.email)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        setState(() {
          fieldValue = 'No data found';
        });
      } else {
        var data = snapshot.docs.first.data() as Map<String,
            dynamic>; // Cast to the expected type
        setState(() {
          fieldValue = data["status"] ?? 'Field not found';
        });
        if (fieldValue == 'Assigned' && patient_complete == true) {
          _showAssignmentAlertDialog();
          patient_complete = false;
        }
      }
    });
  }

  void listenToLocationChanges() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
              (Position? position) {
            setState(() {
              currentPosition = position;
              print(currentPosition);
              LatLng currentloc = LatLng(
                  currentPosition!.latitude, currentPosition!.longitude);
              _addMarker(currentloc, "current Location");
              animateToLocation(currentloc);

              if (destinationLat != 0 && destinationLong != 0) {
                updatePolyPoints();
              }

              patientID.updateUserStatusField(
                  "Location", currentPosition!.latitude.toString(),
                  currentPosition!.longitude.toString());

              double distanceInMeters = Geolocator.distanceBetween(
                currentPosition!.latitude,
                currentPosition!.longitude,
                destinationLat,
                destinationLong,
              );

              if (distanceInMeters <= proximityThreshold && !showAlert) {
                //Code to check if marker is for hospital
                final List<Marker> markerList = _markers.toList();
                Marker? hospitalMarker;

                for (final marker in markerList) {
                  if (marker.markerId.value == 'Hospital Location') {
                    hospitalMarker = marker;
                    break;
                  }
                }

                if (hospitalMarker != null) {
                  _showHospitalAlertDialog();
                } else {
                  _showProximityAlertDialog();
                }
              }
            });
          },

        );
  }

  void animateToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(location, 18),
    );
  }

  void _showProximityAlertDialog() {
    showAlert = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
            content:
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
              child: Text(
                "Have you arrived at the Patient's Location?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria Sans',
                  color: Color(0xFFA60101),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(32.0))),
            actions: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _markers.removeWhere((marker) =>
                      marker.markerId.value == 'Patient Location');
                      _polylineCoordinates.clear();
                      showAlert = false;
                      patientID.updatePatientStatusField(
                          "Status", "Incoming", patientinfoID, hospitalinfoID);
                      getHospitalLocation();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent.withOpacity(
                          0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Color.fromRGBO(123, 189,
                          99, 1)),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      width: 0,
                      thickness: 1,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showAlert = false; // Dismiss the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent.withOpacity(
                          0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(color: Color.fromRGBO(227, 0,
                          42, 1)),
                    ),
                  ),
                ],
              ),
            ],
          );
      },
    );
  }

  void _showHospitalAlertDialog() {
    showAlert = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
            content:
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
              child: Text(
                'Have you arrived at the Hospital?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria Sans',
                  color: Color(0xFFA60101),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(32.0))),
            actions: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _markers.removeWhere((marker) =>
                      marker.markerId.value == 'Hospital Location');
                      _polylineCoordinates.clear();
                      patient_complete = true;
                      patientID.updateUserStatusField(
                          "status", "Unassigned", "");
                      patientID.updatePatientStatusField(
                          "Service in use",
                          "Emergency Room",
                          patientinfoID,
                          hospitalinfoID);
                      patientID.updatePatientStatusField(
                          "Status",
                          "In-Patient",
                          patientinfoID,
                          hospitalinfoID);
                      patientID.updatePatientStatusField(
                          "time remaining",
                          "",
                          patientinfoID,
                          hospitalinfoID);
                      showAlert = false;
                      destinationLat = 0.0;
                      destinationLong = 0.0;
                      setState(() {});
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Color.fromRGBO(123, 189,
                          99, 1)),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent.withOpacity(
                          0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      width: 0,
                      thickness: 1,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Dismiss the dialog
                      showAlert = false;
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: Color.fromRGBO(227, 0,
                          42, 1)),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent.withOpacity(
                          0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
      },
    );
  }

  void _showAssignmentAlertDialog() {
    showAlert = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
            content:
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
              child: Text(
                "You've been assigned to a patient",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria Sans',
                  color: Color(0xFFA60101),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(32.0))),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Dismiss the dialog
                  try {
                    var snapshot = await users.where(
                        'Email', isEqualTo: user.email).get();
                    var result1 = snapshot.docs[0].get(
                        'assigned_patient')['assign_patient'];
                    var result2 = snapshot.docs[0].get(
                        'assigned_patient')['hospital_id'];
                    var locationValue = await testService.getFieldData(
                        result1, "Location", result2);
                    computed_distance = await compute_distance_between(
                        startLat: currentPosition!.latitude.toString(),
                        startLong: currentPosition!.longitude.toString(),
                        destlat: locationValue['Latitude'],
                        destlong: locationValue['Longitude']).main();
                    setState(() {
                      destinationLat =
                          double.tryParse(locationValue['Latitude']) ?? 0.0;
                      destinationLong =
                          double.tryParse(locationValue['Longitude']) ?? 0.0;
                      patientID.updateUserStatusField(
                          "time remaining", "$computed_distance", "");
                    });
                    _addMarker(
                      LatLng(
                        destinationLat,
                        destinationLong,
                      ),
                      'Patient Location',
                    );
                    List<LatLng> coordinates = await getPolyPoints(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                      destinationLat,
                      destinationLong,
                    );
                    setState(() {
                      _polylineCoordinates = coordinates;
                    });
                  } catch (e) {
                    print('Error fetching location data: $e');
                  }
                  showAlert = false;
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Color.fromRGBO(227, 0,
                      42, 1)),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent.withOpacity(
                      0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
      },
    );
  }

  void updatePolyPoints() async {
    List<LatLng> coordinates = await getPolyPoints(
      currentPosition!.latitude,
      currentPosition!.longitude,
      destinationLat,
      destinationLong,
    );
    _polylineCoordinates.clear();
    setState(() {
      _polylineCoordinates = coordinates;
    });
  }

  Future<void> getHospitalLocation() async {
    var HospitallocationValue = await testService.getHospitalLocation(
        "Location", hospitalinfoID);

    destinationLat = double.tryParse(HospitallocationValue['Latitude']) ?? 0.0;
    destinationLong =
        double.tryParse(HospitallocationValue['Longitude']) ?? 0.0;

    computed_distance = await compute_distance_between(
      startLat: currentPosition!.latitude.toString(),
      startLong: currentPosition!.longitude.toString(),
      destlat: destinationLat.toString(),
      destlong: destinationLong.toString(),
    ).main();

    _addMarker(
      LatLng(
        destinationLat,
        destinationLong,
      ),
      'Hospital Location',
    );

    List<LatLng> coordinates = await getPolyPoints(
      currentPosition!.latitude,
      currentPosition!.longitude,
      destinationLat,
      destinationLong,
    );

    _polylineCoordinates = coordinates;
    patientID.updateUserStatusField("time remaining", "$computed_distance", "");

    setState(() {
      // Update the UI
    });
  }
}




