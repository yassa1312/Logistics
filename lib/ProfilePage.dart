import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logistics/PasswordChange.dart';
import 'package:logistics/auth_service.dart';
import 'package:logistics/main.dart';
import 'LoginScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  Uint8List? _imageBytes;
  String base64String = '';


  @override
  void initState() {
    super.initState();
    fetchProfileData();
    _imageBytes = Uint8List(0);
  }
  // Declare a variable to store the image data as bytes
  void ImagetoBase64(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    String base64String = base64Encode(bytes);
    setState(() {
      this.base64String = base64String;
      _imageBytes = bytes;
    });
  }

  void _showProfileUpdateDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController(); // Controller for the password field

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to update your profile?',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Hide the entered text
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text;
                if (password.isEmpty) {
                  // Display toast indicating that password is required
                  displayToast('Password is required');
                } else {
                  // Proceed with updating the profile
                  editUserProfile();
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                textStyle: TextStyle(color: Colors.white),
              ),
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                textStyle: TextStyle(color: Colors.white),
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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

  void editUserProfile() async {
    try {
      // Retrieve access token
      String? token = await AuthService.getAccessToken();

      if (token != null) {
        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Specify content type
        };
        String? baseUrl = await AuthService.getURL();
        var request = http.Request(
            'PUT',
            Uri.parse(
                '$baseUrl/api/Account/EditMyProfile'));

        // Prepare request body
        request.headers.addAll(headers);
        request.body = jsonEncode({
          'password': _passwordController.text,
          'name': _nameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
        });

        // Print request body for debugging
        print('Request Body: ${request.body}');

        // Send the request
        http.StreamedResponse response = await request.send();
        String responseString = await response.stream.bytesToString();

        print('Response Status Code: ${response.statusCode}');
        print('Response Reason Phrase: ${response.reasonPhrase}');
        print('Response Body: $responseString');

        if (response.statusCode == 200) {
          print('Response: $responseString');
          Fluttertoast.showToast(
            msg: "Profile updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          print('Failed to edit profile: ${response.reasonPhrase}');
          Fluttertoast.showToast(
            msg: "Failed to update profile: ${response.reasonPhrase}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        print('Access token is null.');
      }
    } catch (error) {
      print("Error editing profile: $error");
    }
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
          Uri.parse('$baseUrl/api/Account/MyProfile'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          // Decode and handle the response
          Map<String, dynamic> responseData = jsonDecode(response.body);
          // Do something with responseData
          print(responseData);

          setState(() {
            // Example: Assign fetched data to controllers
            _nameController.text = responseData['name'] ?? '';
            _emailController.text = responseData['email'] ?? '';
            _phoneNumberController.text = responseData['phoneNumber'] ?? '';
            setState(() {
              if (responseData["profile_Image"] != null) {
                _imageBytes = base64Decode(responseData["profile_Image"]);
              } else {
                _imageBytes = null;
              }
            });

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

  Future<bool> _sendImage() async {
    String? baseUrl = await AuthService.getURL();
    final url = Uri.parse('$baseUrl/api/Account/UploadFile');
    String? token = await AuthService.getAccessToken();

    if (token == null) {
      print('Access token is missing.');
      displayToast('Access token is missing.');
      return false;
    }

    try {

      // Make HTTP POST request
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          "$base64String",
        ),
      );

      // Check response status
      if (response.statusCode == 200) {
        print('Image sent successfully!');
        displayToast('Image sent successfully!');
        return true;
      } else {
        print('Error sending image: ${response.statusCode}');
        print('Error sending image: ${response.body}');

        displayToast('Error sending image: ${response.statusCode}');
        return false;
      }
    } catch (exception) {
      print('Error sending image: $exception');
      displayToast('Error sending image');
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_imageBytes == null)
                SizedBox(height: 0),
              if (_imageBytes != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
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
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        ImagetoBase64(File(pickedImage.path));
                      }
                    },
                    icon: Icon(Icons.photo_library),
                    label: Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedImage = await picker.pickImage(source: ImageSource.camera);
                      if (pickedImage != null) {
                        ImagetoBase64(File(pickedImage.path));
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (base64String.isNotEmpty) {
                    _sendImage().then((success) {
                      if (success) {
                        // Handle success
                      } else {
                        // Handle failure
                      }
                    }).catchError((error) {
                      // Handle error
                    });
                  }
                },
                child: Text('Send Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Colors.orange),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showProfileUpdateDialog(context);
                },

                child: Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordChange()),
                  );
                },
                child: Text('Password Change'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
