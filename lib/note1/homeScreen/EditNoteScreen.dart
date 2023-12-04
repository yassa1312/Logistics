import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_screen/note1/database/note_database.dart';
import 'dart:io';

import '../model/note.dart';

class EditNoteScreen extends StatefulWidget {
  final String initialTitle;
  final String initialContent;
  final String id;
  final String userId;
  final String? initialImageUrl;

  const EditNoteScreen({
    required this.initialTitle,
    required this.initialContent,
    required this.id,
    required this.userId,
    this.initialImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  EditNoteScreenState createState() => EditNoteScreenState();
}

class EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? imageUrl; // Store the selected image URL.

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);

    // Load the image URL from Firebase Storage.
    if (widget.initialImageUrl != null) {
      imageUrl = widget.initialImageUrl;
    } else {
      // If no initialImageUrl is provided, attempt to fetch it from Firebase Storage.
      fetchImageFromStorage();
    }
  }

  Future<void> fetchImageFromStorage() async {
    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/${widget.id}.jpg');
      imageUrl = await storageReference.getDownloadURL();
      setState(() {}); // Trigger a rebuild to display the fetched image.
    } catch (e) {
      // Handle any errors when fetching the image.
      print('Error fetching image from storage: $e');
    }
  }

  Future<String?> pickAndUploadImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/${widget.id}.jpg');
      final TaskSnapshot uploadTask = await storageReference.putFile(File(image.path));
      imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    }
    return null; // Return null if no image is selected.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
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
                if (image != null) {
                  setState(() {
                    imageUrl = image;
                  });
                }
              },
              child: const Text(
                "Change Image",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size as needed.
                ),
              ),
            ),
            if (imageUrl != null)
              Container(
                height: 200, // Adjust the height to your desired square size.
                width: 200,  // Adjust the width to match the height for a square shape.
                alignment: Alignment.bottomCenter,
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover, // Use 'cover' to fill the square while maintaining the aspect ratio.
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateNote,
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
                "Update",
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
  void updateNote() async  {
    final String title = titleController.text;
    final String content = contentController.text;

    final Map<String, dynamic> result = {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
    final note = Note(widget.id, title, content);
    NoteDatabase.updateNote(note);

    // You can update the data in Firebase or your preferred storage.
    // For example, in Firestore: firestore.collection("notes").doc(widget.id).update(result);

    // After updating, you can navigate back or perform other actions.
    Navigator.pop(context, result);
  }
  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
