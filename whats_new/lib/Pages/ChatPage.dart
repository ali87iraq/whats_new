import 'package:flutter/material.dart';
import 'package:whats_new/CustomUI/CustomCard.dart';
import 'package:whats_new/CustomUI/CustomCardTry2.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Screens/SelectContact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../NewScreens/ompleteProfileDetails.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  void initState() {
    print('congrat user id is ========>');
    print(userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => SelectContact(fromPage: 'chat')));
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatRoomsUsersRelation')
                  .orderBy('lastUse', descending: true)
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.data?.size == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: Container(
                      // height: 60,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 253, 244, 190),
                        // rgba(255,244,198,255)
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'you can start new End-To-End conversation.',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else
                  return Expanded(
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs.map((document2) {
                            String time = getTimeString(document2["lastUse"]);
                            ChatModel sourchat1 = ChatModel(
                              anotherUserId: '',
                              imgUrl: '',
                              name: document2['roomName'],
                              isGroup: document2['isGroup'],
                              //currentMessage: document2["lastMessage"],
                              time: time,
                              icon: "person.svg",
                              id: document2.id.toString(),
                              status: '',
                            );
                            ChatModel chatModel1 = ChatModel(
                              anotherUserId: 'xai0RHDPWjYit6kmOo9bAfUUjsf2',
                              imgUrl: '',
                              name: document2['roomName'],
                              isGroup: document2['isGroup'],
                              //currentMessage: document2["lastMessage"],
                              time: time,
                              startIn: document2['lastUse'].toDate(),
                              icon: "person.svg",
                              id: document2.id.toString(),
                              userOne: 'xai0RHDPWjYit6kmOo9bAfUUjsf2',
                              status: '',
                            );
                            return
                                //  Text(
                                //   document2['roomName'].toString(),
                                // );
                                CustomCard1(
                              diminsion:
                                  MediaQuery.of(context).size.height / 30,
                              roomId: document2['roomId'],
                              userId: userId,
                            );
                          }).toList()));
              }),
        ],
      ),

      //     ListView.builder(
      //   itemCount: widget.chatmodels.length,
      //   itemBuilder: (contex, index) => CustomCard(
      //     chatModel: widget.chatmodels[index],
      //     sourchat: widget.sourchat,
      //   ),
      // ),
    );
  }

  // String getTimeString(Timestamp data) {
  //   DateTime date = data.toDate();
  //   DateTime noww = DateTime.now();
  //   if (noww.difference(date).inMinutes == 0) {
  //     return 'now';
  //   }
  //   if (noww.difference(date).inMinutes < 60) {
  //     return noww.difference(date).inMinutes.toString() + ' min ago';
  //   }

  //   if (noww.difference(date).inDays < 1) {
  //     return date.minute.toString() + ':' + date.second.toString();
  //   }

  //   if (noww.difference(date).inDays == 1) {
  //     return 'yeasterday';
  //   }

  //   return date.month.toString() +
  //       '/' +
  //       date.day.toString() +
  //       ' ' +
  //       date.minute.toString() +
  //       ':' +
  //       date.second.toString();
  // }

  String getTimeString(Timestamp data) {
    DateTime date = data.toDate();
    DateTime noww = DateTime.now();
    if (noww.difference(date).inMinutes == 0) {
      return 'minutes ago';
    }
    if (noww.difference(date).inMinutes < 60) {
      return noww.difference(date).inMinutes.toString() + ' min ago';
    }

    if (noww.difference(date).inDays < 1) {
      String minutes = date.minute.toString();
      String hours = date.hour.toString();
      if (date.minute < 10) minutes = '0' + date.minute.toString();
      if (date.hour < 10) hours = '0' + date.hour.toString();
      return 'today, ' + hours + ':' + minutes;
    }

    if (noww.difference(date).inDays == 1) {
      return 'yeasterday';
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

      return days + months[1] + ' ' + hours + ':' + minutes;
    }

    return date.month.toString() +
        '/' +
        date.day.toString() +
        ' ' +
        date.hour.toString() +
        ':' +
        date.minute.toString();
  }
}
