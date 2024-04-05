import 'package:flutter/material.dart';

// Import your screen widgets here
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/screens/login_screen.dart';
import 'package:flutter_final_project/screens/signup_screen.dart';

// Define the routes as a Map
Map<String, Widget Function(BuildContext)> get appRoutes => {
      '/': (context) => Home(),
      '/login': (context) => Login(),
      "/signup": (context) => SignUp(),
    };
