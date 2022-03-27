import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Screens/IndividualPage.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key,
      required this.chatModel,
      required this.sourchat,
      required this.diminsion})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;
  final double diminsion;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            leading: customCircleAvatar(chatModel.imgUrl),

            //  CircleAvatar(
            //   radius: 30,
            //   child: SvgPicture.asset(
            //     chatModel.isGroup == true
            //         ? "assets/groups.svg"
            //         : "assets/person.svg",
            //     color: Colors.white,
            //     height: 36,
            //     width: 36,
            //   ),
            //   backgroundColor: Colors.blueGrey,
            // ),
            title: Text(
              chatModel.name,
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
                  chatModel.currentMessage.toString(),
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget customCircleAvatar(String imageUrl) {
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
}
