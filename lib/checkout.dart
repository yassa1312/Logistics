import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logistics/auth_service.dart';
import 'package:logistics/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PaymentPage.dart';

class CheckoutPage extends StatefulWidget {
  final String sourceLocation;
  final String destinationLocation;
  final String selectedTruck;
  final String selectedType;
  final String selectedCapacity;
  final String totalCost;

  CheckoutPage({
    required this.sourceLocation,
    required this.destinationLocation,
    required this.selectedTruck,
    required this.selectedType,
    required this.selectedCapacity,
    required this.totalCost,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Uint8List? _imageBytes;
  String base64String = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _launchMapUrl(widget.sourceLocation);
                },
                child: Text(
                  'From: ${widget.sourceLocation}',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _launchMapUrl(widget.destinationLocation);
                },
                child: Text(
                  'To: ${widget.destinationLocation}',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              Text('Selected Truck: ${widget.selectedTruck}', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Selected Type: ${widget.selectedType}', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Selected Capacity: ${widget.selectedCapacity} Ton', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Total Cost: ${widget.totalCost} EGP', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text(
                'If You Want to Add an Image:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if (_imageBytes != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedImage != null) {
                              ImagetoBase64(File(pickedImage.path));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Gallery'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedImage = await picker.pickImage(source: ImageSource.camera);
                            if (pickedImage != null) {
                              ImagetoBase64(File(pickedImage.path));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Camera'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool success = await createShipmentRequest(
                      context,
                      widget.sourceLocation,
                      widget.destinationLocation,
                      widget.selectedTruck,
                      widget.selectedType,
                      widget.selectedCapacity,
                      widget.totalCost);

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
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
      ),
    );
  }


  void ImagetoBase64(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    String tempBase64String = base64Encode(bytes);
    setState(() {
      base64String = tempBase64String;
      _imageBytes = bytes;
    });
  }

  void _launchMapUrl(String location) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Future<bool> createShipmentRequest(BuildContext context, String pickUpLocation,
      String dropOffLocation, String selectedTruck,
      String selectedType, String selectedCapacity, String totalCost) async {
    String? baseUrl = await AuthService.getURL();
    final url = Uri.parse('$baseUrl/api/User/CreateRequest');

    try {
      String? token = await AuthService.getAccessToken();

      if (token == null) {
        print('Access token is null');
        displayToast('Failed to get access token');
        return false;
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
          "Delivery_Kind": selectedType,
          "Load_Weight": selectedCapacity,
          "load_Image": "$base64String",
          "cost": totalCost,
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
      } else if (response.statusCode == 400) {
        print('You reached the max limit of active requests');
        print('Status Code: ${response.statusCode}');
        displayToast('You reached the max limit of active requests');
        print('Shipment request created: ${response.body}');
        return false;
      } else {
        print('Unexpected status code: ${response.statusCode}');
        displayToast('Failed to create shipment request');
        return false;
      }
    } catch (exception) {
      print('Error creating shipment request: $exception');
      displayToast('Error creating shipment request');
      return false;
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
}
