import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:login_screen/note1/LoginScreen.dart';
import 'package:login_screen/note1/database/note_database.dart';
import 'package:login_screen/note1/homeScreen/AddNoteScreen.dart';
import 'package:login_screen/note1/homeScreen/EditNoteScreen.dart';
import 'package:login_screen/note1/homeScreen/ProfileNameScreen.dart';
import 'package:login_screen/note1/shared.dart';


class Note {
  String id;
  String userId;
  String title;
  String content;
  String? imageUrl;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
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
  final firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? notesStream;

  @override
  void initState() {
    super.initState();
    notesStream = getNotesStream();
    checkInternetConnection();
    isLoggedIn();
  }
  void checkInternetConnection()async {
    bool hasConnection =await InternetConnectionChecker().hasConnection;
    if(hasConnection){
      print("hasConnect");
      getNotesFromFireStorage();
    }else{
      print("NoConnect");
      getNotesStream();
    }
  }


  Stream<QuerySnapshot> getNotesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return firestore
          .collection("notes")
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    } else {
      return Stream.fromFuture(NoteDatabase.getNotes() as Future<QuerySnapshot<Object?>>);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              saveLogout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //FirebaseCrashlytics.instance.crash();//for fixed error in Crashlytics
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          ).then((result) {
            if (result != null && result is Map<String, dynamic>) {
              final String id = result['id'] ?? '';
              final String title = result['title'] ?? '';
              final String content = result['content'] ?? '';
              final String? imageUrl = result['imageUrl'];

              if (id.isNotEmpty && title.isNotEmpty && content.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  final note = Note(
                    id: id,
                    userId: user.uid,
                    title: title,
                    content: content,
                    imageUrl: imageUrl,
                  );

                  setState(() {
                    notes.insert(0, note);
                  });
                }
              }
            }
          });
        },
        child: const Icon(Icons.add),
      ),



      body: StreamBuilder<QuerySnapshot>(
        stream: notesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("");
          }

          final notesData = snapshot.data!.docs;
          notes = notesData.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final id = doc.id;
            final title = data['title'] as String;
            final content = data['content'] as String;
            final imageUrl = data['imageUrl'] as String?;
            return Note(
              id: id,
              userId: FirebaseAuth.instance.currentUser!.uid,
              title: title,
              content: content,
              imageUrl: imageUrl,
            );
          }).toList();

          notes = notes.reversed.toList();

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return buildNoteItem(index);
            },
          );
        },
      ),
    );
  }

  Widget buildNoteItem(int index) {
    final Note note = notes[index];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.black26, width: 1),
      ),
      color: Colors.white38,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        note.content,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                if (note.imageUrl != null)
                  Expanded(
                    flex: 1,
                    child: Image.network(
                      note.imageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print("Deleting note at index $index with ID: ${note.id}");
                      NoteDatabase.deleteNote(note.id);
                      _deleteNoteAt(index, note.id);
                      print("Note deleted successfully.");
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNoteScreen(
                            initialTitle: note.title,
                            initialContent: note.content,
                            id: note.id,
                            userId: note.userId,
                            initialImageUrl: note.imageUrl,
                          ),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        final String editedTitle = result['title'] ?? '';
                        final String editedContent = result['content'] ?? '';
                        final String? editedImageUrl = result['imageUrl'];

                        if (editedTitle.isNotEmpty && editedContent.isNotEmpty) {
                          updateNoteInFirestore(note.id, editedTitle, editedContent, editedImageUrl);
                        }
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _deleteNoteAt(int index, String id) {
    if (index >= 0 && index < notes.length) {
      deleteNoteFromFirestore(id);
    }
  }

  void updateNoteInFirestore(String id, String title, String content, String? imageUrl) {
    firestore.collection("notes").doc(id).update({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    }).catchError((error) {
      print("Error updating note in Firestore: $error");
    });
  }

  void deleteNoteFromFirestore(String id) {
    firestore.collection("notes").doc(id).delete().catchError((error) {
      print("Error deleting note from Firestore: $error");
    });
  }

  void isLoggedIn()async {
    final loggedIn = PreferenceUtils.getBool(PrefKeys.loggedIn);
    print ('LoggedIn=>$loggedIn');
  }

  void saveLogout()async{
    PreferenceUtils.setBool( PrefKeys.loggedIn ,false);
  }
}

void getNotesFromFireStorage() {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    firestore
        .collection("notes")
        .where('userId', isEqualTo: user.uid)
        .get()
        .then((querySnapshot) {
      // Process the querySnapshot to retrieve notes and update the state
      querySnapshot.docs.forEach((doc) {
        // Extract data and update the state accordingly
      });
    }).catchError((error) {
      print("Error fetching notes from Firestore: $error");
      print("Failed to connect to Firestore. Please check your internet connection.");
    });
  }
}


