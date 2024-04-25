import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_final_project/screens/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_final_project/screens/login_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'We Share',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        // initialRoute: "/",
        routes: appRoutes);
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
            ),
            Center(
              child: Container(
                height: 180.0,
                padding: EdgeInsets.all(25),
                width: 180.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/logo2.gif',
                  height: 95.0,
                  width: 98.0,
                ),
              ),
            ),
            SizedBox(
              height: 250,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Agne',
                  fontWeight: FontWeight.bold),
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 2000),
                animatedTexts: [
                  TyperAnimatedText(
                    'We Share',
                    speed: Duration(milliseconds: 100),
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 14.0,
                fontFamily: 'Agne',
              ),
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Your one and only exam partner.',
                    speed: Duration(milliseconds: 100),
                  ),
                ],
              ),
            ),
          ],
        ),
        splashIconSize: 1000,
        backgroundColor: Colors.deepPurple,
        duration: 3000,
        nextScreen: const Login());
  }
}
