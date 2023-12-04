import 'package:flutter/material.dart';
import 'package:login_screen/task17my/LoginScreen.dart';
import 'dart:math';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  // Function to generate a random 6-digit verification code
  String generateVerificationCode() {
    final random = Random();
    int code = random.nextInt(900000) + 100000; // Generate a random 6-digit number
    return code.toString();
  }

  // Function to handle sending OTP email
  Future<void> sendOtpEmail(BuildContext context, String email, String verificationCode) async {
    try {
      // Generate a 6-digit verification code
      verificationCode = generateVerificationCode();

      // Send the verification code via email or other means (not Firebase)
      // You would typically use a third-party email service or a custom solution for this.

      // Navigate to OTP verification screen with the verification code
      navToOtpScreen(context, verificationCode);
    } catch (e) {
      // Handle error: The email may not be registered, or there was a network issue.
      print('Error sending OTP email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(); // Create a TextEditingController

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topLeft,
          child: Text("Forget password"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 120),
            TextFormField(
              controller: emailController, // Associate the controller with the TextFormField
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Get the email from the TextFormField and call sendOtpEmail
                  String email = emailController.text;
                  String verificationCode = generateVerificationCode();
                  sendOtpEmail(context, email, verificationCode);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Send OTP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // ... Other TextFormField widgets
          ],
        ),
      ),
    );
  }
}
