import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:form_validator/form_validator.dart';
import 'package:toastification/toastification.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String? email;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isSubmitting = false;
  String newPassword = "";
  String confirmNewPassword = "";

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RegExp passwordRgx = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@$#!%*?&]{8,}$');

  final _formKey = GlobalKey<FormState>();
  String? _confirmPasswordValidator(String? value) {
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void submitHandler() async {
    if (_formKey.currentState!.validate()) {
      newPassword = newPasswordController.text;

      var isSuccess = await FirebaseAuthService()
          .updatePassword(email: email!, newPassword: newPassword);

      if (!isSuccess) {
        throw "Error updating password";
      }
      Toastify(
          context: context,
          msg: "Password Successfully Changed",
          status: ToastStatus.success);
      Navigator.popAndPushNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView(
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Create New Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: newPasswordController,
                  validator: ValidationBuilder()
                      .regExp(passwordRgx, "Please enter strong password")
                      .minLength(5)
                      .maxLength(50)
                      .build(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password*',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showPassword,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: _confirmPasswordValidator,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm New Password*',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showConfirmPassword,
                ),
                SizedBox(
                  height: 30,
                ),
                OutlinedButton(
                  onPressed: submitHandler,
                  child: _isSubmitting ? Loader() : Text("Submit"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
