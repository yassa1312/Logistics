import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({Key? key}) : super(key: key);

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  late Uint8List _imageBytes1;
  late Uint8List _imageBytes2;
  late Uint8List _imageBytes3;
  String base64String1 = '';
  String base64String2 = '';
  String base64String3 = '';

  @override
  void initState() {
    super.initState();
    _imageBytes1 = Uint8List(0);
    _imageBytes2 = Uint8List(0);
    _imageBytes3 = Uint8List(0);
  }

  void ImagetoBase64(File imageFile, int imageIndex) async {
    Uint8List bytes = await imageFile.readAsBytes();
    String base64String = base64Encode(bytes);
    setState(() {
      if (imageIndex == 1) {
        base64String1 = base64String;
        _imageBytes1 = bytes;
      } else if (imageIndex == 2) {
        base64String2 = base64String;
        _imageBytes2 = bytes;
      } else if (imageIndex == 3) {
        base64String3 = base64String;
        _imageBytes3 = bytes;
      }
    });
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

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Upload', style: TextStyle(color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildImageSection1(),
                SizedBox(height: 20),
                buildImageSection2(),
                SizedBox(height: 20),
                buildImageSection3(),
                ElevatedButton(
                  onPressed: () {
                    if (base64String1.isNotEmpty || base64String2.isNotEmpty || base64String3.isNotEmpty) {
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
                  child: Text('Send Images'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageSection1() {
    return Column(
      children: [
        if (_imageBytes1.isNotEmpty)
          Image.memory(
            _imageBytes1,
            fit: BoxFit.cover,
          ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  ImagetoBase64(File(pickedImage.path), 1);
                }
              },
              icon: Icon(Icons.photo_library),
              label: Text('Gallery 1'),
            ),
            SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  ImagetoBase64(File(pickedImage.path), 1);
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Camera 1'),
            ),
          ],
        ),

      ],
    );
  }

  Widget buildImageSection2() {
    return Column(
      children: [
        if (_imageBytes2.isNotEmpty)
          Image.memory(
            _imageBytes2,
            fit: BoxFit.cover,
          ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  ImagetoBase64(File(pickedImage.path), 2);
                }
              },
              icon: Icon(Icons.photo_library),
              label: Text('Gallery 2'),
            ),
            SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  ImagetoBase64(File(pickedImage.path), 2);
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Camera 2'),
            ),
          ],
        ),

      ],
    );
  }

  Widget buildImageSection3() {
    return Column(
      children: [
        if (_imageBytes3.isNotEmpty)
          Image.memory(
            _imageBytes3,
            fit: BoxFit.cover,
          ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  ImagetoBase64(File(pickedImage.path), 3);
                }
              },
              icon: Icon(Icons.photo_library),
              label: Text('Gallery 3'),
            ),
            SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  ImagetoBase64(File(pickedImage.path), 3);
                }
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Camera 3'),
            ),
          ],
        ),
      ],
    );
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
        body: jsonEncode({
          "image1": base64String1,
          "image2": base64String2,
          "image3": base64String3,
        }),
      );

      // Check response status
      if (response.statusCode == 200) {
        print('Images sent successfully!');
        displayToast('Images sent successfully!');
        return true;
      } else {
        print('Error sending images: ${response.statusCode}');
        print('Error sending images: ${response.body}');

        displayToast('Error sending images: ${response.statusCode}');
        return false;
      }
    } catch (exception) {
      print('Error sending images: $exception');
      displayToast('Error sending images');
      return false;
    }
  }
}
