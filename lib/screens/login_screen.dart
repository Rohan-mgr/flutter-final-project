import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  String _email = '';
  String _password = '';

  RegExp passwordRgx = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@$#!%*?&]{8,}$');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
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
                "Sign In",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20.0),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('email: $_email, password: $_password');
                    Navigator.pushNamed(context, "/");
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
