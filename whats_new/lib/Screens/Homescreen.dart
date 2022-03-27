import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/NewScreens/calls_screen.dart';
import 'package:whats_new/NewScreens/ompleteProfileDetails.dart';
import 'package:whats_new/NewScreens/settingScreen.dart';
// import 'package:whats_new/Pages/CameraPage.dart';
import 'package:whats_new/Pages/ChatPage.dart';
import 'package:whats_new/Pages/StatusPage.dart';
import 'package:whats_new/Screens/LoadingScreen.dart';
import 'package:whats_new/services/Auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../services/FirebaseCloudMessagingService.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  AuthClass authClass = AuthClass();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();
  late QueryDocumentSnapshot<Map<dynamic, dynamic>> match;
  String _hisPromo = '';
  String _parentPromo = '';
  FcmClass fcmClass = new FcmClass();
//  AuthClass authClass = AuthClass();

  @override
  void initState() {
    getUserprofileDetails();
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  getUserprofileDetails() async {
    String? token2 = await fcmClass.getToken();
    print('My token is: ' + token2.toString());
    DocumentSnapshot<Map<String, dynamic>> userSnapshoot =
        await FirebaseFirestore.instance
            .collection('usersProfile')
            .doc(userId)
            // .where('userId', isEqualTo: 'vL8D0bys7fQ3PkKj64RaWbDjFaj2')
            // .orderBy('startIn')
            // .limit(1)
            .get();
    if (userSnapshoot.exists) {
      // userSnapshoot.docs

    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (builder) => CompliteProfileDetails(
                    isFirestTime: true,
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        title: Text("Whatsapp"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('Icons.search pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => LoadingScreen(
                              title: 'Contacts',
                            )));
              }),
          PopupMenuButton<String>(
            onSelected: (value) {
              goTo(value);
              print(value);
            },
            itemBuilder: (BuildContext contesxt) {
              return [
                PopupMenuItem(
                  child: Text("New group"),
                  value: "New group",
                ),
                PopupMenuItem(
                  child: Text("New broadcast"),
                  value: "New broadcast",
                ),
                PopupMenuItem(
                  child: Text("Whatsapp Web"),
                  value: "Whatsapp Web",
                ),
                PopupMenuItem(
                  child: Text("Starred messages"),
                  value: "Starred messages",
                ),
                PopupMenuItem(
                  child: Text("Settings"),
                  value: "Settings",
                ),
              ];
            },
          )
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: [
            // Tab(
            //   icon: Icon(Icons.camera_alt),
            // ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          // CameraPage(),
          ChatPage(),
          StatusPage(),
          CallScreen()
        ],
      ),
    );
  }

  goTo(String value) {
    if (value == 'Settings') {
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => SettingScreen()));
    }
  }
}
