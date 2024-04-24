import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:form_validator/form_validator.dart';

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
  bool _showNewPassword = true;
  bool _showOldPassword = true;
  bool _showConfirmPassword = true;
  bool isUpdating = false;
  String userEmail = "";
  String errMsg = "";
  RegExp passwordRgx = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@$#!%*?&]{8,}$');

  void submitForm() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      // Update user profile or perform actions here with the data

      setState(() {
        isUpdating = true;
      });
      await getUserEmail();
      bool result = await FirebaseAuthService().updatePassword(
          email: userEmail, newPassword: newPassword, oldPassword: oldPassword);
      setState(() {
        isUpdating = false;
      });
      if (result) {
        Navigator.pop(context);
        Toastify(
            context: context,
            msg: "Password Updated Successfully",
            status: ToastStatus.success);
      } else {
        Alert(context, "Old Password doesn't match", ToastStatus.error);
        setState(() {
          errMsg = "Old Password doesn't match";
        });
      }
    }
  }

  Future<void> getUserEmail() async {
    final user = (await Storage.getUser("user"))?.email;
    setState(() {
      userEmail = user!;
    });
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
            errMsg != ""
                ? Text(
                    "$errMsg",
                    style: TextStyle(color: Colors.red),
                  )
                : Text(""),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Old Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showOldPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showOldPassword = !_showOldPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your old password';
                }
                return null;
              },
              onSaved: (value) => oldPassword = value!,
              obscureText: _showOldPassword,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'New Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNewPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
              ),
              validator: ValidationBuilder()
                  .regExp(passwordRgx, "Please enter strong password")
                  .minLength(5)
                  .maxLength(50)
                  .build(),
              onSaved: (value) => newPassword = value!,
              obscureText: _showNewPassword,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please re-enter your new password';
                }
                print("value = " + value);

                if (value != newPassword)
                  return "Confirm password doesn't match";
                return null;
              },
              onSaved: (value) => confirmPassword = value!,
              obscureText: _showConfirmPassword,
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
          onPressed: isUpdating ? () {} : submitForm,
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
