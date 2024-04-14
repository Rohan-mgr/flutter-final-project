import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class Modal extends StatefulWidget {
  final List<String> breadCrumbs;
  // final Function() onAddFolderTap;
  const Modal({required this.breadCrumbs});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  final _formKey = GlobalKey<FormState>();
  bool _isFolderCreated = false;

  TextEditingController _folderNameController = TextEditingController();

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  void handleAddFolderClick() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isFolderCreated = true;
        });
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
          _isFolderCreated = false;
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
              onPressed: handleAddFolderClick,
              child: _isFolderCreated
                  ? Loader(size: 23, color: Colors.deepPurple)
                  : const Text('Add folder'),
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
