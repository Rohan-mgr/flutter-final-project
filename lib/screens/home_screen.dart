import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/types/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUserFromLocalStorage();
  }

  Future<void> loadUserFromLocalStorage() async {
    try {
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          user = loggedUser;
        });
      }
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
      ),
      body: Column(
        children: [
          Center(
            child: Text("Welcome, ${user?.firstName} ${user?.lastName}"),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await Storage.remove('user');
                  Navigator.pushNamed(context, "/login");
                },
                child: Text("Logout")),
          ),
        ],
      ),
    );
  }
}
