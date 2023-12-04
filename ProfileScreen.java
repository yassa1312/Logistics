import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  String imageUrl = ''; // Store the selected image URL here
  bool obscureText1 = true;
  double strength = 0.0;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load user data when the profile screen is displayed
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          if (imageUrl.isEmpty)
            InkWell(
              borderRadius: BorderRadius.circular(45),
              onTap: () => pickImage(),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 30,
                child: const Icon(Icons.person, size: 45),
              ),
            )
          else
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 30,
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumberController,
                    textInputAction: TextInputAction.next,
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    enabled: false,
                    initialValue: auth.currentUser?.email,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        // Update the user's data
                        saveUserData();
                      },
                      child: const Text(
                        "Save Profile",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveUserData() {
    final user = auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final data = {
        'name': nameController.text,
        'phone': phoneNumberController.text,
      };

      // Reference the Firestore document
      final userDocRef = firestore.collection("users").doc(userId);

      userDocRef.get().then((snapshot) {
        final existingData = snapshot.data() as Map<String, dynamic>;

        // Compare the new data with the existing data
        if (data['name'] != existingData['name'] ||
            data['phone'] != existingData['phone']) {
          // Data has changed, update Firestore
          userDocRef.update(data).then((value) {
            // Data updated successfully
            Fluttertoast.showToast(
              msg: "Profile updated",
              toastLength: Toast.LENGTH_SHORT, // Corrected here
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            print('User data updated successfully.');
          }).catchError((error) {
            // Handle any errors
            Fluttertoast.showToast(
              msg: "Error updating profile",
              toastLength: Toast.LENGTH_SHORT, // Corrected here
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            print('Error updating user data: $error');
          });
        }
      }).catchError((error) {
        // Handle error
        print(error);
      });
    }
  }

  void getUserData() {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      firestore.collection("users").doc(currentUser.uid).get().then((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            nameController.text = data['name'] ?? '';
            phoneNumberController.text = data['phone'] ?? '';
          });
        }
      }).catchError((error) {
        // Handle error
        print(error);
      });
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path); // Corrected here
      uploadImage(imageFile);
    }
  }

  void uploadImage(File image) {
    storage.ref("profileImages/imageName").putFile(image).then((value) {
      print('uploadImage=>SUCCESS');
    }).catchError((error) {
      print('uploadImage=> $error');
    });
  }
}
