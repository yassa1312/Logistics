import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_screen/note1/shared.dart';


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
  String imageUrl = '';
  String tempImageUrl = '';
  late Stream<DocumentSnapshot> userDataStream;
  bool uploading = false;
  bool imagePicked = false;

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
    getUserDataFromLocalDataSource();
    getImageUrl(); // Load the image URL
    userDataStream = firestore.collection("users").doc(auth.currentUser!.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<DocumentSnapshot>(
              stream: userDataStream,
              builder: (context, value) {
                if (value.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (value.hasData) {
                  final map = value.data!.data() as Map<String, dynamic>;
                  nameController.text = map['name'] ?? '';
                  phoneNumberController.text = map['phone'] ?? '';
                  imageUrl = map['imageUrl'] ?? '';
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      InkWell(
                        borderRadius: BorderRadius.circular(70),
                        onTap: () => pickImage(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(tempImageUrl.isNotEmpty ? tempImageUrl : imageUrl),
                              radius: 70,
                            ),
                            if (uploading)
                              const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 20),
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
                    ],
                  );
                } else {
                  return const Text('Error fetching map');
                }
              },
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

      if (tempImageUrl.isNotEmpty) {
        data['imageUrl'] = tempImageUrl;
      }

      // Reference the Firestore document
      final userDocRef = firestore.collection("users").doc(userId);

      userDocRef.update(data).then((value) {
        // Data updated successfully
        setState(() {
          imageUrl = tempImageUrl;
          tempImageUrl = '';
        });
        Fluttertoast.showToast(
          msg: "Profile updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        print('User data updated successfully.');
      }).catchError((error) {
        // Handle any errors
        Fluttertoast.showToast(
          msg: "Error updating profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Error updating user data: $error');
      });
    }
  }

  void uploadImage(File image) async {
    setState(() {
      uploading = true;
    });

    final userId = auth.currentUser!.uid;
    final storageRef = storage.ref("profileImages/$userId.jpg");

    try {
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      setState(() {
        tempImageUrl = imageUrl;
        uploading = false;
      });

      Fluttertoast.showToast(
        msg: "Image uploaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } catch (error) {
      setState(() {
        uploading = false;
      });
      print('Error uploading the image: $error');
    }
  }

  void getUserData() {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      firestore.collection("users").doc(currentUser.uid).get().then((snapshot) {
        saveUserDataInLocalDataSource(snapshot.data()!); // Use snapshot.data() here
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


  void saveUserDataInLocalDataSource(Map<String, dynamic> map,)async{
    final json = jsonEncode(map);
    PreferenceUtils.setString(PrefKeys.profileData,json) ;
  }
  void getUserDataFromLocalDataSource() async {
    final json = PreferenceUtils.getString(PrefKeys.profileData);
    final userData = jsonDecode(json!);
    updateUi(userData);
  }

  void updateUi(Map<String, dynamic> map) {
    setState(() {
      nameController.text = map['name'];
      phoneNumberController.text = map['phone'];
      emailController.text = map['email'];
      imageUrl = map['imageUrl'];
    });
  }

  void pickImage() async {
    final imagePicker = ImagePicker();

    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageFile = File(image.path);
        uploadImage(imageFile);
      }
    } catch (error) {
      print('Error picking image: $error');
    }
  }
  void getImageUrl() {
    final userId = auth.currentUser!.uid;

    firestore.collection("users").doc(userId).get().then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final imageUrl = data['imageUrl'];
        if (imageUrl != null) {
          setState(() {
            this.imageUrl = imageUrl;
          });
        }
      }
    }).catchError((error) {
      print('Error getting the image URL from Firestore: $error');
    });
  }
}
