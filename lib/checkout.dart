import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}
