import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaveTriageResults extends ChangeNotifier {

  String userName = "";
  String userAge = "";
  String userSex = "";
  String userBirthday = "";
  String userAddress = "";
  String mainConcern = "";
  String triageCategory = "";
  String travelMode = "";
  String hospitalId = "";
  String status = "";
  List<String> symptoms = [];


  //create getter so we can access variable in other files
  List<String> get getSymptoms => symptoms;
  String get getName => userName;
  String get getAge => userAge;
  String get getSex => userSex;
  String get getBirthdate => userBirthday;
  String get getAddress => userAddress;
  String get getConcerns => mainConcern;
  String get getTriageCategory =>triageCategory;
  String get getTravelMode => travelMode;
  String get getHospitalId => hospitalId;
  String get getStatus => status;


  void addSymptom(String name) {
    symptoms.add(name);
    notifyListeners();
  }

  void removeSymptom(String name) {
    symptoms.remove(name);
    notifyListeners();
  }

  void clearList() {
    symptoms.clear();
    notifyListeners();
  }

  void saveName(String name) {
    userName = name;
    notifyListeners();
  }

  void saveAge(String age) {
    userAge = age;
    notifyListeners();
  }

  void saveBirthdate(String birthdate) {
    userBirthday = birthdate;
    notifyListeners();
  }

  void saveSex(String sex) {
    userSex = sex;
    notifyListeners();
  }
  void saveAddress(String address) {
    userAddress = address;
    notifyListeners();
  }

  void saveConcerns(String concern) {
    mainConcern = concern;
    notifyListeners();
  }

  void saveTriageCategory(String category) {
    triageCategory = category;
    notifyListeners();
  }

  void saveTravelMode(String type) {
    travelMode = type;
    notifyListeners();
  }

  void saveHospitalID(String id) {
    hospitalId = id;
    notifyListeners();
  }

  void saveStatus(String kind) {
    status = kind;
    notifyListeners();
  }

}