// import 'package:whats_new/CustomUI/ButtonCard.dart';

// import 'package:flutter/material.dart';
// import 'package:whats_new/Model/ChatModel.dart';
// import 'package:whats_new/Screens/Homescreen.dart';

// class LoginScreen extends StatefulWidget {
//   LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   late ChatModel sourceChat;
//   List<ChatModel> chatmodels = [
//     ChatModel(
//       name: "Muhannad H",
//       isGroup: false,
//       currentMessage: "Hi Everyone",
//       time: "4:00",
//       icon: "person.svg",
//       id: 1,
//       status: '',
//     ),
//     ChatModel(
//       name: "Ahmed M",
//       isGroup: false,
//       currentMessage: "Hi Kishor",
//       time: "13:00",
//       icon: "person.svg",
//       id: 2,
//       status: '',
//     ),
//     ChatModel(
//       name: "Ali h",
//       isGroup: false,
//       currentMessage: "Hi Dev Stack",
//       time: "8:00",
//       icon: "person.svg",
//       id: 3,
//       status: '',
//     ),
//     ChatModel(
//       name: "Balram Rathore",
//       isGroup: false,
//       currentMessage: "Hi Dev Stack",
//       time: "2:00",
//       icon: "person.svg",
//       id: 4,
//       status: '',
//     ),
//     ChatModel(
//       name: "M21 it groub",
//       isGroup: true,
//       currentMessage: "New NodejS Post",
//       time: "2:00",
//       icon: "group.svg",
//       id: 5,
//       status: '',
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//           itemCount: chatmodels.length,
//           itemBuilder: (contex, index) => InkWell(
//                 onTap: () {
//                   sourceChat = chatmodels.removeAt(index);
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (builder) => Homescreen(
//                                 chatmodels: chatmodels,
//                                 sourchat: sourceChat,
//                               )));
//                 },
//                 child: Column(
//                   children: [
//                     ButtonCard(
//                       name: chatmodels[index].name.toString(),
//                       icon: chatmodels[index].isGroup == false
//                           ? Icons.person
//                           : Icons.grid_view,
//                     ),
//                   ],
//                 ),
//               )),
//     );
//   }
// }
