import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:form_validator/form_validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showPassword = false;
  String _errMsg = "";
  bool _isSubmitting = false;
  bool _isGoogleSubmitting = false;

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
      try {
        setState(() {
          _isSubmitting = true;
        });
        MyUser? user = await _authService.signInWithEmailAndPassword(
            emailController.text, passwordController.text);
        if (user == null) {
          throw "User not found";
        }
        print("User signed in successfully");
        setState(() {
          _isSubmitting = false;
          _errMsg = "";
        });
        await Storage.setUser("user", user);
        emailController.clear();
        passwordController.clear();
        Navigator.popAndPushNamed(context, "/home");
      } catch (error) {
        print(error);
        setState(() {
          _errMsg = error.toString();
          _isSubmitting = false;
        });
        emailController.clear();
        passwordController.clear();
        return null;
      }
    }
  }

  void handleGoogleSignIn() async {
    try {
      setState(() {
        _isGoogleSubmitting = true;
      });
      MyUser? user = await FirebaseAuthService().signInWithGoogle();
      await Storage.setUser("user", user!);
      Navigator.popAndPushNamed(context, "/home");

      setState(() {
        _isGoogleSubmitting = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isGoogleSubmitting = false;
      });
      Toastify(
          context: context, msg: error.toString(), status: ToastStatus.error);
      return null;
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
          child: ListView(
            // mainAxisSize: MainAxisSize.min, // Avoid excessive stretching
            children: [
              Container(
                height: 180.0,
                padding: EdgeInsets.all(25),
                width: 180.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple, // Adjust border color as needed
                    width: 2.0, // Adjust border width as needed
                  ),
                ),
                child: Image.asset(
                  'assets/logo2.gif',
                  height: 95.0,
                  width: 98.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20.0),
              if (_errMsg.isNotEmpty)
                Alert(context, _errMsg, ToastStatus.error),
              TextFormField(
                controller: emailController,
                validator: ValidationBuilder().email().maxLength(50).build(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email*',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20.0),
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
                    onPressed: () => {
                      /* Forgot password functionality */
                      Navigator.pushNamed(context, "/forgot-password")
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: signInHandler,
                child: _isSubmitting ? Loader() : Text('Sign In'),
              ),
              const SizedBox(height: 10.0),
              Row(children: [
                Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 204, 197, 197),
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  "OR",
                  style: TextStyle(color: Color.fromARGB(255, 109, 104, 104)),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 204, 197, 197),
                  ),
                ),
              ]),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                onPressed: handleGoogleSignIn,
                child: _isGoogleSubmitting
                    ? Loader(size: 25, color: Colors.deepPurple)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google-icon.png',
                            height: 30.0,
                            width: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text('Sign In with Google'),
                        ],
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/signup");
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.deepPurple),
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
