import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whats_new/Screens/LoadingScreen.dart';
import 'package:whats_new/services/Auth_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        title: Text("Settings"),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.logout),
        //       onPressed: () {
        //         print('object');
        //       })
        // ],
      ),
      body: Column(
        children: [
          profileCard('Your profile user name', 'Your status text'),
          Expanded(
            child: ListView(children: <Widget>[
              InkWell(
                onTap: () {
                  print('Account');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => LoadingScreen(
                                title: 'Account',
                              )));
                },
                splashColor: Color(0xFF075E54),
                child: ListTile(
                  leading: Icon(
                    Icons.fullscreen,
                    color: Color(0xFF075E54),
                  ),
                  title: Text("Account"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  print('Chats');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => LoadingScreen(
                                title: 'Chats',
                              )));
                },
                splashColor: Color(0xFF075E54),
                child: ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Color(0xFF075E54),
                  ),
                  title: Text("Chats"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  print('Notifications');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => LoadingScreen(
                                title: 'Notifications',
                              )));
                },
                splashColor: Color(0xFF075E54),
                child: ListTile(
                  leading: Icon(
                    Icons.add_alert_rounded,
                    color: Color(0xFF075E54),
                  ),
                  title: Text("Notifications"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  print('Data usage');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => LoadingScreen(
                                title: 'Data usage',
                              )));
                },
                splashColor: Color(0xFF075E54),
                child: ListTile(
                  leading: Icon(
                    Icons.data_saver_off,
                    color: Color(0xFF075E54),
                  ),
                  title: Text("Data usage"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  print('About and help');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => LoadingScreen(
                                title: 'About and help',
                              )));
                },
                splashColor: Color(0xFF075E54),
                child: ListTile(
                  leading: Icon(
                    Icons.contact_support_rounded,
                    color: Color(0xFF075E54),
                  ),
                  title: Text("About and help"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  print('Contacts');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => LoadingScreen(
                                title: 'Contacts',
                              )));
                },
                splashColor: Color(0xFF075E54),
                child: ListTile(
                  leading: Icon(
                    Icons.contacts_sharp,
                    color: Color(0xFF075E54),
                  ),
                  title: Text("Contacts"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  profileCard(String profileUserName, statusText) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          CircleAvatar(radius: MediaQuery.of(context).size.height / 11),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(profileUserName,
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(statusText,
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
