import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/LoginScreen.dart';
import 'package:logistics/auth_service.dart';
import 'dart:convert';

import 'package:logistics/main.dart';



class CheckoutPage extends StatelessWidget {
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
              'From: $sourceLocation',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'To: $destinationLocation',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Choosen truck: $selectedTruck',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Cost: $totalCost',
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
              children: selectedServices
                  .map((service) => Text(
                '- $service',
                style: const TextStyle(fontSize: 16),
              ))
                  .toList(),
            ),
            const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            // Call the createShipmentRequest function with the selected locations
            await createShipmentRequest(
                sourceLocation, destinationLocation, selectedTruck);

            displayToast('Shipment request created successfully!');
            // Navigate to the login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: const Text(
            "Order Confirm",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
void displayToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.orange,
    textColor: Colors.white,
    fontSize: 18.0,
  );
}
Future<void> createShipmentRequest(
    String pickUpLocation, String dropOffLocation, String selectedTruck) async {
  final url = Uri.parse('http://www.logistics-api.somee.com/api/User/CreateRequest');

  try {
    String? token = await AuthService.getAccessToken();

    if (token == null) {
      print('Access token is null');
      return;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'pick_Up_Location': pickUpLocation,
        'drop_Off_Location': dropOffLocation,
        'ride_Type': selectedTruck,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON or handle the success.
      print('Shipment request created: ${response.body}');

      // Show a confirmation dialog or navigate to another page
    } else {
      // If the server returns an error response,
      // then throw an exception or handle the error.
      print('Failed to create shipment request: ${response.body}');
    }
  } catch (exception) {
    // Handle exceptions by printing the error
    print('Error creating shipment request: $exception');
  }
}