import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/task17my/LoginScreen.dart';
class Note {
  final String title;
  final String content;
  bool isImportant;
  String imageUrl;

  Note({
    required this.title,
    required this.content,
    this.isImportant = false,
    this.imageUrl = '',
  });

  static fromMap(Map e) {}
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          // Add the logout icon button
          IconButton(
            icon: const Icon(Icons.logout), // Choose an appropriate logout icon
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()
               )
              );
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          ).then((result) {
            if (result != null && result is Map<String, dynamic>) {
              final String title = result['title'] ?? '';
              final String content = result['content'] ?? '';
              final bool isImportant = result['isImportant'] ?? false;
              final String imageUrl = result['imageUrl'] ?? '';

              if (title.isNotEmpty && content.isNotEmpty) {
                notes.add(Note(
                  title: title,
                  content: content,
                  isImportant: isImportant,
                  imageUrl: imageUrl,
                ));
                setState(() {});
              }
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: notes.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return buildNoteItem(index);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildNoteItem(int index) {
    final Note note = notes[index];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              if (note.isImportant)
                const Text(
                  "Important Note",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              Checkbox(
                value: note.isImportant,
                onChanged: (value) {
                  setState(() {
                    note.isImportant = value ?? false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            note.content,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          if (note.imageUrl.isNotEmpty)
            Image.network(
              note.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _deleteNoteAt(index);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.red,
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(
                          initialTitle: note.title,
                          initialContent: note.content,
                          initialIsImportant: note.isImportant,
                          initialImageUrl: note.imageUrl,
                        ),
                      ),
                    ).then((result) {
                      if (result != null && result is Map<String, dynamic>) {
                        final String editedTitle = result['title'] ?? '';
                        final String editedContent = result['content'] ?? '';
                        final bool editedIsImportant = result['isImportant'] ?? false;
                        final String editedImageUrl = result['imageUrl'] ?? '';

                        if (editedTitle.isNotEmpty && editedContent.isNotEmpty) {
                          notes[index] = Note(
                            title: editedTitle,
                            content: editedContent,
                            isImportant: editedIsImportant,
                            imageUrl: editedImageUrl,
                          );
                          setState(() {});
                        }
                      }
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteNoteAt(int index) {
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
      setState(() {});
    }
  }
}

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  AddNoteScreenState createState() => AddNoteScreenState();
}

class AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  bool isImportant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
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
