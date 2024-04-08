import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:flutter_final_project/services/mailer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String error = "";
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void sendMailHandler() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isSubmitting = true;
        });
        var response =
            await _authService.userExists(email: emailController.text);
        print(response);
      } catch (error) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Image.asset(
                "assets/logo.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  "Please enter your email address for the verification process, we will send an OTP to your email address."),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email*',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: sendMailHandler,
                child: _isSubmitting ? Loader() : Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
