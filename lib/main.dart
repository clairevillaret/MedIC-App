import 'package:firebase_core/firebase_core.dart';
import 'package:medic/user%20side/saveTriageResults_class.dart';
import 'package:flutter/material.dart';
import 'package:medic/user%20side/main_page.dart';
import 'package:provider/provider.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SaveTriageResults()),
          //Provider(create: (context) => SomeOtherClass()),
        ],
      child:
      const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      theme: ThemeData(
        primarySwatch: Colors.red,),
    );
  }

}