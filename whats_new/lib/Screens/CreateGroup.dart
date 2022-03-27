import 'package:whats_new/CustomUI/AvtarCard.dart';
// import 'package:whats_new/CustomUI/ButtonCard.dart';
import 'package:whats_new/CustomUI/ContactCard.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ChatModel> contacts = [
    ChatModel(
        name: "Dev Stack",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "A full stack developer",
        id: '1'),
    ChatModel(
        name: "Balram",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Flutter Developer...........",
        id: '1'),
    ChatModel(
        name: "Saket",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Web developer...",
        id: '1'),
    ChatModel(
        name: "Bhanu Dev",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "App developer....",
        id: '1'),
    ChatModel(
        name: "Collins",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Raect developer..",
        id: '1'),
    ChatModel(
        name: "Kishor",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Full Stack Web",
        id: '1'),
    ChatModel(
        name: "Testing1",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Example work",
        id: '1'),
    ChatModel(
        name: "Testing2",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Sharing is caring",
        id: '1'),
    ChatModel(
        name: "Divyanshu",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: ".....",
        id: '1'),
    ChatModel(
        name: "Helper",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "Love you Mom Dad",
        id: '1'),
    ChatModel(
        name: "Tester",
        imgUrl: '',
        anotherUserId: "anotherUserId",
        status: "I find the bugs",
        id: '1'),
  ];
  List<ChatModel> groupmember = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Group",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Add participants",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {}),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF128C7E),
            onPressed: () {},
            child: Icon(Icons.arrow_forward)),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: contacts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: groupmember.length > 0 ? 90 : 10,
                    );
                  }
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (contacts[index - 1].select == true) {
                          groupmember.remove(contacts[index - 1]);
                          contacts[index - 1].select = false;
                        } else {
                          groupmember.add(contacts[index - 1]);
                          contacts[index - 1].select = true;
                        }
                      });
                    },
                    child: ContactCard(
                      contact: contacts[index - 1],
                    ),
                  );
                }),
            groupmember.length > 0
                ? Align(
                    child: Column(
                      children: [
                        Container(
                          height: 75,
                          color: Colors.white,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: contacts.length,
                              itemBuilder: (context, index) {
                                if (contacts[index].select == true)
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        groupmember.remove(contacts[index]);
                                        contacts[index].select = false;
                                      });
                                    },
                                    child: AvatarCard(
                                      chatModel: contacts[index],
                                    ),
                                  );
                                return Container();
                              }),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                    alignment: Alignment.topCenter,
                  )
                : Container(),
          ],
        ));
  }
}
