import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medic/user%20side/UI%20screens/emergency_result.dart';
import 'package:medic/user%20side/fellowSelf_page.dart';
import 'package:medic/user%20side/UI%20screens/non-urgent_result.dart';
import 'package:medic/user%20side/UI%20screens/priority_result.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:provider/provider.dart';

import 'checkbox_class.dart';
import 'getLocation_class.dart';


class SelfAutofill extends StatefulWidget {
  const SelfAutofill({Key? key}) : super(key: key);

  @override
  State<SelfAutofill> createState() => _SelfAutofillState();
}

class _SelfAutofillState extends State<SelfAutofill>{

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser;

  var userName = '';
  var userBirthday = '';
  final bdayController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  final formController = TextEditingController();
  List<String> sex = ['*Select sex*','Male','Female'];
  String selectedSex = '*Select sex*';
  String travelMode = "AMBULANCE";
  String hospitalUserId = "*hospital name*";
  String status = "pending";
  String currentAddress = "";
  Position? userLocation;
  double? userLat;
  double? userLong;

  bool requestAmbulance = true;
  bool privateVehicle = false;
  bool checkBoxValue = false;
  bool deviceLocation = false;

  bool checkAll = false;
  bool checkAll2 = false;
  bool checkAll3 = false;
  bool checkAll4 = false;
  bool checkAll5 = false; //priority signs (bleeding)
  List<CheckboxModel> airwayBreathing = <CheckboxModel>[];
  List<CheckboxModel> circulation = <CheckboxModel>[];
  List<CheckboxModel> disability = <CheckboxModel>[];
  List<CheckboxModel> lifeThreats = <CheckboxModel>[];
  List<CheckboxModel> bleeding = <CheckboxModel>[];
  List<CheckboxModel> prioritySigns = <CheckboxModel>[];

  List<String> selectedItems = [];
  List<String> listSymptoms = [];
  String triageResult = "";

  var countPriority = 0;
  var countEmergency = 0;

  toListSymptoms() {
    for (var item in selectedItems) {
      listSymptoms.add(item.toString());
    }
    return listSymptoms.toList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addressController.dispose();
    super.dispose();
  }

