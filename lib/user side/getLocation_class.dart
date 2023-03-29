import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation{
  String currentAddress = '';
  Position? currentPosition;

  Future<String> determinePosition() async {
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

      currentPosition = position;
      currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

      //print("getLocation $currentAddress");
      print(currentPosition);
      return(currentAddress);
    }catch(e) {
      print(e);
    }
    throw '';
  }
}