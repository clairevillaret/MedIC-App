import 'package:flutter/material.dart';
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
  //var passwordController = TextEditingController();
  //var confirmController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool haveAgreed = false;
  bool isHiddenPassword = true;

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
    }
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
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
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
                      'Hi! Sign up below with your details.',
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
                    padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Email',
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
                      controller: passwordController,
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
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        labelText: 'Confirm Password',
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
                    child: RawMaterialButton(
                      fillColor: const Color(0xFFba181b),
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(color: Color(0xFFba181b)),
                      ),
                      onPressed: () {
                        signUp();
                        // var password = passwordController.text.trim();
                        // var confirmPass = confirmController.text.trim();
                        //
                        // if (password != confirmPass) {
                        //   // show error toast
                        //   Fluttertoast.showToast(msg: 'Passwords do not match');
                        //   return;
                        // }
                        // if (_formKey.currentState!.validate()){
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        // }

                      },
                      child: const Text('Sign Up',
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