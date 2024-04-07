import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'We Share',
        debugShowCheckedModeBanner: false,
        initialRoute: "/login",
        routes: appRoutes);
  }
}
