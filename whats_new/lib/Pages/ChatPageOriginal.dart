import 'package:flutter/material.dart';
import 'package:whats_new/CustomUI/CustomCard.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Screens/SelectContact.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.chatmodels, required this.sourchat})
      : super(key: key);
  final List<ChatModel> chatmodels;
  final ChatModel sourchat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => SelectContact(
                        fromPage: 'chat',
                      )));
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.chatmodels.length,
        itemBuilder: (contex, index) => CustomCard(
          chatModel: widget.chatmodels[index],
          sourchat: widget.sourchat,
          diminsion: MediaQuery.of(context).size.height / 30,
        ),
      ),
    );
  }
}
