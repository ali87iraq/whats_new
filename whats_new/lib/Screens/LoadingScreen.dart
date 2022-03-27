import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whats_new/Screens/Homescreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool loading = true;
  late Timer timer;
  int seconds = 0;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds++;
            if (seconds > 4) {
              setState(() {
                loading = false;
              });
              print(seconds);
            }
            if (seconds > 5) {
              seconds = 0;
              timer.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => Homescreen()));
            }
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        title: Text(widget.title),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.logout),
        //       onPressed: () {
        //         print('object');
        //       })
        // ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF075E54),
                    ),
                  ],
                )
              : Center(child: Text('Sorry... something went wrong ')),
        ],
      ),
    );
  }
}
