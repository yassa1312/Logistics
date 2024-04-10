import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logistics/home.dart';
import 'package:logistics/main.dart';

class ElectronicWalletPaymentPage extends StatefulWidget {
  @override
  _ElectronicWalletPaymentPageState createState() =>
      _ElectronicWalletPaymentPageState();
}

class _ElectronicWalletPaymentPageState
    extends State<ElectronicWalletPaymentPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  bool _showPhoneNumberInput = true;
  bool _showOTPInput = false;

  void _submitPhoneNumber() {
    if (_phoneNumberController.text.isNotEmpty) {
      setState(() {
        _showPhoneNumberInput = false;
        _showOTPInput = true;
      });
      Fluttertoast.showToast(msg: "Phone number submitted");
    } else {
      Fluttertoast.showToast(msg: "Please enter a phone number");
    }
  }

  void _submitOTP() {
    if (_otpController.text.isNotEmpty) {
      // Logic to submit OTP to Instapay for verification
      // If OTP is verified, you can proceed with payment or any further action
      // Otherwise, you may display an error message or allow the user to resend OTP
      Fluttertoast.showToast(msg: "OTP submitted");

      // Navigate to the home page after OTP submission
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Fluttertoast.showToast(msg: "Please enter OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Electronic Wallet',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showPhoneNumberInput)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                  ),
                ),
              ),
            if (_showPhoneNumberInput)
              ElevatedButton(
                onPressed: _submitPhoneNumber,
                child: Text('Submit Phone Number'),
              ),
            if (_showOTPInput)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                  ),
                ),
              ),
            if (_showOTPInput)
              ElevatedButton(
                onPressed: _submitOTP,
                child: Text('Submit OTP'),
              ),
            SizedBox(height: 20),
            Text(
              'Electronic Wallet Payment Page',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

