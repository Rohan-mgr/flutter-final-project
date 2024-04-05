import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'We Share',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: appRoutes);
  }
}
