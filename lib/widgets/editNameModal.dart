import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class EditProfileDialog extends StatefulWidget {
  final MyUser user;
  final Function refreshLocalStorage;

  EditProfileDialog({required this.user, required this.refreshLocalStorage});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  String firstName = "";
  String lastName = "";
  bool isUpdating = false;

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Update user profile or perform actions here with the data
      try {
        if (firstName == widget.user.firstName &&
            lastName == widget.user.lastName) {
          Navigator.pop(context);
          return;
        }
        setState(() {
          isUpdating = true;
        });
        MyUser? updatedUser = await FirebaseAuthService()
            .updateUserName(firstName, lastName, widget.user);
        print("updated user => ${updatedUser?.toJson()}");
        await Storage.setUser("user", updatedUser!);
        widget.refreshLocalStorage();
        setState(() {
          isUpdating = false;
        });
      } catch (e) {
        print("Error updating user name: $e");
        setState(() {
          isUpdating = false;
        });
        throw e;
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Name'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'New First Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              initialValue: widget.user.firstName,
              onSaved: (value) => firstName = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'New Last Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              initialValue: widget.user.lastName,
              onSaved: (value) => lastName = value!,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: submitForm,
          child: isUpdating
              ? Loader(
                  size: 20,
                  color: Colors.deepPurple,
                )
              : Text('Update'),
        ),
      ],
    );
  }
}
