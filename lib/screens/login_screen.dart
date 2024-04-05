import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:form_validator/form_validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signInHandler() async {
    if (_formKey.currentState!.validate()) {
      final user = await _authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        print('User signed in successfully');
        Navigator.pushNamed(context, "/");
      } else {
        print('User sign in failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
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
                controller: emailController,
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email*',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: passwordController,
                validator:
                    ValidationBuilder().minLength(5).maxLength(50).build(),
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
                onPressed: signInHandler,
                child: Text('Sign In'),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      'Sign Up',
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
