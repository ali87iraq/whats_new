import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Screens/IndividualPage.dart';

class CustomCard1 extends StatefulWidget {
  const CustomCard1({
    Key? key,
    required this.diminsion,
    required this.roomId,
    required this.userId,
  }) : super(key: key);
  final double diminsion;
  final String roomId;
  final String userId;

  @override
  State<CustomCard1> createState() => _CustomCard1State();
}

class _CustomCard1State extends State<CustomCard1> {
  bool iHaveRoomData = false;
  String latestMesag = '';
  String imgUrl1 = '';
  String roomTitle = '';
  var timeToChatModel;
  String time = '';

  getChatRoomDetails() async {
    DocumentSnapshot<Map<String, dynamic>> roomSnapshoot =
        await FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(widget.roomId)
            .get();
    if (roomSnapshoot.exists) {
      String tempUser1Name = '';
      String tempRoomTitle = '';
      if (roomSnapshoot['userOne'] == widget.userId) {
        tempUser1Name = roomSnapshoot['userOneName'];
        tempRoomTitle = roomSnapshoot['anotherUserName'];
      } else {
        tempUser1Name = roomSnapshoot['anotherUserName'];
        tempRoomTitle = roomSnapshoot['userOneName'];
      }
      setState(() {
        latestMesag = roomSnapshoot['lastMessage'].toString();
        imgUrl1 = roomSnapshoot['imgUrl'];
        iHaveRoomData = true;
        roomTitle = tempRoomTitle;
        time = getTimeString(roomSnapshoot["lastUse"]);
        timeToChatModel = roomSnapshoot['lastUse'].toDate();
      });
    } else {
      setState(() {
        iHaveRoomData = false;
      });
    }
  }

  @override
  void initState() {
    getChatRoomDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatModel chatModel = ChatModel(
      anotherUserId: 'xai0RHDPWjYit6kmOo9bAfUUjsf2',
      imgUrl: imgUrl1,
      name: roomTitle,
      isGroup: false,
      //currentMessage: document2["lastMessage"],
      time: time,
      startIn: timeToChatModel,
      icon: "person.svg",
      id: widget.roomId,
      userOne: 'xai0RHDPWjYit6kmOo9bAfUUjsf2',
      status: '',
    );
    return iHaveRoomData
        ? InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => IndividualPage(
                            chatModel: chatModel,
                            // sourchat: sourchat,
                            newChat: false,
                          )));
            },
            child: Column(
              children: [
                ListTile(
                  leading: customCircleAvatar(imgUrl1),
                  title: Text(
                    roomTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.done_all),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        latestMesag,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(time),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 80),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget customCircleAvatar(String imageUrl) {
    return CircleAvatar(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        radius: widget.diminsion,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: widget.diminsion * 2,
            height: widget.diminsion * 2,
          ),
        ));
  }

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
