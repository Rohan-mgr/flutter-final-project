import 'package:flutter_final_project/services/mailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:otp_text_field/otp_text_field.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool _isSubmitting = false;

  bool _sendingAgain = false;

  String _error = "";
  OtpFieldController otpController = OtpFieldController();
  String? email;
  String otp = "";
  void SubmitHandler() async {
    setState(() {
      _isSubmitting = true;
      _error = "";
    });
    bool otpMatched =
        await FirebaseAuthService().verifyOTP(otp: otp, email: email!);

    await FirebaseAuthService().verifyOTP(otp: otp, email: email!);

    if (otpMatched) {
//go to new password screen
      Navigator.popAndPushNamed(context, "/new-password", arguments: email);
    } else {
      setState(() {
        _isSubmitting = false;
        _error = "Invalid OTP";
      });
    }
  }

  void sendAgainHandler() async {
    setState(() {
      _sendingAgain = true;
    });
    var username = await FirebaseAuthService().userExists(email: email!);
    bool result =
        await sendMail(recipientEmail: email, recipientName: username);
    Future.delayed(
      Duration(seconds: 15),
      () {
        setState(() {
          _sendingAgain = false;
        });
      },
    );

    if (!result) {
      print("error sending mail");
    }
  }

  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: ListView(
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
              const SizedBox(
                height: 20,
              ),
              Text(
                "Verification Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "We have sent a verification code to your email.Please enter the code to change your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              _error.isNotEmpty
                  ? Text(
                      _error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : SizedBox(
                      height: 22,
                    ),
              SizedBox(
                height: 30,
              ),
              OTPTextField(
                controller: otpController,
                length: 6,
                onCompleted: (value) {
                  setState(() {
                    otp = value;
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),
              _sendingAgain
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Resent Successful",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive OTP?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: sendAgainHandler,
                          child: Text("Send Again",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple,
                              )),
                        )
                      ],
                    ),
              SizedBox(
                height: 40,
              ),
              OutlinedButton(
                onPressed: SubmitHandler,
                child: _isSubmitting ? Loader() : Text("Submit"),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
