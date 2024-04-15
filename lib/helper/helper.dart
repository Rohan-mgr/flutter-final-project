import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_alert/bootstrap_alert.dart';
import 'package:otp/otp.dart';

String generateOTP() {
  String secret = dotenv.env['OTP_SECRET']!;
  final otp = OTP.generateTOTPCodeString(
      secret, DateTime.now().millisecondsSinceEpoch,
      interval: 20, algorithm: Algorithm.SHA512);
  return otp;
}

enum ToastStatus { success, error }

void Toastify({BuildContext? context, String? msg, ToastStatus? status}) {
  toastification.show(
    context: context!,
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 3),
    // you can also use RichText widget for title and description parameters
    description: RichText(
        text: TextSpan(text: msg, style: TextStyle(color: Colors.white))),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: const Icon(Icons.check),
    primaryColor: status == ToastStatus.success ? Colors.green : Colors.red,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.always,
    closeOnClick: true,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
  );
}

BootstrapAlert Alert(BuildContext context, String errMsg, ToastStatus status) {
  return BootstrapAlert(
    visible: true,
    status: status == ToastStatus.success
        ? AlertStatus.success
        : AlertStatus.danger,
    leadingIcon:
        status == ToastStatus.success ? AlertIcons.success : AlertIcons.warning,
    isDismissible: true,
    text: errMsg,
  );
}

String truncateFilename(String filename) {
  if (filename.length <= 37) {
    return filename;
  }
  // Truncate the filename and add "..."
  return filename.substring(0, 37) + " ...";
}
