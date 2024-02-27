import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore
    fetchData();
  }

  void fetchData() async {
    try {
      // Assuming you have a collection named 'users' in Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc('user_id').get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        setState(() {
          _emailController.text = userData['email'] ?? '';
          _imageUrlController.text = userData['imageUrl'] ?? '';
          _nameController.text = userData['name'] ?? '';
          _phoneNumberController.text = userData['phoneNumber'] ?? '';
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange, // Background color of the entire app bar
        title: Text('Profile'),
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Field
            CircleAvatar(
              radius: 50,
              backgroundImage: _imageUrlController.text.isNotEmpty
                  ? NetworkImage(_imageUrlController.text)
                  : null,
              child: _imageUrlController.text.isEmpty ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 20),

            // Email Field
            TextFormField(
              controller: _emailController,
              readOnly: true, // Read-only as it's fetched from Firestore
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Colors.orange),
                labelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            SizedBox(height: 20),
            // Name Field
            TextFormField(
              controller: _nameController,
              readOnly: true, // Read-only as it's fetched from Firestore
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.account_box, color: Colors.orange),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            SizedBox(height: 10),
            // Phone Number Field
            TextFormField(
              controller: _phoneNumberController,
              readOnly: true, // Read-only as it's fetched from Firestore
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone, color: Colors.orange),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // You can add edit functionality here if needed
              },
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
