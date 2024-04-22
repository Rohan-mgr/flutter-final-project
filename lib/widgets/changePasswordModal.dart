import 'package:flutter/material.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class ChangePasswordDialog extends StatefulWidget {
  final MyUser user;

  ChangePasswordDialog({required this.user});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";
  bool isUpdating = false;

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Update user profile or perform actions here with the data
      print("submit change password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change your password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Old Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your old password';
                }
                return null;
              },
              onSaved: (value) => oldPassword = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'New Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
              onSaved: (value) => newPassword = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please re-enter your new password';
                }
                return null;
              },
              onSaved: (value) => newPassword = value!,
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
