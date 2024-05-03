import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logistics/LoginScreen.dart';
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
  String base64String = '';
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = Uint8List(0);
  }

  void ImagetoBase64(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    String base64String = base64Encode(bytes);
    setState(() {
      this.base64String = base64String;
      _imageBytes = bytes;
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

  @override
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
                if (_imageBytes.isNotEmpty)
                  Image.memory(
                    _imageBytes,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      ImagetoBase64(File(pickedImage.path));
                    }
                  },
                  child: Text('Select Image'),
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
                ),
                SizedBox(height: 20),
                if (base64String.isNotEmpty)
                  TextFormField(
                    initialValue: base64String,
                    maxLines: null, // Allow multiple lines
                    decoration: const InputDecoration(
                      labelText: 'Image Byte Array',
                      labelStyle: TextStyle(
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.image, color: Colors.orange),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
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

}
