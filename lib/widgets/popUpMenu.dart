import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class PopUpMenu extends StatefulWidget {
  final dynamic file;
  final List<String> breadCrumbs;
  final bool isProfileSection;

  const PopUpMenu(
      {super.key,
      required this.file,
      required this.breadCrumbs,
      this.isProfileSection = false});
  @override
  _PopUpMenuState createState() => _PopUpMenuState();
}

class _PopUpMenuState extends State<PopUpMenu> {
  MyUser? user;
  @override
  initState() {
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
    void removeFile(file) async {
      try {
        // Show loading dialog
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Loader(size: 30, color: Colors.red),
                      SizedBox(height: 20),
                      Text('Removing file... Please wait.'),
                    ],
                  ),
                ),
              );
            });
        // Remove file
        await FirebaseAuthService().deleteFile(file['fullPath']);
        // Close both dialogs
        Navigator.of(context).pop();
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              initialBreadCrumbs: widget.breadCrumbs,
              bottomNavigationIndex: getSeletedTabIndex(widget.breadCrumbs[0]),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print('Error removing file: $e');
        throw e;
      }
    }

    void handleRemoveBtnClick(file) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure you want to remove this file?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            removeFile(file); // Pass context twice
                          },
                          child: Text(
                            'Remove',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Future<bool> downloadFile(file) async {
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Loader(size: 40, color: Colors.deepPurple),
                      SizedBox(height: 20),
                      Text('Downloading file... Please wait.'),
                    ],
                  ),
                ),
              );
            });

        await FirebaseAuthService().downloadFilePublicly(user?.id, file);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.download_done_outlined,
                  color: Colors.green[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text('File downloaded successfully'),
              ],
            ),
          ),
        );
        return true;
      } catch (e) {
        print('Error downloading file publicly: $e');
        return false;
      }
    }

    void copyLinkToClipboard(file) async {
      // Copy link to clipboard
      final textToCopy =
          await FirebaseAuthService().getFileDownloadUrl(file['fullPath']);
      await Clipboard.setData(ClipboardData(text: textToCopy!));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.copy_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Link copied to clipboard'),
            ],
          ),
        ),
      );
    }

    Future<void> handleAddToFavourite(file) async {
      print("Adding to favourite...");
      try {
        await FirebaseAuthService().addFileToFavouriteList(user?.id, file);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'Added to favourite. Please visit your profile section',
                  ),
                ),
              ],
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(e.toString()),
                ),
              ],
            ),
          ),
        );
        return null;
      }
    }

    void handleRemoveFileFromFavouriteList(file) async {
      print("file remove fav list => $file");
      try {
        await FirebaseAuthService()
            .removeFilesFromFavouriteList(file?['documentId']);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              initialBreadCrumbs: [],
              bottomNavigationIndex: getSeletedTabIndex('profile'),
            ),
          ),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.download_done_outlined,
                  color: Colors.green[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'File removed from favourite list.',
                  ),
                ),
              ],
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(e.toString()),
                ),
              ],
            ),
          ),
        );
        return null;
      }
    }

    return Row(
      children: [
        PopupMenuButton<int>(
          icon: Icon(Icons.more_vert, color: Colors.deepPurple),
          onSelected: (value) async {
            // Handle menu item selection (optional)
            print('value => $value');
            if (value == 1) {
              handlePreviewFile(context, widget.file);
            } else if (value == 2) {
              copyLinkToClipboard(widget.file);
            } else if (value == 3) {
              final bool response = await downloadFile(widget.file);
              if (response && widget.isProfileSection) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      initialBreadCrumbs: [],
                      bottomNavigationIndex: getSeletedTabIndex('profile'),
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            } else if (value == 4) {
              handleRemoveBtnClick(widget.file);
            } else if (value == 5) {
              handleAddToFavourite(widget.file);
            } else if (value == 6) {
              handleRemoveFileFromFavouriteList(widget.file);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.visibility_outlined,
                    ),
                  ),
                  Text('Preview'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.link_outlined,
                    ),
                  ),
                  Text('Get/Copy link'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.download_outlined),
                  ),
                  Text('Download'),
                ],
              ),
            ),
            if (!widget.isProfileSection)
              PopupMenuItem(
                value: 5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.favorite_border_outlined),
                    ),
                    Text('Add to favourite'),
                  ],
                ),
              ),
            if (widget.isProfileSection)
              PopupMenuItem(
                value: 6,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.heart_broken_outlined,
                        color: Colors.red[400],
                      ),
                    ),
                    Text(
                      'Remove from favourite',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ],
                ),
              ),
            if (user!.isAdmin && !widget.isProfileSection)
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                      ),
                    ),
                    Text(
                      'Remove',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ],
                ),
              ),
          ],
          offset: Offset(-35.0, 0.0), // Adjust offset for left positioning
        ),
      ],
    );
  }
}
