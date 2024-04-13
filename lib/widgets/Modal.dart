import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/screens/notes_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';

class Modal extends StatefulWidget {
  final List<String> breadCrumbs;
  // final Function() onAddFolderTap;
  const Modal({required this.breadCrumbs});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _folderNameController = TextEditingController();

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? validateFolderName(String? value) {
      if (value == null || value.isEmpty) {
        return "Please enter a folder name.";
      }
      return null; // Validation successful
    }

    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Create new folder'),
          content: Form(
            key: _formKey,
            child: TextFormField(
                controller: _folderNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Folder Name',
                ),
                validator: validateFolderName),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final folderPath = widget.breadCrumbs.join("/");
                  await FirebaseAuthService()
                      .createFolder(folderPath, _folderNameController.text);
                  _folderNameController.clear();
                  Navigator.pop(context, 'OK');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        initialBreadCrumbs: widget.breadCrumbs,
                      ),
                    ),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: Icon(
        Icons.create_new_folder_rounded,
        size: 30,
        color: Colors.deepPurple,
      ),
    );
  }
}
