import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/auth_service.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:logistics/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PaymentPage.dart';

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
            GestureDetector(
              onTap: () {
                _launchMapUrl(sourceLocation); // Open Google Maps with sourceLocation
              },
              child: Text(
                'From: $sourceLocation',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchMapUrl(destinationLocation); // Open Google Maps with sourceLocation
              },
              child: Text(
                'To: $destinationLocation',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            Text('Selected Truck: $selectedTruck', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Total Cost: $totalCost', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text('Selected Services:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedServices
                  .map((service) => Text('- $service', style: TextStyle(fontSize: 16)))
                  .toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                bool success = await createShipmentRequest(
                    context, sourceLocation, destinationLocation, selectedTruck);

                if (success) {
                  fetchDataAndSaveToSharedPrefs();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(totalCost: totalCost),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Confirm Order',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchMapUrl(String location) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
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

Future<bool> createShipmentRequest(BuildContext context, String pickUpLocation,
    String dropOffLocation, String selectedTruck) async {
  final url = Uri.parse('http://www.logistics-api.somee.com/api/User/CreateRequest');

  try {
    String? token = await AuthService.getAccessToken();

    if (token == null) {
      print('Access token is null');
      return false;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', //TODO Service
      },
      body: json.encode({
        'pick_Up_Location': pickUpLocation,
        'drop_Off_Location': dropOffLocation,
        'ride_Type': selectedTruck,
      }),
    );

    if (response.statusCode == 200) {
      print('Shipment request created: ${response.body}');
      print('Status Code: ${response.statusCode}');
      displayToast('Shipment request created successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      return true;
    } else {
      print('Failed to create shipment request: ${response.body}');
      print('Status Code: ${response.statusCode}');
      displayToast('Failed to create shipment request');
      return false;
    }
  } catch (exception) {
    print('Error creating shipment request: $exception');
    displayToast('Error creating shipment request');
    return false;
  }
}

Future<void> fetchDataAndSaveToSharedPrefs() async {
  try {
    String? token = await AuthService.getAccessToken();

    if (token != null) {
      var headers = {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      };

      var response = await http.get(
        Uri.parse('http://www.logistics-api.somee.com/api/User/MyRequests'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Decode and handle the response
        List<dynamic> responseData = jsonDecode(response.body);

        // Extracting and saving request_Id
        if (responseData.isNotEmpty) {
          String requestId = responseData[0]['request_Id'];
          await saveRequestIdToPrefs(requestId);
          print('request_Id saved to shared preferences: $requestId');
        }
      } else {
        print('Failed to fetch profile data: ${response.reasonPhrase}');
      }
    } else {
      print('Access token is null.');
    }
  } catch (error) {
    print("Error fetching data: $error");
  }
}

Future<void> saveRequestIdToPrefs(String requestId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('request_Id', requestId);
}
