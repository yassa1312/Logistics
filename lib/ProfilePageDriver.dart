import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logistics/PasswordChange.dart';
import 'package:logistics/auth_service.dart';
import 'LoginScreen.dart';

class ProfilePageDriver extends StatefulWidget {
  final String? requestId; // Add this line

  ProfilePageDriver({Key? key, this.requestId}) : super(key: key); // Add this constructor

  @override
  _ProfilePageDriverState createState() => _ProfilePageDriverState();
}

class _ProfilePageDriverState extends State<ProfilePageDriver> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _carVINController = TextEditingController();
  final TextEditingController _plateNumController = TextEditingController();
  final TextEditingController _rideTypeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  Uint8List? _profileImageBytes;
  Uint8List? _carImageBytes;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() async {
    try {
      // Retrieve access token
      String? token = await AuthService.getAccessToken();

      if (token != null) {
        var headers = {
          'Authorization': 'Bearer $token',
        };

        String? baseUrl = await AuthService.getURL();
        var response = await http.get(
          Uri.parse('$baseUrl/api/User/DriverProfile/${widget.requestId}'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          // Decode and handle the response
          Map<String, dynamic> responseData = jsonDecode(response.body);

          setState(() {
            // Assign fetched data to controllers
            _nameController.text = responseData['name'] ?? '';
            _emailController.text = responseData['email'] ?? '';
            _phoneNumberController.text = responseData['phoneNumber'] ?? '';
            if (responseData["profile_Image"] != null) {
              _profileImageBytes = base64Decode(responseData["profile_Image"]);
            }
            // Access and assign car-related data if available
            if (responseData.containsKey('car')) {
              Map<String, dynamic> carData = responseData['car'];
              _carVINController.text = carData['car_VIN'] ?? '';
              _plateNumController.text = carData['plate_Num'] ?? '';
              _rideTypeController.text = carData['ride_Type'] ?? '';
              _colorController.text = carData['color'] ?? '';
              _carModelController.text = carData['car_Model'] ?? '';
              _capacityController.text = carData['capacity']?.toString() ?? '';

              if (carData["carImage"] != null) {
                _carImageBytes = base64Decode(carData["carImage"]);
              }
            }
          });
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

  Future<List<int>> fetchImageBytes(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Widget imageFromBytes(BuildContext context, List<int> bytes) {
    return Image.memory(
      Uint8List.fromList(bytes),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Driver Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_profileImageBytes != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      _profileImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (_carImageBytes != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      _carImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.account_box, color: Colors.orange),
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: Colors.orange),
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _plateNumController,
                decoration: const InputDecoration(
                  labelText: 'Plate Num',
                  prefixIcon: Icon(Icons.confirmation_num_outlined, color: Colors.orange),
                  labelStyle: TextStyle(
                    color: Colors.orange,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _rideTypeController,
                decoration: const InputDecoration(
                  labelText: 'Ride_Type',
                  prefixIcon: Icon(Icons.numbers, color: Colors.orange),
                  labelStyle: TextStyle(
                    color: Colors.orange,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _colorController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Color',
                        labelStyle: const TextStyle(
                          color: Colors.orange,
                        ),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.color_lens, color: Colors.orange),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _carModelController,
                      textInputAction: TextInputAction.next,
                      onChanged: (password) {},
                      decoration: InputDecoration(
                        labelText: 'Car Model',
                        labelStyle: const TextStyle(
                          color: Colors.orange,
                        ),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.directions_car, color: Colors.orange),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _capacityController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number, // Set keyboardType to accept numbers only
                      decoration: InputDecoration(
                        labelText: 'Capacity',
                        labelStyle: const TextStyle(
                          color: Colors.orange,
                        ),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.front_loader, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
