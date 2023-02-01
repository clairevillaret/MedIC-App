import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/home_screen.dart';
import 'package:medic/user%20side/signup_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;

  void _togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future logIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 50.0),
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/lifeline.jpg',),
                      opacity: 0.4,
                      fit: BoxFit.cover,)
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 0.0),
                  child: const Text("MedIC",
                    style: TextStyle(
                      fontSize: 70.0,
                      color: Color(0xFFba181b),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 10.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
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
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        RawMaterialButton(
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                          child: const Text('Forgot Password?',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                      child: RawMaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        fillColor: const Color(0xFFba181b),
                        elevation: 0.0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: Color(0xFFba181b)),
                        ),
                        onPressed: () {
                          logIn();
                          // if (_formKey.currentState!.validate()){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                          //   // ScaffoldMessenger.of(context).showSnackBar(
                          //   //   const SnackBar(content: Text('Processing Data')),
                          //   // );
                          // }
                        },
                        child: const Text('LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account yet?",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),),
                        RawMaterialButton(
                          constraints: const BoxConstraints(),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                          },
                          child: const Text(' Sign Up',
                            style: TextStyle(
                              color: Color(0xFFba181b),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}