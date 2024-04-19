import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:uuid/uuid.dart';

class PopUpMenu extends StatefulWidget {
  final dynamic file;
  final List<String> breadCrumbs;

  const PopUpMenu({super.key, required this.file, required this.breadCrumbs});
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

  double downloadProgress = 0;
  @override
  Widget build(BuildContext context) {
    print("users => ${user?.isAdmin}");
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              initialBreadCrumbs: widget.breadCrumbs,
              bottomNavigationIndex: getSeletedTabIndex(widget.breadCrumbs[0]),
            ),
          ),
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

    Future<void> downloadFile(file) async {
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
        final fileUrl =
            await FirebaseAuthService().getFileDownloadUrl(file['fullPath']);
        var storePath = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        var fileName = file['name'];
        var extension = file['mimeType'] ?? 'ext'; // Handle missing extension
        String path = '$storePath/${fileName}_${Uuid().v4()}.$extension';

        print("Downloading file...");
        await Dio().download(
          fileUrl!,
          path,
          onReceiveProgress: (count, total) {
            setState(() {
              downloadProgress = count / total;
            });
          },
        );
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.download_done_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('File downloaded successfully'),
              ],
            ),
          ),
        );
      } catch (e) {
        print('Error downloading file publicly: $e');
        return null;
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

    return Row(
      children: [
        PopupMenuButton<int>(
          icon: Icon(Icons.more_vert, color: Colors.deepPurple),
          onSelected: (value) {
            // Handle menu item selection (optional)
            print('value => $value');
            if (value == 1) {
              handlePreviewFile(context, widget.file);
            } else if (value == 2) {
              copyLinkToClipboard(widget.file);
            } else if (value == 3) {
              downloadFile(widget.file);
            } else if (value == 4) {
              handleRemoveBtnClick(widget.file);
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
            if (user!.isAdmin)
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
