import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';

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

    return Row(
      children: [
        PopupMenuButton<int>(
          icon: Icon(Icons.more_vert, color: Colors.deepPurple),
          onSelected: (value) {
            // Handle menu item selection (optional)
            if (value == 3) {
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
                    child: Icon(Icons.download_outlined),
                  ),
                  Text('Download'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 3,
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
