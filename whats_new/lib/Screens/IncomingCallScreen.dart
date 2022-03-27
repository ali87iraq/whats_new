import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({Key? key, required this.callId}) : super(key: key);
  final String callId;
  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  @override
  void initState() {
    player.open(
      Playlist(
          audios: [Audio("assets/ringtone.mp3"), Audio("assets/ringtone.mp3")]),
      // loopMode: LoopMode.playlist //loop the full playlist
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  listenToChanges() {
    var reference =
        FirebaseFirestore.instance.collection('myRooms').doc(widget.callId);
    reference.snapshots().listen((querySnapshot) {
      print(querySnapshot['callStatus']);
      if (querySnapshot['callStatus'] == 'ended') {
        Navigator.pop(context);
      } else {}
      // querySnapshot.docChanges.forEach((change) {
      //   print(change);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(fit: StackFit.loose, children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF132d2c),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: MediaQuery.of(context).size.height / 8 * 6,
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                color: Color(0xFF075E54),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 17,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              'End-to-End Encrypted',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      'https://img.lovepik.com/photo/50130/1366.jpg_wh860.jpg',
                    ),
                  ),
                  Text(
                    "آسم المتصل",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top: 0,
          //   bottom: 0,
          //   child: Padding(
          //     padding: const EdgeInsets.all(2.0),
          //     child: Stack(
          //       children: [
          //         Container(child: RTCVideoView(_remoteRenderer)),
          //         Positioned(
          //           top: MediaQuery.of(context).size.height / 8 * 2,
          //           bottom: 0,
          //           // bottom: MediaQuery.of(context).size.height / 8 * 1,
          //           left: 0,
          //           child: Container(
          //               width: MediaQuery.of(context).size.width / 3,
          //               child: RTCVideoView(_localRenderer, mirror: false)),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 24 * 18,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal[900],
                          radius: 30,
                          child: InkWell(
                            onTap: () {
                              // signaling.hangUp(_localRenderer);
                              // stopPeep();
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.call_end,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // playMusic();
                            // createRoom();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 35,
                            child: Icon(
                              Icons.call,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.teal[900],
                          radius: 30,
                          child: Icon(
                            Icons.message,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Text(
                      'Swipe up to accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
