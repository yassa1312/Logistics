import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logistics/home.dart';
import 'package:logistics/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ElectronicWallet.dart';
import 'CreditCardPaymentPage.dart';
import 'PayPalPaymentPage.dart';

class PaymentPage extends StatefulWidget {
  final String totalCost;
  PaymentPage({required this.totalCost});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Dio dio = Dio();
  bool _isLoading = true;
  late List<String> _paymentMethods = [];
  late String _selectedPaymentMethod = '';

  @override
  void initState() {
    super.initState();
    // Fetch payment details from API
    _fetchPaymentDetails();
  }

  Future<void> _fetchPaymentDetails() async {
    try {
      // Simulate fetching payment details from API
      await Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _paymentMethods = ['Credit Card', 'PayPal', 'Electronic Wallet','Cash']; // Example payment methods
          _selectedPaymentMethod = _paymentMethods.isNotEmpty ? _paymentMethods[0] : '';
          _isLoading = false;
        });
      });
    } catch (e) {
      // Handle error
      print('Error fetching payment details: $e');
      // Set isLoading to false to stop loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _makePayment() async {
    // Implement payment logic here
    switch (_selectedPaymentMethod) {
      case 'Credit Card':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreditCardPaymentPage()),
        );
        break;
      case 'PayPal':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PayPalPaymentPage()),
        );
        break;
      case 'Electronic Wallet':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ElectronicWalletPaymentPage()),
        );
      case 'Cash':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        break;
      default:
        print('Invalid payment method');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: ${widget.totalCost}', // Display total amount
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                items: _paymentMethods.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 18, color: Colors.black), // Adjust the font size as needed
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
                value: _selectedPaymentMethod,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _makePayment,
                child: Text('Make Payment'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




