import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final currentUser = FirebaseAuth.instance.currentUser;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();
  final birthdateController = TextEditingController();
  final numberController = TextEditingController();
  final addressController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool haveAgreed = false;
  bool isHiddenPassword = true;

  List<String> roles = ['Regular User','Paramedic'];
  String selectedRole = 'Regular User';

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future signUp() async {
    if(passwordConfirmed()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      addUserDetails(
          nameController.text.trim(),
          birthdateController.text.trim(),
          emailController.text.trim(),
          numberController.text.trim(),
          addressController.text.trim(),
        passwordController.text.trim(),
        selectedRole,
      );
    }

    if (currentUser != null) {
      // signed in
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      if (!mounted) return;
      Navigator.pop(context);

    }

  }

  Future addUserDetails(String fullName, String birthdate, String email, String contactNumber, String address, String password, String role) async {
    await FirebaseFirestore.instance.collection('users').add({
      'Full Name': fullName,
      'Birthdate': birthdate,
      'Email': email,
      'Contact Number': contactNumber,
      'Address': address,
      'Password' : password,
      'Role': selectedRole,
    });
  }


  bool passwordConfirmed(){
    if(passwordController.text.trim() == confirmController.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    nameController.dispose();
    birthdateController.dispose();
    numberController.dispose();
    addressController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 50.0),
                    child: const Text(
                      'Hi! Sign up below with your details.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFFba181b),
                        height: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(fontSize: 12),
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
                      controller: birthdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Birthdate',
                        labelStyle: const TextStyle(fontSize: 12),
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                      ),
                      onTap: () async {
                        DateTime? chosenDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1897),
                            lastDate: DateTime(2024));
                        if (chosenDate != null){
                          setState(() {
                            birthdateController.text = DateFormat.yMMMMd().format(chosenDate);
                          });
                        }
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "* Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Email',
                        labelStyle: const TextStyle(fontSize: 12),
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
                      controller: numberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Contact Number',
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "* Required";
                        }
                        else{
                          int? parsedValue = int.tryParse(value);
                          if(parsedValue == null) {
                            return "enter a valid contact number";
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                    child: TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Address',
                        labelStyle: const TextStyle(fontSize: 12),
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
                      controller: passwordController,
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(fontSize: 12),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _togglePassword();
                            },
                            //isHiddenPassword = !isHiddenPassword;
                            child: Icon(
                                isHiddenPassword? Icons.visibility
                                    : Icons.visibility_off)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Required";
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                    child: TextFormField(
                        controller: confirmController,
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(fontSize: 12),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _togglePassword();
                            },
                            child: Icon(
                                isHiddenPassword? Icons.visibility
                                    : Icons.visibility_off)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "* Required";
                        }
                        return null;
                      }
                    ),
                  ),
                  const Text("Sign up as:", style: TextStyle(fontSize: 12),),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xFFba181b))
                        )),
                      value: selectedRole,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: roles.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 10.0),
                    child: RawMaterialButton(
                      fillColor: const Color(0xFFba181b),
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()){
                        signUp();
                        }
                      },
                      child: const Text('Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),),
                      RawMaterialButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        child: const Text(' Login',
                          style: TextStyle(
                            color: Color(0xFFba181b),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}