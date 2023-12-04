import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_screen/note1/database/note_database.dart';
import 'dart:io';
import 'package:login_screen/note1/model/note.dart';



class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  AddNoteScreenState createState() => AddNoteScreenState();
}

class AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  late String id; // Unique ID for the note.
  String? imageUrl; // Store the selected image URL.

  @override
  void initState() {
    super.initState();
    id = DateTime.now().millisecondsSinceEpoch.toString(); // Generate a unique ID.
  }

  Future<String?> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/$id.jpg');

      final TaskSnapshot uploadTask = await storageReference.putFile(File(image.path));
      imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    }
    return null; // Return null if no image is selected.
  }

  void addNote() async {
    final String title = titleController.text;
    final String content = contentController.text;
    if (user != null) {
      final Map<String, dynamic> result = {
        'id': id,
        'userId': user!.uid,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
      };
      // Insert note into the local SQLite database
      final note = Note(id, title, content);
      NoteDatabase.insertNotes(note);
      try {
        // Add note to Firestore
        await firestore.collection("notes").doc(id).set(result);
        // Navigate back
        Navigator.pop(context);
      } catch (error) {
        print("Error adding note: $error");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contentController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Note Content',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            TextButton(
              onPressed: () async {
                final image = await pickAndUploadImage();
                setState(() {
                  imageUrl = image;
                });
              },
              child: const Text(
                "Add Image",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size as needed.
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (imageUrl != null)
              Container(
                height: 200, // Adjust the height to your desired square size.
                width: 200, // Adjust the width to match the height for a square shape.
                alignment: Alignment.bottomCenter,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover, // Use 'cover' to fill the square while maintaining the aspect ratio.
                ),
              ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addNote,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 0,
                minimumSize: const Size(double.infinity, 0),
              ),
              child: const Text(
                "Add",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
