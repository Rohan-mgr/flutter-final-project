import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/mailer.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/types/user.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Welcome, ${user?.firstName} ${user?.lastName}"),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    sendMail(
                        recipientEmail: user?.email,
                        recipientName: user?.firstName);
                  },
                  child: Text("Send OTP")),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    await Storage.remove('user');
                    Navigator.popAndPushNamed(context, "/");
                  },
                  child: Text("Logout")),
            ),
          ],
        ),
      ),
    );
  }
}
