// import 'package:camera/camera.dart';
// import 'package:chatapp/CustomUI/CameraUI.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:whats_new/CustomUI/OwnMessgaeCrad.dart';
import 'package:whats_new/CustomUI/ReplyCard.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Model/MessageModel.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:whats_new/Screens/CameraScreen.dart';
import 'package:whats_new/services/FirebaseCloudMessagingService.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class IndividualPage extends StatefulWidget {
  IndividualPage({Key? key, required this.chatModel, required this.newChat})
      : super(key: key);
  final ChatModel chatModel;
  final bool newChat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();

  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [];
  String lastMessage = '';
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late IO.Socket socket;

  String anotherUserName = '';
  String anotherUserToken = '';
  String anotherStatus = '';
  // String anotherUserName='';

  ////////////////// push notfication ////////////////////
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? token = " ";
  String anotherUserId = '';

  FcmClass fcmClass = new FcmClass();
  String chatType = '';
  String _roomId = '';
  List<Map<String, dynamic>> matchesDetails = [];
  Map<String, dynamic> match = {};
  String muImgUrl = '';
  String myName = '';

  @override
  void initState() {
    chatType = widget.newChat ? 'new' : 'old';
    _roomId = widget.newChat ? '' : widget.chatModel.id;
    fcmClass.requestPermission();

    fcmClass.loadFCM();

    fcmClass.listenFCM();

    fcmClass.getToken();

    FirebaseMessaging.instance.subscribeToTopic("Animal");
    getToken();
    // connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    listenToChanges();
    getAnotherUserDetails();
    getMyDetails();
    // connect();
  }

  listenToChanges() {
    var reference = FirebaseFirestore.instance
        .collection('usersProfile')
        .doc(widget.chatModel.anotherUserId);
    reference.snapshots().listen((querySnapshot) {
      print(querySnapshot['nowIs']);
      anotherUserId = querySnapshot.id.toString();
      if (querySnapshot['nowIs'] == 'Offline') {
        setState(() {
          anotherStatus = getTimeString(querySnapshot['lastSeen']);
        });
      } else {
        setState(() {
          anotherStatus = querySnapshot['nowIs'].toString();
        });
      }
      // querySnapshot.docChanges.forEach((change) {
      //   print(change);
      // });
    });
  }

  getAnotherUserDetails() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshoot =
        await FirebaseFirestore.instance
            .collection('usersProfile')
            .doc(widget.chatModel.anotherUserId)
            // .doc('K5GFiTSASXDXMCtE0wbn')
            .get();
    if (userSnapshoot.exists) {
      print(userSnapshoot['lastSeen']);
      if (userSnapshoot['nowIs'] == 'Offline') {
        setState(() {
          anotherUserToken = userSnapshoot['usersNotificationToken'];
          anotherStatus = getTimeString(userSnapshoot['lastSeen']);
        });
      } else {
        anotherStatus = userSnapshoot['nowIs'].toString();
      }
    } else {
      print(userSnapshoot.exists);
    }
  }

  getMyDetails() async {
    {
      DocumentSnapshot<Map<String, dynamic>> userSnapshoot =
          await FirebaseFirestore.instance
              .collection('usersProfile')
              .doc(userId)
              // .doc('K5GFiTSASXDXMCtE0wbn')
              .get();
      if (userSnapshoot.exists) {
        muImgUrl = userSnapshoot['imageUrl'];
        myName = userSnapshoot['name'];
      } else {
        print(userSnapshoot.exists);
      }
    }
  }

  getToken() async {
    String? token2 = await fcmClass.getToken();
    setState(() {
      token = token2;
    });
  }

  @override
  void dispose() {
    print('IndividualPage dispose');
    updateGroupInfo();
    super.dispose();
  }

  updateGroupInfo() {
    if (chatType == 'old') {
      if (lastMessage != widget.chatModel.currentMessage) {
        FirebaseFirestore.instance.collection("chatRooms").doc(_roomId).set({
          'anotherUserId': widget.chatModel.anotherUserId,
          'imgUrl': widget.chatModel.imgUrl,
          'isGroup': widget.chatModel.isGroup,
          'lastMessage': lastMessage,
          "lastUse": DateTime.now(),
          'roomTitle': widget.chatModel.name,
          "startIn": widget.chatModel.startIn,
          'userOne': widget.chatModel.userOne,
        }).then((_) {
          print("success!");
        });
      }
    }
  }

  void connect() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket = IO.io("http://192.168.0.106:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("signin", userId);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage("destination", msg["message"]);
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
    print(socket.connected);
  }

  void sendMessage(String message) {
    // setMessage("source", message);
    // socket.emit("message",
    //     {"message": message, "sourceId": sourceId, "targetId": targetId});

    FirebaseFirestore.instance.collection("allMessages").add({
      "message": message,
      "roomId": _roomId,
      // "awayPredict": gwNo,
      "sentIn": DateTime.now(),
      "source": userId,
    }).then((_) {
      print('object>>>>>>>>>>>>>>>>>');
      print(_.toString());
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  createNewChatRoom(String message, String sourceId, String targetId) {
    FirebaseFirestore.instance.collection("chatRooms").add({
      'anotherUserId': anotherUserId,
      'imgUrl': muImgUrl,
      'isGroup': widget.chatModel.isGroup,
      'lastMessage': lastMessage,
      "lastUse": DateTime.now(),
      'roomTitle': myName,
      "startIn": widget.chatModel.startIn,
      'userOne': widget.chatModel.anotherUserId,
    });
    FirebaseFirestore.instance.collection("chatRooms").add({
      'anotherUserId': widget.chatModel.anotherUserId,
      'imgUrl': widget.chatModel.imgUrl,
      'isGroup': widget.chatModel.isGroup,
      'lastMessage': lastMessage,
      "lastUse": DateTime.now(),
      'roomTitle': widget.chatModel.name,
      "startIn": widget.chatModel.startIn,
      'userOne': anotherUserId,
    }).then((_) {
      setState(() {
        _roomId = _.id;
        chatType = 'old';
      });
      sendMessage(message);

      print('object>>>>>>>>>>>>>>>>>');
      print(_.toString());
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        time: DateTime.now().toString().substring(10, 16));
    print(messages);

    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Color(0xFF075E54),
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),

                    customCircleAvatar(widget.chatModel.imgUrl),
                    ////////////////////////
                    // CircleAvatar(
                    //   child: SvgPicture.asset(
                    //     widget.chatModel.isGroup == true
                    //         ? "assets/groups.svg"
                    //         : "assets/person.svg",
                    //     color: Colors.white,
                    //     height: 36,
                    //     width: 36,
                    //   ),
                    //   radius: 20,
                    //   backgroundColor: Colors.blueGrey,
                    // ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatModel.name,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        anotherStatus,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ////////////////////////////
              actions: matchesDetails.length == 0
                  ?
                  //////////////// if no message selected/////////////
                  [
                      IconButton(
                          icon: Icon(Icons.videocam),
                          onPressed: () {
                            print('call him');
                          }),
                      IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () {
                            print('calllllllllllllllllllll him');
                            fcmClass.sendPushMessage(token!);
                            print(token);
                          }),
                      popUp()
                    ]
                  :
                  //////////////// if we have message selected/////////////
                  [
                      IconButton(
                          icon: Icon(Icons.reply),
                          onPressed: () {
                            print('calllllllllllllllllllll him');
                            fcmClass.sendPushMessage(token!);
                            print(token);
                          }),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteSelectedMessages(context);
                            print('delete message ');
                          }),
                      matchesDetails.length < 2
                          ? IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () {
                                copyMessages(context);
                                print('delete message ');
                              })
                          : Container(),
                      IconButton(
                          icon: Icon(Icons.forward_sharp),
                          onPressed: () {
                            print('calllllllllllllllllllll him');
                            fcmClass.sendPushMessage(token!);
                            print(token);
                          }),
                      popUp()
                    ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('allMessages')
                          .orderBy('sentIn', descending: true)
                          .where('roomId',
                              isEqualTo:
                                  //  'UBQnzsE4LLA4tuIUO7jG')

                                  _roomId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        int index = 0;
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else
                          return Expanded(
                              child: ListView(
                                  reverse: true,
                                  // scrollDirection: Axis.vertical,
                                  controller: _scrollController,
                                  children:
                                      snapshot.data!.docs.map((document2) {
                                    if (index == 0) {
                                      // print('object');
                                      lastMessage = document2['message'];
                                    }
                                    index++;
                                    if (document2['source'] ==
                                        'userProfileId') {
                                      return
                                          //  Text(
                                          //   'tesst',
                                          // );
                                          InkWell(
                                        onLongPress: () {
                                          print('looooong press on ' +
                                              document2['message']);
                                          selectMessage(document2);
                                        },
                                        child: Container(
                                          color: isSelected(document2)
                                              ? Color.fromARGB(60, 7, 94, 84)
                                              : Colors.transparent,
                                          child: OwnMessageCard(
                                            message: document2['message'],
                                            time: document2["sentIn"]
                                                    .toDate()
                                                    .hour
                                                    .toString() +
                                                ':' +
                                                document2["sentIn"]
                                                    .toDate()
                                                    .minute
                                                    .toString(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return InkWell(
                                        onLongPress: () {
                                          print('looooong press on ' +
                                              document2['message']);
                                        },
                                        child: ReplyCard(
                                          message: document2['message'],
                                          time: document2["sentIn"]
                                                  .toDate()
                                                  .hour
                                                  .toString() +
                                              ':' +
                                              document2["sentIn"]
                                                  .toDate()
                                                  .minute
                                                  .toString(),
                                        ),
                                      );
                                    }
                                  }).toList()));
                      }),
                  // Expanded(
                  //   //// height: MediaQuery.of(context).size.height - 150,

                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     controller: _scrollController,
                  //     itemCount: messages.length + 1,
                  //     itemBuilder: (context, index) {
                  //       if (index == messages.length) {
                  //         return Container(
                  //           height: 50,
                  //         );
                  //       }
                  //       if (messages[index].type == "source") {
                  //         return OwnMessageCard(
                  //           message: messages[index].message,
                  //           time: messages[index].time,
                  //         );
                  //       } else {
                  //         return ReplyCard(
                  //           message: messages[index].message,
                  //           time: messages[index].time,
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 4 - 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        if (value.length == 1)
                                          updateIsNowValue('typing...');
                                        print(value);
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          show
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          print('onPressed textfield');
                                          if (!show) {
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                          }
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.attach_file),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomSheet());
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          CameraScreen()));
                                            },
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color(0xFF128C7E),
                                  child: IconButton(
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (sendButton) {
                                        if (chatType == 'new') {
                                          createNewChatRoom(_controller.text,
                                              userId, _roomId);
                                        } else
                                          sendMessage(_controller.text);
                                        updateIsNowValue('Online');
                                        // _scrollController.animateTo(
                                        //     _scrollController
                                        //         .position.maxScrollExtent,
                                        //     duration:
                                        //         Duration(milliseconds: 300),
                                        //     curve: Curves.easeOut);

                                        _controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // show ?
                          //  emojiSelect() :
                          // Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                print('onWillPop');
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  Widget emojiSelect() {
    // return EmojiPicker(
    //     rows: 4,
    //     columns: 7,
    //     onEmojiSelected: (emoji, category) {
    //       print(emoji);
    //       setState(() {
    //         _controller.text = _controller.text + emoji.emoji;
    //       });
    //     });
    // return Text('emojiSelect');

    return EmojiPicker(
      onEmojiSelected: (emoji, category) {
        print(emoji);
        setState(() {
          _controller.text = _controller.text + emoji.index.toString();
        });
      },
      config: const Config(
          columns: 7,
          emojiSizeMax: 32.0,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          progressIndicatorColor: Colors.blue,
          backspaceColor: Colors.blue,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecentsText: 'No Recents',
          noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
          categoryIcons: CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL),
    );
  }

  String getTimeString(Timestamp data) {
    DateTime date = data.toDate();
    DateTime noww = DateTime.now();
    if (noww.difference(date).inMinutes == 0) {
      return 'last seen minutes ago';
    }
    if (noww.difference(date).inMinutes < 60) {
      return noww.difference(date).inMinutes.toString() + ' min ago';
    }

    if (noww.difference(date).inDays < 1) {
      String minutes = date.minute.toString();
      String hours = date.hour.toString();
      if (date.minute < 10) minutes = '0' + date.minute.toString();
      if (date.hour < 10) hours = '0' + date.hour.toString();
      return 'last seen today at ' + hours + ':' + minutes;
    }

    if (noww.difference(date).inDays == 1) {
      return 'last seen yeasterday';
    }

    if (noww.difference(date).inDays > 1) {
      List<String> months = [
        ' Jan ',
        ' Feb ',
        ' Mar ',
        ' Apr ',
        ' May ',
        ' June ',
        ' July ',
        ' Aug ',
        ' Sept ',
        ' Oct ',
        ' Nov ',
        ' Dec '
      ];
      String minutes = date.minute.toString();
      String hours = date.hour.toString();
      // String months = date.month.toString();
      String days = date.day.toString();
      if (date.minute < 10) minutes = '0' + date.minute.toString();
      if (date.hour < 10) hours = '0' + date.hour.toString();
      if (date.day < 10) days = '0' + date.day.toString();
      // if (date.month == 1) months = '';

      return 'last seen ' + days + months[1] + ' ' + hours + ':' + minutes;
    }

    return date.month.toString() +
        '/' +
        date.day.toString() +
        ' ' +
        date.minute.toString() +
        ':' +
        date.second.toString();
  }

  updateIsNowValue(String newValue) {
    var collection = FirebaseFirestore.instance.collection('usersProfile');
    collection
        .doc(userId)
        .update({'nowIs': newValue}) // <-- Updated data
        .then((_) => print('updateIsNowValue Success'))
        .catchError((error) => print('Failed: $error'));

    print(userId);
  }

  Widget customCircleAvatar(String imageUrl) {
    return CircleAvatar(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        radius: MediaQuery.of(context).size.height / 36,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.height / 10,
            height: MediaQuery.of(context).size.height / 10,
          ),
        ));
  }

  selectMessage(document2) {
    bool founded = false;
    match = {
      'id': document2.id,
      'message': document2['message'],
      // 'game': document2['game'],

      // 'gwNo': document2['gwNo'],
      // 'hispredict': '1',
      // 'home': document2['home'],
      // 'user': userId.toString(),
// 'documentId': doc.id.toString()});
    };
    for (var i = 0; i < matchesDetails.length; i++) {
      if (matchesDetails[i]['id'] == document2.id) {
        founded = true;
        setState(() {
          matchesDetails.removeAt(i);
        });
      }
    }
    if (!founded) {
      setState(() {
        matchesDetails.insert(0, match);
      });
    }
    print(matchesDetails);
  }

  bool isSelected(document2) {
    bool founded = false;
    for (var i = 0; i < matchesDetails.length; i++) {
      if (matchesDetails[i]['id'] == document2.id) {
        founded = true;
      }
    }
    return founded;
  }

  deleteSelectedMessages(BuildContext context) {
    for (var i = 0; i < matchesDetails.length; i++) {
      print('for print ' + matchesDetails.length.toString());
      FirebaseFirestore.instance
          .collection("allMessages")
          .doc(matchesDetails[i]['id'])
          .delete()
          .then((value) {
        print('then print ' + matchesDetails.length.toString());
        setState(() {
          matchesDetails.clear();
        });
        print('deleted...');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Deleted..."),
            backgroundColor: Color.fromARGB(69, 2, 26, 23),
            padding: const EdgeInsets.all(16.0),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.up,
            duration: Duration(milliseconds: 500)));
      });
      // matchesDetails.removeAt(i);
      if (matchesDetails.length == 0) {
        print('if print ' + matchesDetails.length.toString());
      }
    }
  }

  copyMessages(BuildContext context) async {
    ClipboardData data = ClipboardData(text: matchesDetails[0]['message']);
    await Clipboard.setData(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("message copied to clipboard..."),
        backgroundColor: Color.fromARGB(69, 2, 26, 23),
        padding: const EdgeInsets.all(16.0),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        duration: Duration(milliseconds: 500)));
  }

  Widget popUp() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (BuildContext contesxt) {
        return [
          PopupMenuItem(
            child: Text("View Contact"),
            value: "View Contact",
          ),
          PopupMenuItem(
            child: Text("Media, links, and docs"),
            value: "Media, links, and docs",
          ),
          PopupMenuItem(
            child: Text("Whatsapp Web"),
            value: "Whatsapp Web",
          ),
          PopupMenuItem(
            child: Text("Search"),
            value: "Search",
          ),
          PopupMenuItem(
            child: Text("Mute Notification"),
            value: "Mute Notification",
          ),
          PopupMenuItem(
            child: Text("Wallpaper"),
            value: "Wallpaper",
          ),
        ];
      },
    );
  }
}
