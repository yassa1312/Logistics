import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class NoteLine {
  final String text1;
  final TextStyle style1;
  final String text2;
  final TextStyle style2;
  final IconData? iconData;
  final TextStyle iconStyle;

  NoteLine({
    required this.text1,
    required this.style1,
    required this.text2,
    required this.style2,
    this.iconData,
    required this.iconStyle,
  });
}

List<List<NoteLine>> notes = [
  [
    NoteLine(
      text1: "Laurent 20:18",
      style1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text2: "How about meeting tomorrow?",
      style2: const TextStyle(fontSize: 18, color: Colors.grey),
      iconData: Icons.arrow_forward_ios,
      iconStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  ],
  [
    NoteLine(
      text1: "Tracy 19:22",
      style1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text2: "I love that idea, it's great!",
      style2: const TextStyle(fontSize: 18, color: Colors.grey),
      iconData: Icons.arrow_forward_ios,
      iconStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  ],
  [
    NoteLine(
      text1: "Claire 14:34",
      style1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text2: "I wasn't aware of that,\nLet me check",
      style2: const TextStyle(fontSize: 18, color: Colors.grey),
      iconData: Icons.arrow_forward_ios,
      iconStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  ],
  [
    NoteLine(
      text1: "Joe 11:05",
      style1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text2: "Flutter just release 1.0 officially.\nShould I go for it?",
      style2: const TextStyle(fontSize: 18, color: Colors.grey),
      iconData: Icons.arrow_forward_ios,
      iconStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  ],
  [
    NoteLine(
      text1: "Mark 09:46",
      style1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text2: "It totally makes sense to get some \n extra day-off.",
      style2: const TextStyle(fontSize: 18, color: Colors.grey),
      iconData: Icons.arrow_forward_ios,
      iconStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  ],
  [
    NoteLine(
      text1: "Williams 08:15",
      style1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      text2: "It has been rescheduled to next \n Saturday 7.30pm?",
      style2: const TextStyle(fontSize: 18, color: Colors.grey),
      iconData: Icons.arrow_forward_ios,
      iconStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  ],
  // Add more notes as needed...
];

List<List<NoteLine>> deletedNotes = [];

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            for (int index = 0; index < notes.length; index++)
              Column(
                children: [
                  buildNoteItem(index),
                  if (index < notes.length - 1)
                    const MyDivider(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildNoteItem(int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (NoteLine line in notes[index])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                line.text1,
                                style: line.style1,
                              ),
                              Text(
                                line.text2,
                                style: line.style2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}



















