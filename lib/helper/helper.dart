import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:open_file/open_file.dart';
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
  if (filename.length <= 29) {
    return filename;
  }
  // Truncate the filename and add "..."
  return filename.substring(0, 29) + " ...";
}

void handlePreviewFile(context, file) async {
  try {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Loader(size: 45, color: Colors.deepPurple),
                  SizedBox(height: 20),
                  Text('Setting up things for you... Please wait.'),
                ],
              ),
            ),
          );
        });
    final downloadedFile = await FirebaseAuthService()
        .downloadFilePrivately(file['name'], file['fullPath']);
    Navigator.of(context).pop();
    if (downloadedFile == null) return;
    OpenFile.open(downloadedFile);
  } catch (e) {
    print('Error downloading file: $e');
    throw e;
  }
}

Widget getCustomIcon(String extension) {
  switch (extension.toLowerCase()) {
    case 'mp3':
      return const Image(
        image: AssetImage('assets/mp3-icon.png'),
        width: 40,
        height: 40,
      );
    case 'jpg':
    case 'jpeg':
    case 'png':
      return const Image(
        image: AssetImage('assets/img-icon.png'),
        width: 40,
        height: 40,
      );
    case 'doc':
    case 'docx':
      return const Image(
        image: AssetImage('assets/doc-icon.png'),
        width: 40,
        height: 40,
      );
    case 'pdf':
      return const Image(
        image: AssetImage('assets/pdf-icon.png'),
        width: 40,
        height: 40,
      );
    case 'txt':
      return const Image(
        image: AssetImage('assets/txt-icon.png'),
        width: 40,
        height: 40,
      );
    case 'mp4':
      return const Image(
        image: AssetImage('assets/mp4-icon.png'),
        width: 40,
        height: 40,
      );
    case 'ppt':
    case 'pptx':
      return const Image(
        image: AssetImage('assets/ppt-icon.png'),
        width: 40,
        height: 40,
      );
    default:
      return const Icon(
        Icons.insert_drive_file,
        color: Colors.deepPurple,
        size: 40,
      );
  }
}

int getSeletedTabIndex(String label) {
  print("selected tab label => $label");
  switch (label.toLowerCase()) {
    case "notes":
      return 0;
    case 'questions':
      return 1;
    case 'blogs':
      return 2;
    default:
      return 0;
  }
}
