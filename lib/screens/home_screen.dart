import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            child: Text("Login")),
      ),
    );
  }
}