  generateTriageResults() {
    if (countEmergency > 0) {
      if (!mounted) return;
      triageResult = "Emergency Case";
      Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyResult(deviceLocation: deviceLocation)));
    } else if (countEmergency == 0 && countPriority > 0){
      if (!mounted) return;
      triageResult = "Priority Case";
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PriorityResult()));
    } else {
      triageResult = "Non-urgent Case";
      Navigator.push(context, MaterialPageRoute(builder: (context) => const NonUrgentResult()));
    }
  }

  saveTriageResults(){
    Provider.of<SaveTriageResults>(context, listen: false).saveName(userName);
    Provider.of<SaveTriageResults>(context, listen: false).saveBirthdate(userBirthday);
    Provider.of<SaveTriageResults>(context, listen: false).saveAge(ageController.text);
    Provider.of<SaveTriageResults>(context, listen: false).saveSex(selectedSex);
    Provider.of<SaveTriageResults>(context, listen: false).saveConcerns(formController.text);
    Provider.of<SaveTriageResults>(context, listen: false).saveTriageCategory(triageResult);
    Provider.of<SaveTriageResults>(context, listen: false).saveTravelMode(travelMode);
    Provider.of<SaveTriageResults>(context, listen: false).saveAddress(currentAddress);
    Provider.of<SaveTriageResults>(context, listen: false).saveHospitalID(hospitalUserId);
    Provider.of<SaveTriageResults>(context, listen: false).saveStatus(status);
    Provider.of<SaveTriageResults>(context, listen: false).saveUserLatitude(userLat.toString());
    Provider.of<SaveTriageResults>(context, listen: false).saveUserLongitude(userLong.toString());

  }

  Future<void> saveUserResults(
      String sex,
      String mainConcerns,
      String symptoms,
      String result,
      String travel,
      String age,
      String address,
      String hospitalId,
      String hospitalStatus,
      String latitude,
      String longitude,
      ) async {
    FirebaseFirestore.instance.collection('hospitals_patients').add({
      'Name:': userName,
      'Birthday': userBirthday,
      'Sex': sex,
      'Main Concerns': mainConcerns,
      'Symptoms': toListSymptoms(),
      'Triage Result': triageResult,
      'Travel Mode': travelMode,
      'Age': age,
      'Address': currentAddress,
      'Hospital User ID': hospitalId,
      'Status': hospitalStatus,
      'Location' : {
        'Latitude' : userLat.toString(),
        'Longitude': userLong.toString(),
      }
    }).then((value) {
      Provider.of<SaveTriageResults>(context, listen: false).saveUserId(value.id);
    });

  }


  @override
  void initState() {
    airwayBreathing.addAll({
      CheckboxModel(id: 1, name: "Appears obstructed", selected: false),
      CheckboxModel(id: 2, name: "Central cyanosis", selected: false),
      CheckboxModel(id: 3, name: "Severe respiratory distress", selected: false),
    });
    circulation.addAll({
      CheckboxModel(id: 1, name: "Weak or fast pulse", selected: false),
      CheckboxModel(id: 2, name: "Capillary refill>3 sec", selected: false),
      CheckboxModel(id: 3, name: "Heavy bleeding", selected: false),
      CheckboxModel(id: 4, name: "Severe trauma", selected: false),
    });
    disability.addAll({
      CheckboxModel(id: 1, name: "Altered level of consciousness", selected: false),
      CheckboxModel(id: 2, name: "Convulsing", selected: false),
      CheckboxModel(id: 3, name: "Stroke", selected: false),
    });
    lifeThreats.addAll({
      CheckboxModel(id: 1, name: "Severe abdominal pain and abdomen hard", selected: false),
      CheckboxModel(id: 2, name: "Severe headache", selected: false),
      CheckboxModel(id: 3, name: "Stiff neck", selected: false),
      CheckboxModel(id: 4, name: "Trauma to head/neck", selected: false),
      CheckboxModel(id: 5, name: "New onset chest pain", selected: false),
      CheckboxModel(id: 6, name: "Major burn", selected: false),
      CheckboxModel(id: 7, name: "Snakebite", selected: false),
    });
    bleeding.addAll({
      CheckboxModel(id: 1, name: "Large haemoptysis", selected: false),
      CheckboxModel(id: 2, name: "Gl bleeding", selected: false),
      CheckboxModel(id: 3, name: "External bleeding", selected: false),
    });
    prioritySigns.addAll({
      CheckboxModel(id: 1, name: "Very pale, weak/ill or recent fainting", selected: false),
      CheckboxModel(id: 2, name: "Difficulty breathing", selected: false),
      CheckboxModel(id: 3, name: "Acute visual changes", selected: false),
      CheckboxModel(id: 4, name: "Violent behavior/agitated", selected: false),
      CheckboxModel(id: 5, name: "Frequent diarrhea", selected: false),
      CheckboxModel(id: 6, name: "Fractures or dislocations", selected: false),
      CheckboxModel(id: 7, name: "Minor burns", selected: false),
      CheckboxModel(id: 8, name: "Bite (or lick/scratch) from rabid animal", selected: false),
      CheckboxModel(id: 9, name: "Poisoning", selected: false),
      CheckboxModel(id: 10, name: "Rape/abuse", selected: false),
      CheckboxModel(id: 11, name: "New extensive rash (Stevens-Johnson)", selected: false),
      CheckboxModel(id: 12, name: "Sickle cell with pain, cough, fever, priapism", selected: false),
    });
    Future.delayed(Duration.zero,(){
      Provider.of<SaveTriageResults>(context, listen: false).symptoms = selectedItems;
    });
    toListSymptoms();
    super.initState();
  }


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
                //Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FellowSelf()));
              },
            ),
            title: const Text("Triage Form",
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            )
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0,),
                const Text(
                  'Please provide the following information.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFFba181b),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10.0,),
                FutureBuilder(
                    future: users.where('Email', isEqualTo: currentUser?.email).get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      else if(snapshot.connectionState == ConnectionState.done) {
                        userName = snapshot.data?.docs[0].get('Full Name');
                        userBirthday = snapshot.data?.docs[0].get('Birthdate');
                        return Container(
                          //margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text("Name:",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(userName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Birthdate:",
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(userBirthday,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return Text('An error has occurred: ${snapshot.error}');
                    }
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "* Required";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 15.0,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedSex,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: sex.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSex = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    controller: addressController,
                    enabled: !checkBoxValue,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "* Required";
                      }
                      return null;
                    },
                  ),
                ),
                CheckboxListTile(
                    title: const Text("Get my device's location"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkBoxValue,
                    onChanged: (value) {
                      setState(() {
                        checkBoxValue = value!; //checkbox value is true
                        checkBoxValue
                            ? () async { deviceLocation = true; userLocation = await GetLocation().determinePosition();
                          //getAddress(userLocation?.latitude, userLocation?.longitude);
                        }()
                            : () { deviceLocation = false; addressController.text = addressController.text;
                          //getCoordinates(addressController.text);
                        }();

                      });
                    }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    controller: formController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Please list your main health concerns / symptoms / problems.",
                      labelText: "Chief complaints",
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0,),
                const Text('PLEASE SELECT TRAVEL MODE:',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFFba181b),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,),
                CheckboxListTile(
                    title: const Text("Request for Ambulance"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: requestAmbulance,
                    onChanged: (value) {
                      setState(() {
                        requestAmbulance = value!;
                        privateVehicle = false;
                        travelMode = "AMBULANCE";
                      });

                    }
                ),
                CheckboxListTile(
                    title: const Text("Travel through private vehicle"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: privateVehicle,
                    onChanged: (value) {
                      setState(() {
                        privateVehicle = value!;
                        requestAmbulance = false;
                        travelMode = "Private Vehicle";
                      });
                    }
                ),
                const SizedBox(height: 15.0,),
                // add checklist here
                const Text('Instruction: Please check those that are applicable',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFba181b),
                  ),
                ),
                const SizedBox(height: 15.0,),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                const Text('EMERGENCY SIGNS',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                // category

                CheckboxListTile(
                    title: const Text("Airway and breathing"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkAll,
                    onChanged: (value) {
                      setState(() {
                        checkAll = value!;
                        for (var element in airwayBreathing) {
                          element.selected = value;
                          element.selected
                              ? () { context.read<SaveTriageResults>().addSymptom(element.name);
                          countEmergency+=1; print(countEmergency);}()
                              : () { context.read<SaveTriageResults>().removeSymptom(element.name);
                          countEmergency-=1; print(countEmergency);}();
                        }
                        print(selectedItems);
                      });
                    }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: airwayBreathing.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(airwayBreathing[index].name),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: airwayBreathing[index].selected,
                        onChanged: (value) {
                          setState(() {
                            airwayBreathing[index].selected = value!;

                            if(!value){
                              final check = airwayBreathing.every((element) => element.selected);
                              checkAll = check;
                            }
                            value
                                ? () {context.read<SaveTriageResults>().addSymptom(airwayBreathing[index].name);
                            countEmergency+=1; print(countEmergency);}()
                                : () {context.read<SaveTriageResults>().removeSymptom(airwayBreathing[index].name);
                            countEmergency-=1; print(countEmergency);}();
                            print(selectedItems);
                          });
                        }
                    );
                  },
                ),
                // category
                CheckboxListTile(
                    title: const Text("Circulation"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkAll2,
                    onChanged: (value) {
                      setState(() {
                        checkAll2 = value!;
                        for (var element in circulation) {
                          element.selected = value;
                          element.selected
                              ? () {context.read<SaveTriageResults>().addSymptom(element.name);
                          countEmergency+=1;}()
                              : () {context.read<SaveTriageResults>().removeSymptom(element.name);
                          countEmergency-=1;}();
                        }
                        print(selectedItems);
                      });
                    }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: circulation.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(circulation[index].name),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: circulation[index].selected,
                        onChanged: (value) {
                          setState(() {
                            circulation[index].selected = value!;

                            if(!value){
                              final check = circulation.every((element) => element.selected);
                              checkAll2 = check;
                            }
                            value
                                ? () {context.read<SaveTriageResults>().addSymptom(circulation[index].name);
                            countEmergency+=1;}()
                                : () {context.read<SaveTriageResults>().removeSymptom(circulation[index].name);
                            countEmergency-=1;}();
                            print(selectedItems);
                          });
                        }
                    );
                  },
                ),
                CheckboxListTile(
                    title: const Text("Disability"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkAll3,
                    onChanged: (value) {
                      setState(() {
                        checkAll3 = value!;
                        for (var element in disability) {
                          element.selected = value;
                          element.selected
                              ? () {context.read<SaveTriageResults>().addSymptom(element.name);
                          countEmergency+=1;}()
                              : () {context.read<SaveTriageResults>().removeSymptom(element.name);
                          countEmergency-=1;}();
                        }
                        print(selectedItems);
                      });
                    }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: disability.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(disability[index].name),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: disability[index].selected,
                        onChanged: (value) {
                          setState(() {
                            disability[index].selected = value!;

                            if(!value){
                              final check = disability.every((element) => element.selected);
                              checkAll3 = check;
                            }
                            value
                                ? () {context.read<SaveTriageResults>().addSymptom(disability[index].name);
                            countEmergency+=1;}()
                                : () {context.read<SaveTriageResults>().removeSymptom(disability[index].name);
                            countEmergency-=1;}();
                            print(selectedItems);
                          });
                        }
                    );
                  },
                ),
                CheckboxListTile(
                    title: const Text("Expose and Evaluate for life threats"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkAll4,
                    onChanged: (value) {
                      setState(() {
                        checkAll4 = value!;
                        for (var element in lifeThreats) {
                          element.selected = value;
                          element.selected
                              ? () {context.read<SaveTriageResults>().addSymptom(element.name);
                          countEmergency+=1;}()
                              : () {context.read<SaveTriageResults>().removeSymptom(element.name);
                          countEmergency-=1;}();
                        }
                        print(selectedItems);
                      });
                    }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: lifeThreats.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(lifeThreats[index].name),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: lifeThreats[index].selected,
                        onChanged: (value) {
                          setState(() {
                            lifeThreats[index].selected = value!;

                            if(!value){
                              final check = lifeThreats.every((element) => element.selected);
                              checkAll4 = check;
                            }
                            value
                                ? () {context.read<SaveTriageResults>().addSymptom(lifeThreats[index].name);
                            countEmergency+=1;}()
                                : () {context.read<SaveTriageResults>().removeSymptom(lifeThreats[index].name);
                            countEmergency-=1;}();

                            print(selectedItems);
                          });
                        }
                    );
                  },
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                const Text('PRIORITY SIGNS',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,),
                const Divider(
                  color: Colors.black12,
                  thickness: 2.0,
                ),
                CheckboxListTile(
                    title: const Text("Bleeding"),
                    contentPadding: const EdgeInsets.all(0.0),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkAll5,
                    onChanged: (value) {
                      setState(() {
                        checkAll5 = value!;
                        for (var element in bleeding) {
                          element.selected = value;
                          element.selected
                              ? () {context.read<SaveTriageResults>().addSymptom(element.name);
                          countPriority+=1;}()
                              : () {context.read<SaveTriageResults>().removeSymptom(element.name);
                          countPriority-=1;}();
                        }
                        print(selectedItems);
                      });
                    }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: bleeding.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(bleeding[index].name),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: bleeding[index].selected,
                        onChanged: (value) {
                          setState(() {
                            bleeding[index].selected = value!;

                            if(!value){
                              final check = bleeding.every((element) => element.selected);
                              checkAll5 = check;
                            }
                            value
                                ? () {context.read<SaveTriageResults>().addSymptom(bleeding[index].name);
                            countPriority+=1;}()
                                : () {context.read<SaveTriageResults>().removeSymptom(bleeding[index].name);
                            countPriority-=1;}();

                            print(selectedItems);
                          });
                        }
                    );
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: prioritySigns.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(prioritySigns[index].name),
                        contentPadding: const EdgeInsets.all(0.0),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: prioritySigns[index].selected,
                        onChanged: (value) {
                          setState(() {
                            prioritySigns[index].selected = value!;

                            value
                                ? () {context.read<SaveTriageResults>().addSymptom(prioritySigns[index].name);
                            countPriority+=1;}()
                                : () {context.read<SaveTriageResults>().removeSymptom(prioritySigns[index].name);
                            countPriority-=1;}();

                            print(selectedItems);
                          });
                        }
                    );
                  },
                ),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 70.0),
                  //margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal:50.0),
                  child: RawMaterialButton(
                    fillColor: const Color(0xFFba181b),
                    elevation: 0.0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: Color(0xFFba181b)),
                    ),
                    onPressed: () async {
                      setState(() {
                        currentAddress = addressController.text;
                        userLat =  userLocation?.latitude;
                        userLong = userLocation?.longitude;
                      });

                      if (deviceLocation){
                        currentAddress = await getAddress(userLat, userLong);
                      }else{
                        userLat = await getLatitude(currentAddress);
                        userLong = await getLongitude(currentAddress);
                      }

                      generateTriageResults();
                      saveTriageResults();

                      // saveUserResults(
                      //     selectedSex,
                      //     formController.text.trim(),
                      //     selectedItems.toString(),
                      //   triageResult,
                      //   travelMode,
                      //     ageController.text.trim(),
                      //     currentAddress,
                      //     hospitalUserId,
                      //     status,
                      //     userLat.toString(),
                      //   userLong.toString(),
                      // );


                    },
                    child: const Text('Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }

  getLatitude(address) async {
    List<Location> locations = await locationFromAddress(address);
    setState(() {
      userLat = locations.first.latitude;
    });
    print(userLat);
    return userLat;
  }

  getLongitude(address) async {
    List<Location> locations = await locationFromAddress(address);
    setState(() {
      userLong = locations.first.longitude;
    });
    print(userLong);
    return userLong;
  }

  getAddress(lat, long) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
    Placemark place = placeMarks[0];
    setState(() {
      currentAddress =
      "${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
    });
    print(currentAddress);
    return currentAddress.toString();
  }


}

