import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> createShipmentRequest(
    String pickUpLocation, String dropOffLocation, String selectedTruck) async {
  final url =
      Uri.parse('http://www.logistics-api.somee.com/api/User/CreateRequest');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'pick_Up_Location': pickUpLocation,
        'drop_Off_Locatiom': dropOffLocation,
        'ride_Type': selectedTruck, // You need to define the ride type
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
        title: Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: $sourceLocation',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'To: $destinationLocation',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Choosen truck: $selectedTruck',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Cost: $totalCost',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Services:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedServices
                  .map((service) => Text(
                        '- $service',
                        style: TextStyle(fontSize: 16),
                      ))
                  .toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Call the createShipmentRequest function with the selected locations
                createShipmentRequest(
                    sourceLocation, destinationLocation, selectedTruck);

                // Navigate to the next page or show a confirmation message
              },
              child: Text('Confirm Order'),
            )
          ],
        ),
      ),
    );
  }
}
