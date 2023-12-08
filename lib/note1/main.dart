import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/e/core/app_dio.dart';
import 'package:login_screen/e/ui/e_login_screen.dart';
import 'package:login_screen/news/NewMainScreen.dart';
import 'package:login_screen/note1/homeScreen/HomeScreen.dart';
import 'package:login_screen/note1/LoginScreen.dart';
import 'package:login_screen/note1/notification.dart';
import 'package:login_screen/note1/shared.dart';
import 'package:login_screen/note1/database/note_database.dart';
import 'package:device_preview/device_preview.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferenceUtils.init();
  await NoteDatabase.init();
  AppDio.init();

  runApp(
    DevicePreview(
      builder: (context)=>MyApp(),
    ),
  );
  intiNotifications();
  FirebaseMessaging.instance.getToken()
  .then( (value) {
    print('FCM Token => $value');
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print('Message also contained a notification: ${message.notification!.title}');
      print('Message also contained a notification: ${message.notification!.body}');
      displayNotification(
        message.notification!.title!,
        message.notification!.body!,
      );
    }
  });
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (pO, pl, p2) {
        return MaterialApp(
          title: 'News App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const ELoginScreen(),
        );
      },
    );
  }
}
class SignUpApp extends StatefulWidget {
  const SignUpApp({Key? key}) : super(key: key);

  @override
  State<SignUpApp> createState() => _SignUpAppState();
}
class _SignUpAppState extends State<SignUpApp> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      requestAndroidPermission();
    }
   }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser==null
          ?const LoginScreen()
          :const HomeScreen(),
    );
  }
}

