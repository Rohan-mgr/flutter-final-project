import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:flutter_final_project/services/mailer.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _error = "";
  bool _isSubmitting = false;
  var email;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void sendMailHandler() async {
    if (_formKey.currentState!.validate()) {
      email = emailController.text;
      try {
        setState(() {
          _isSubmitting = true;
          _error = "";
        });
        var username = await _authService.userExists(email: email);
        print(email + " " + username);
        bool mailSent =
            await sendMail(recipientEmail: email, recipientName: username);
        if (!mailSent) {
          throw "Error sending mail";
        }
        Toastify(
            context: context,
            msg: "OTP sent successfully",
            status: ToastStatus.success);
        Navigator.popAndPushNamed(context, "/verify-otp", arguments: email);
        //redirect garni kaam
      } catch (error) {
        setState(() {
          _isSubmitting = false;
          _error = error.toString();
        });
      }
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
              _error.isNotEmpty
                  ? Alert(context, _error, ToastStatus.error)
                  : Text(""),
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
