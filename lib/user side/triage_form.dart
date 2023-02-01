import 'package:flutter/material.dart';
import 'package:medic/user%20side/emergency_case.dart';
import 'package:medic/user%20side/fellowSelf_page.dart';
import 'package:firebase_database/firebase_database.dart';


class TriageForm extends StatefulWidget {
  const TriageForm({Key? key}) : super(key: key);

  @override
  State<TriageForm> createState() => _TriageFormState();
}

class _TriageFormState extends State<TriageForm> {
  /*late String _firstName, _lastName, _birthdate, _email;
  TextEditingController _password = TextEditingController();
  TextEditingController _confirm = TextEditingController();*/

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool haveAgreed = false;

  bool isHiddenPassword = true;

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFba181b),
          title: const Text("MedIC",
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 50.0),
                  child: const Text(
                    'Your Information is protected by the Data Privacy Law',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFFba181b),
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      labelText: 'Full Name',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "* Required";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      labelText: 'Birthdate',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "* Required";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      labelText: 'Contact Number',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "* Required";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    obscureText: isHiddenPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                          onTap: () {
                            _togglePassword();
                          },
                          //isHiddenPassword = !isHiddenPassword;
                          child: Icon(
                              isHiddenPassword? Icons.visibility
                                  : Icons.visibility_off)),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "* Required";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                  child: TextFormField(
                    obscureText: isHiddenPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      labelText: 'Confirm Password',
                      suffixIcon: GestureDetector(
                          onTap: () {
                            _togglePassword();
                          },
                          //isHiddenPassword = !isHiddenPassword;
                          child: Icon(
                              isHiddenPassword? Icons.visibility
                                  : Icons.visibility_off)),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "* Required";
                      }
                      return null;
                    },
                  ),
                ),
                FormField(
                  builder: (state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: haveAgreed,
                              checkColor: Colors.white,
                              activeColor: const Color(0xFFba181b),
                              onChanged: (value) {
                                setState(() {
                                  haveAgreed = value!;
                                  state.didChange(value);
                                });
                              },
                            ),
                            const Text('I agree to the Terms of Service and Privacy \n Policy',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10.0,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );

                  },
                  validator: (value){
                    if(!haveAgreed){
                      return "* Required";
                    }
                    return null;
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
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyCase()));
                      }
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
        ),
      )
    );
  }
}