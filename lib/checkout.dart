import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/auth_service.dart';
import 'dart:convert';




Future<void> createShipmentRequest(
    String pickUpLocation, String dropOffLocation, String selectedTruck) async {
  final url =
  Uri.parse('http://www.logistics-api.somee.com/api/User/CreateRequest');

  try {
    String? token = await AuthService.getAccessToken(); // Retrieve access token

    if (token == null) {
      print('Access token is null');
      return;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include access token in the headers
      },
      body: json.encode({
        'pick_Up_Location': pickUpLocation,
        'drop_Off_Location': dropOffLocation, // Correct typo in drop_Off_Location
        'ride_Type': selectedTruck,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Shipment request created: ${response.body}');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Failed to create shipment request: ${response.body}');
    }
  } catch (exception) {
    // Handle exceptions by printing the error
    print('Error creating shipment request: $exception');
  }
}
class CheckoutPage extends StatefulWidget {
  final String sourceLocation;
  final String destinationLocation;
  final String selectedTruck;
  final String totalCost;
  final List<String> selectedServices;

  CheckoutPage({
    required this.sourceLocation,
    required this.destinationLocation,
    required this.selectedTruck,
    required this.totalCost,
    required this.selectedServices,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await AuthService.getAccessToken();
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ${widget.sourceLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'To: ${widget.destinationLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Choosen truck: ${widget.selectedTruck}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Cost: ${widget.totalCost}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Token: $_token',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Services:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.selectedServices
                  .map((service) => Text(
                '- $service',
                style: const TextStyle(fontSize: 16),
              ))
                  .toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Call the createShipmentRequest function with the selected locations
                createShipmentRequest(
                  widget.sourceLocation,
                  widget.destinationLocation,
                  widget.selectedTruck,
                );

                // Navigate to the next page or show a confirmation message
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}