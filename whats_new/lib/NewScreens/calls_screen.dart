import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Screens/IncomingCallScreen.dart';
import 'package:whats_new/Screens/OutCallScreen.dart';
import 'package:whats_new/Screens/SelectContact.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();
  DateTime noww = DateTime.now();
  @override
  void initState() {
    getRoomsData();
    listenToChanges();
    super.initState();
  }

  listenToChanges() {
    var reference = FirebaseFirestore.instance
        .collection('myRooms')
        .where('reciverId', isEqualTo: userId)
        .where('createdIn', isGreaterThan: noww);
    reference.snapshots().listen((querySnapshot) {
      print('querySnapshot.docs[0][createdIn].toDate()');
      print(querySnapshot.docs[0]['createdIn'].toDate());
      DateTime date = querySnapshot.docs[0]['createdIn'].toDate();
      print(querySnapshot.docs[0].id);
      // print(date);
      // print('the diffrence is = ');
      // print(noww.difference(date).inMicroseconds);
      if (querySnapshot.docs[0]['createdIn'] == 'Ringing') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => IncomingCallScreen(
                      callId: querySnapshot.docs[0].id,
                    )));
      }
      if (noww.difference(date).inMicroseconds < 0) {
        print('new call');

        // setState(() {
        //   anotherStatus = getTimeString(querySnapshot['lastSeen']);
        // });
      } else {
        print('querySnapshot.docs[0][createdIn]: ');
        print(getTimeString(querySnapshot.docs[0]["createdIn"]));
        // setState(() {
        //   anotherStatus = querySnapshot['nowIs'].toString();
        // });
      }
      querySnapshot.docChanges.forEach((change) {
        DateTime date2 = querySnapshot.docs[0]['createdIn'].toDate();
        print(date2);
        print('the diffrence2 is = ');
        print(noww.difference(date2).inMicroseconds);
        // print('docChanges: ');
        // print(change.doc['reciverId']);
        if (noww.difference(date2).inMicroseconds < 0) {
          print('new call change');
        }
        if (date2.isAfter(noww)) {
          print('new call change 2');
        }
      });
    });
  }

  getRoomsData() {
    var reference = FirebaseFirestore.instance
        .collection('myRooms')
        .where('reciverId', isEqualTo: userId);
    print(reference);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => SelectContact(
                            fromPage: 'videoCall',
                          )));
            },
            heroTag: 'video_call',
            child: Icon(
              Icons.video_call,
              size: 34,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          SelectContact(fromPage: 'callonly')));
            },
            heroTag: 'add_call',
            child: Icon(
              Icons.add_call,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('callsLog')
                  // .orderBy('callDateTime', descending: true)
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
                            'you can start new End-To-End voice call.',
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
                            // print(document2["callDateTime"]);
                            String time =
                                getTimeString(document2["callDateTime"]);

                            // ChatModel sourchat1 = ChatModel(
                            //   anotherUserId: '',
                            //   imgUrl: '',
                            //   name: document2['roomTitle'],
                            //   isGroup: document2['isGroup'],
                            //   currentMessage: document2["lastMessage"],
                            //   time: time,
                            //   icon: "person.svg",
                            //   id: document2.id.toString(),
                            //   status: '',
                            // );
                            // ChatModel chatModel1 = ChatModel(
                            //   anotherUserId: document2['anotherUserId'],
                            //   imgUrl: document2['imgUrl'],
                            //   name: document2['roomTitle'],
                            //   isGroup: document2['isGroup'],
                            //   currentMessage: document2["lastMessage"],
                            //   time: time,
                            //   startIn: document2['startIn'].toDate(),
                            //   icon: "person.svg",
                            //   id: document2.id.toString(),
                            //   userOne: document2['userOne'],
                            //   status: '',
                            // );
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => outCallPage(
                                              toUserId:
                                                  document2['anotherUserId']
                                                      .toString(),
                                              toUserName:
                                                  document2['anotherUserName'],
                                              toUserImgUrl: document2['imgUrl'],
                                            )));
                              },
                              child: callCard(
                                  document2['anotherUserName'].toString(),
                                  document2['callType'].toString() == 'out'
                                      ? Icons.call_made
                                      : document2['callType'].toString() == 'in'
                                          ? Icons.call_received
                                          : Icons.call_missed,
                                  document2['callType'].toString() == 'miss'
                                      ? Colors.red
                                      : Colors.green,
                                  time,
                                  document2['imgUrl'].toString(),
                                  MediaQuery.of(context).size.height / 30),
                            );
                            //  Text(
                            //   document2['anotherUserId'].toString(),
                            // );
                            //     CustomCard(
                            //   chatModel: chatModel1,
                            //   sourchat: sourchat1,
                            //   diminsion:
                            //       MediaQuery.of(context).size.height / 30,
                            // );
                          }).toList()));
              }),
        ],
      ),

      //////////////// old code//////////////////////////
      //  ListView(
      //   children: [
      //     InkWell(
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (contex) => outCallPage()));
      //         },
      //         child: callCard(
      //             "Muhanad H", Icons.call_made, Colors.green, "21 Feb 2022")),
      //     callCard("Ali H", Icons.call_missed, Colors.red, "20 Feb 2022"),
      //     callCard("Ahmed m", Icons.call_received, Colors.green, "19 Feb 2022"),
      //     callCard(
      //         "Muhanad H", Icons.call_received, Colors.green, "19 Feb 2022"),
      //   ],
      // ),
      ////////////////// old code /////////////////////////
    );
  }

  String getTimeString(Timestamp data) {
    DateTime date = data.toDate();
    DateTime noww = DateTime.now();
    if (noww.difference(date).inMinutes == 0) {
      return 'just now';
    }
    if (noww.difference(date).inMinutes < 60) {
      return noww.difference(date).inMinutes.toString() + ' min ago';
    }

    if (noww.difference(date).inDays < 1) {
      String minutes = date.minute.toString();
      String hours = date.hour.toString();
      if (date.minute < 10) minutes = '0' + date.minute.toString();
      if (date.hour < 10) hours = '0' + date.hour.toString();
      return 'today at ' + hours + ':' + minutes;
    }

    if (noww.difference(date).inDays == 1) {
      String minutes = date.minute.toString();
      String hours = date.hour.toString();
      if (date.minute < 10) minutes = '0' + date.minute.toString();
      if (date.hour < 10) hours = '0' + date.hour.toString();
      return 'yeasterday  at ' + hours + ':' + minutes;
      ;
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
        date.minute.toString() +
        ':' +
        date.second.toString();
  }

  Widget customCircleAvatar(String imageUrl, double diminsion) {
    return CircleAvatar(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        radius: diminsion,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: diminsion * 2,
            height: diminsion * 2,
          ),
        ));
  }

  Widget callCard(String name, IconData iconData, Color iconColor, String time,
      String imgUrl, double diminsion) {
    return ListTile(
      leading: customCircleAvatar(imgUrl, diminsion),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 20,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            time,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
      trailing: InkWell(
        onTap: () {
          print(" call $name");
        },
        child: Icon(
          Icons.call,
          size: 28,
          color: Colors.teal,
        ),
      ),
    );
  }
}
