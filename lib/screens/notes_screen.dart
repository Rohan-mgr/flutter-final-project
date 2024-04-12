import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
// import 'package:flutter_final_project/services/mailer.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/Modal.dart';
import 'package:flutter_final_project/widgets/breadcrumbs.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  MyUser? user;
  List<dynamic> folders = [];
  List<String> breadCrumbs = [];

  @override
  void initState() {
    super.initState();
    loadUserFromLocalStorage();
    getFilesAndFolders("Notes");
  }

  Future<void> getFilesAndFolders(String folderName) async {
    try {
      // initially add Notes to the breadcrumbs
      if (breadCrumbs.length < 1) {
        breadCrumbs.add(folderName);
      }

      final folderPath = breadCrumbs.join("/");
      final foldersName =
          await FirebaseAuthService().listFoldersAndFiles(folderPath);
      setState(() {
        folders = foldersName;
      });
    } catch (error) {
      print("Error getting files: $error");
    }
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
                    await Storage.remove('user');
                    Navigator.popAndPushNamed(context, "/");
                  },
                  child: Text("Logout")),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Modal(),
                ],
              ),
            ),
            Breadcrumbs(
              breadCrumbs: breadCrumbs,
              onBreadcrumbTap: (index) {
                int removeIndex = index;
                breadCrumbs.removeRange(removeIndex + 1, breadCrumbs.length);
                getFilesAndFolders(breadCrumbs[index]);
              },
            ),
            Center(
                child: folders.length > 1
                    ? ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          dynamic item = folders[index];
                          return ListTile(
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                color: item['type'] == 'folder'
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            onTap: () {
                              if (item['type'] == 'folder') {
                                breadCrumbs.add(item['name']);
                                getFilesAndFolders(item['name']);
                              } else {
                                // Handle file tap
                              }
                            },
                          );
                        },
                        itemCount: folders.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics())
                    : Text("There is no files here yet")),
          ],
        ),
      ),
    );
  }
}
