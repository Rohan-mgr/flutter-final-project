import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/blog_view.dart';
import 'package:flutter_final_project/screens/forgot_password.dart';

// Import your screen widgets here
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/screens/login_screen.dart';
import 'package:flutter_final_project/screens/new_password.dart';
import 'package:flutter_final_project/screens/signup_screen.dart';
import 'package:flutter_final_project/screens/verify_otp.dart';
import 'package:flutter_final_project/widgets/uploadBlog.dart';

// Define the routes as a Map
Map<String, Widget Function(BuildContext)> get appRoutes => {
      '/home': (context) => Home(
            initialBreadCrumbs: [],
            bottomNavigationIndex: 0,
          ),
      '/login': (context) => Login(),
      "/signup": (context) => SignUp(),
      "/forgot-password": (context) => ForgotPassword(),

      // "/notes": (context) => Notes(),
      "/new-password": (context) => NewPassword(),
      "/verify-otp": (context) => VerifyOtp(),

      //blogs
      "/upload-blog": (context) => UploadBlog(),
      "/blog-view": (context) => BlogView(),
    };
