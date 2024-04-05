import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:form_validator/form_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _showPassword = false;
  String _username = '';
  String _email = '';
  String _password = '';

  final FirebaseAuthService _authService = FirebaseAuthService();

  void signUpHandler() async {
    if (_formKey.currentState!.validate()) {
      final user = await _authService.createUserWithEmailAndPassword(
        _email,
        _password,
      );
      if (user != null) {
        print('User created successfully');
        Navigator.pushNamed(context, "/login");
        Toastify(
            context: context,
            msg: "User Registered Successfully",
            status: ToastStatus.success);
      } else {
        print('User creation failed');
      }
    }
  }

  RegExp passwordRgx = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@$#!%*?&]{8,}$');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Avoid excessive stretching
            children: [
              // App logo (optional)
              Image.asset(
                'logo.png',
                height: 100.0,
                width: 100.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                onChanged: (value) => {
                  setState(
                    () => _username = value,
                  )
                },
                validator: ValidationBuilder()
                    .required("Please enter your username")
                    .minLength(2)
                    .maxLength(50)
                    .build(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'UserName*',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                onChanged: (value) => {
                  setState(
                    () => _email = value,
                  )
                },
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email*',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                onChanged: (value) => {
                  setState(
                    () => _password = value,
                  )
                },
                validator: ValidationBuilder()
                    .regExp(passwordRgx, "Please enter strong password")
                    .minLength(5)
                    .maxLength(50)
                    .build(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password*',
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
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => {/* Forgot password functionality */},
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: signUpHandler,
                child: Text('Sign Up'),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
