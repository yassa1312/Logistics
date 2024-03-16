import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Dio dio = Dio();
  bool _isLoading = true;
  late String _totalAmount = '';
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
      // Make API call to fetch payment details
      Response response = await dio.get('YOUR_PAYMENT_DETAILS_API_ENDPOINT');

      // Extract data from response
      Map<String, dynamic> data = response.data;

      // Update state with fetched data
      setState(() {
        _totalAmount = data['totalAmount'];
        _paymentMethods = List<String>.from(data['paymentMethods']);
        _selectedPaymentMethod = _paymentMethods.isNotEmpty ? _paymentMethods[0] : '';
        _isLoading = false;
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
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Amount: \$_totalAmount', // Display fetched total amount
                style: TextStyle(fontSize: 20, color: Colors.orange),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Method:',
                style: TextStyle(fontSize: 18, color: Colors.orange),
              ),
              DropdownButton<String>(
                items: _paymentMethods.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
                dropdownColor: Colors.black,
                value: _selectedPaymentMethod,
                style: TextStyle(color: Colors.orange),
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
