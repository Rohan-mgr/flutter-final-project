import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';

Future<bool> sendMail({String? recipientEmail, String? recipientName}) async {
  String username = dotenv.env['APP_EMAIL']!;
  String password = dotenv.env['APP_EMAIL_PASSWORD']!;
  try {
    final smtpServer = gmail(username, password);

    // Format the current date and time
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm a', 'en_US').format(DateTime.now());

    String otp = generateOTP();

    String htmlContent =
        await rootBundle.loadString('assets/email_template.html');

    htmlContent = htmlContent.replaceAll('{recipientName}', recipientName!);
    htmlContent = htmlContent.replaceAll('{otp}', otp);
    htmlContent = htmlContent.replaceAll('{date}', formattedDateTime);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'RPM Group')
      ..recipients.add(recipientEmail)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Reset Your Password - ${formattedDateTime}'
      ..html = htmlContent;

    final sendReport = await send(message, smtpServer);
    print('Mail send successfull' + sendReport.toString());
    return true;
  } catch (error) {
    print("Error sending mail: $error");
    return false;
  }
}
