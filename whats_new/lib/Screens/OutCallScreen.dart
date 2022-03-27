// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:whats_new/webRtc_staff/signaling.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class outCallPage extends StatefulWidget {
  const outCallPage(
      {Key? key,
      required this.toUserId,
      required this.toUserName,
      required this.toUserImgUrl})
      : super(key: key);
  final String toUserId;
  final String toUserName;
  final String toUserImgUrl;
  @override
  _outCallPageState createState() => _outCallPageState();
}

class _outCallPageState extends State<outCallPage> {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  String callId = '';
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;

  TextEditingController textEditingController = TextEditingController(text: '');

  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    player.open(Audio('assets/peep.mp3'));
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    super.initState();
    setState(() {});
    createMyRoom();
    registerCallInLog();
    // audioCache = AudioCache(fixedPlayer: audioPlayer);
    // audioPlayer.onPlayerStateChanged.listen((event) {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
    player.dispose();
    // audioPlayer.release();
    // audioPlayer.dispose();
    // audioCache.clearAll();
  }

  playMusic() async {
    // audioCache.play('peep.mp3');
    player.play();
    print("call button");
  }

  stopPeep() {
    player.stop();
  }

  createRoom() async {
    roomId = await signaling.createRoom(_remoteRenderer);
    textEditingController.text = roomId!;
    setState(() {});
  }

  createMyRoom() {
    FirebaseFirestore.instance.collection("myRooms").add({
      "callerName": 'Ali h',
      "callerId": userId,
      "reciverName": widget.toUserName,
      "reciverId": widget.toUserId,
      "callerOffer": "caller offer",
      "reciverAnswer": "reciver Answer",
      "callerCandidate": "callerCandidate",
      "reciverCandidate": "reciverCandidate",
      "createdIn": DateTime.now(),
      "callStatus": "Ringing"
    }).then((_) {
      callId = _.id;
      print('object>>>>>>>>>>>>>>>>>');
      print(_.id.toString());
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  registerCallInLog() {
    FirebaseFirestore.instance.collection("callsLog").add({
      "userId": userId,
      "anotherUserId": widget.toUserId,
      "anotherUserName": widget.toUserName,
      "callDateTime": DateTime.now(),
      "callType": "out",
      "imgUrl": widget.toUserImgUrl,
      "createdIn": DateTime.now(),
      "callStatus": "Ringing"
    }).then((_) {
      callId = _.id;
      print('object>>>>>>>>>>>>>>>>>');
      print(_.id.toString());
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
            // alignment: Alignment.center,
            // textDirection: TextDirection.rtl,
            fit: StackFit.loose,
            // // overflow: Overflow.visible,
            // clipBehavior: Clip.hardEdge,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF132d2c),
                  // borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.amberAccent, width: 0.6),
                  // image: DecorationImage(
                  //     fit: BoxFit.cover,
                  //     colorFilter: new ColorFilter.mode(
                  //         Colors.black.withOpacity(0.8), BlendMode.srcATop),
                  //     image: AssetImage('assets/soccer-pattern.jpeg')),
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
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Stack(
                    children: [
                      Container(child: RTCVideoView(_remoteRenderer)),
                      Positioned(
                        top: MediaQuery.of(context).size.height / 8 * 2,
                        bottom: 0,
                        // bottom: MediaQuery.of(context).size.height / 8 * 1,
                        left: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: RTCVideoView(_localRenderer, mirror: false)),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height / 24 * 18,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      // color: Color(0xFF075E54),
                      // borderRadius: BorderRadius.circular(60),
                      // border: Border.all(color: Colors.amberAccent, width: 0.6),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // Add roomId
                        //     signaling.joinRoom(
                        //       textEditingController.text,
                        //       _remoteRenderer,
                        //     );
                        //   },
                        //   child: Text("Join room"),
                        // ),
                        // TextFormField(
                        //   controller: textEditingController,
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20,
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal[900],
                              radius: 30,
                              child: InkWell(
                                onTap: () {
                                  signaling.hangUp(_localRenderer);
                                  stopPeep();
                                  FirebaseFirestore.instance
                                      .collection("myRooms")
                                      .doc(callId)
                                      .set({
                                    "callerName": 'Ali h',
                                    "callerId": userId,
                                    "reciverName": 'Reciver',
                                    "reciverId": "Reciver id2",
                                    "callerOffer": "caller offer",
                                    "reciverAnswer": "reciver Answer",
                                    "callerCandidate": "callerCandidate",
                                    "reciverCandidate": "reciverCandidate",
                                    "createdIn": DateTime.now(),
                                    "callStatus": "ended"
                                  });
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
                                playMusic();
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
