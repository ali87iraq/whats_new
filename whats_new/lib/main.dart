import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:whats_new/NewScreens/LandingScreen.dart';
// import 'package:whats_new/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
import 'package:whats_new/services/Auth_service.dart';

import 'Screens/CameraScreen.dart';
import 'Screens/Homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = LandingScreen();

  String userId = '';

  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();

    if (firebase_auth.FirebaseAuth.instance.currentUser?.uid == null) {
// not logged

    } else {
      userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();
      checkLogin();
// logged
    }
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        // currentPage = HomePage();
        currentPage = Homescreen();
      });
    }

    final String userId =
        firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();
    print(currentPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "OpenSans",
          primaryColor: Color(0xFF075E54),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF128C7E))),
      home: currentPage,
    );
  }
}
