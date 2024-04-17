import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:open_file/open_file.dart';

class PopUpMenu extends StatefulWidget {
  final dynamic file;
  final List<String> breadCrumbs;

  const PopUpMenu({super.key, required this.file, required this.breadCrumbs});
  @override
  _PopUpMenuState createState() => _PopUpMenuState();
}

class _PopUpMenuState extends State<PopUpMenu> {
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
                      Text(
                        'Removing file... Please wait.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

    // void handlePreviewFile(file) async {
    //   try {
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) {
    //           return Center(
    //             child: Container(
    //               margin: EdgeInsets.symmetric(horizontal: 20),
    //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(20.0),
    //               ),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Loader(size: 45, color: Colors.deepPurple),
    //                   SizedBox(height: 20),
    //                   Text(
    //                     'Setting up things for you... Please wait.',
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         });
    //     final downloadedFile = await FirebaseAuthService()
    //         .downloadFilePrivately(file['name'], file['fullPath']);
    //     Navigator.of(context).pop();
    //     if (downloadedFile == null) return;
    //     OpenFile.open(downloadedFile);
    //   } catch (e) {
    //     print('Error downloading file: $e');
    //     throw e;
    //   }
    // }

    void downloadFile(file) async {
      try {
        await FirebaseAuthService()
            .downloadFile(file['name'], file['fullPath']);
      } catch (e) {
        print('Error downloading file: $e');
        throw e;
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
            if (value == 4) {
              handleRemoveBtnClick(widget.file);
            } else if (value == 1) {
              handlePreviewFile(context, widget.file);
            } else if (value == 2) {
              copyLinkToClipboard(widget.file);
            } else if (value == 3) {
              try {
                downloadFile(widget.file);
              } catch (e) {
                print('Error downloading file: $e');
                throw e;
              }
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
