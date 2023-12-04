
import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  final String initialTitle;
  final String initialContent;
  final bool initialIsImportant;
  final String initialImageUrl;

  const EditNoteScreen({
    required this.initialTitle,
    required this.initialContent,
    required this.initialIsImportant,
    required this.initialImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  EditNoteScreenState createState() => EditNoteScreenState();
}

class EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  TextEditingController imageUrlController = TextEditingController();
  bool isImportant = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);
    imageUrlController.text = widget.initialImageUrl;
    isImportant = widget.initialIsImportant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 20),
            TextField(
              controller: imageUrlController,
              onChanged: (value) {
                // Handle changes to the image URL
              },
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String title = titleController.text;
                final String content = contentController.text;
                final String imageUrl = imageUrlController.text;

                final Map<String, dynamic> result = {
                  'title': title,
                  'content': content,
                  'imageUrl': imageUrl,
                  'isImportant': isImportant,
                };

                Navigator.of(context).pop(result);
              },
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

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }
}
