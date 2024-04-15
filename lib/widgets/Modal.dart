import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class Modal extends StatefulWidget {
  final List<String> breadCrumbs;
  const Modal({required this.breadCrumbs});
  @override
  _ModalState createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  final _folderNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void handleAddFolderClick() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        print('isLoading => $isLoading');
        final folderPath = widget.breadCrumbs.join("/");
        bool folderCreationStatus = await FirebaseAuthService()
            .createFolder(folderPath, _folderNameController.text);
        if (!folderCreationStatus) {
          throw "Error creating folder";
        }
        _folderNameController.clear();

        Navigator.pop(context, 'Add folder');
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              initialBreadCrumbs: widget.breadCrumbs,
            ),
          ),
        );
      } catch (error) {
        print("Error creating folder: $error");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? validateFolderName(String? value) {
      if (value == null || value.isEmpty) {
        return "Please enter a folder name.";
      }
      return null; // Validation successful
    }

    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Create a new Folder",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: _folderNameController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2.0),
                        ),
                        hintText: 'Enter folder name',
                        border: UnderlineInputBorder(),
                        labelStyle: new TextStyle(color: Colors.deepPurple),
                      ),
                      validator: validateFolderName),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.deepPurple)),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: handleAddFolderClick,
                        child: Container(
                            child: isLoading
                                ? Loader(size: 20, color: Colors.deepPurple)
                                : Text(
                                    'Add folder',
                                    style: TextStyle(color: Colors.deepPurple),
                                  )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
