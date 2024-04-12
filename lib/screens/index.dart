import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/forgot_password.dart';

// Import your screen widgets here
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/screens/login_screen.dart';
import 'package:flutter_final_project/screens/new_password.dart';
import 'package:flutter_final_project/screens/signup_screen.dart';
import 'package:flutter_final_project/screens/verify_otp.dart';

// Define the routes as a Map
Map<String, Widget Function(BuildContext)> get appRoutes => {
      '/home': (context) => Home(),
      '/': (context) => Login(),
      "/signup": (context) => SignUp(),
      "/forgot-password": (context) => ForgotPassword(),
      // "/notes": (context) => Notes(),
      "/new-password":(context) => NewPassword(),
      "/verify-otp": (context) => VerifyOtp(),

    };
