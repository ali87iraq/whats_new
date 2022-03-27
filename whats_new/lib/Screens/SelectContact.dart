import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_new/CustomUI/ButtonCard.dart';
import 'package:whats_new/CustomUI/ContactCard.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:whats_new/NewScreens/calls_screen.dart';
import 'package:whats_new/Screens/CreateGroup.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:whats_new/Screens/IndividualPage.dart';
import 'package:whats_new/Screens/OutCallScreen.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key? key, required this.fromPage}) : super(key: key);
  final String fromPage;
  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  int contactsCounter = 0;
  bool loading = false;
  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();
  String myName = '';
  String SearchErrorMessage = 'رقم هاتف المنافس يبدآ ب0 ويتكون من 11 رقم';
  String opponentNo = "";
  bool iSelectOpponent = false;
  bool opponentAreaFlag = false;
  List<String> challengedUser = [];
  List<ChatModel> contacts = [
    // ChatModel(
    //     name: "Dev Stack",
    //     imgUrl: '',
    //     anotherUserId: "anotherUserId",
    //     status: "A full stack developer",
    //     id: '1'),
    // ChatModel(
    //     name: "Balram",
    //     imgUrl: '',
    //     anotherUserId: "anotherUserId",
    //     status: "Flutter Developer...........",
    //     id: '1'),
    // ChatModel(
    //     name: "Saket",
    //     imgUrl: '',
    //     anotherUserId: "anotherUserId",
    //     status: "Web developer...",
    //     id: '1'),
    // ChatModel(
    //     name: "Bhanu Dev",
    //     imgUrl: '',
    //     anotherUserId: "anotherUserId",
    //     status: "App developer....",
    //     id: '1'),
    // ChatModel(
    //     name: "Collins",
    //     imgUrl: '',
    //     anotherUserId: "anotherUserId",
    //     status: "Raect developer..",
    //     id: '1'),
    // ChatModel(
    //     name: "Kishor",
    //     imgUrl: '',
    //     anotherUserId: "anotherUserId",
    //     status: "Full Stack Web",
    //     id: '1'),
  ];
  @override
  void initState() {
    getAllContacts();
    getUserprofileDetails();
    super.initState();
  }

  @override
  void dispose() {
    opponentNo = "";
    SearchErrorMessage = 'رقم هاتف المنافس يبدآ ب0 ويتكون من 11 رقم';
    opponentAreaFlag = false;
    challengedUser = [];
    super.dispose();
  }

  getUserprofileDetails() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshoot =
        await FirebaseFirestore.instance
            .collection('usersProfile')
            .doc(userId)
            // .where('userId', isEqualTo: 'vL8D0bys7fQ3PkKj64RaWbDjFaj2')
            // .orderBy('startIn')
            // .limit(1)
            .get();
    if (userSnapshoot.exists) {
      myName = userSnapshoot['name'];
      // userSnapshoot.docs[0];

    } else {}
  }

  getAllContacts() async {
    List<ChatModel> temp = [];
    setState(() {
      loading = true;
    });
    contacts.clear();
    await FirebaseFirestore.instance
        .collection('usersContactsList')
        // .where('user', isEqualTo: userId.toString())
        .where('userId', isEqualTo: userId)
        .snapshots()
        .forEach((element) {
      element.docs.forEach((doc) {
        print(doc.data()['contactName']);
        setState(() {
          contacts.add(ChatModel(
            name: doc.data()['contactName'],
            imgUrl: doc.data()['imgUrl'],
            anotherUserId: doc.data()["contactId"],
            status: doc.data()["status"],
            id: doc.id.toString(),
          ));
        });

        // setState(() {
        // matchesDetails.insert(0, {
        //   'away': doc.data()['away'],
        //   'game': doc.id.toString(),
        //   'gwNo': doc.data()['gwNo'],
        //   'hispredict': 0,
        //   'home': doc.data()['home'],
        //   'user': userId.toString(),
        //   // 'documentId': doc.id.toString()});
        // });
        // });
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                contacts.length.toString() + ' contacts',
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
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Invite a friend"),
                    value: "Invite a friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              },
            ),
          ],
        ),
        body: !loading
            ?
            /////////////////////if loading
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            /////////////////////  if every thing loaded
            : ListView.builder(
                itemCount: contacts.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      onTap: () {
                        newGroupEvent();
                      },
                      child: ButtonCard(
                        icon: Icons.group,
                        name: "New group",
                      ),
                    );
                  } else if (index == 1) {
                    return InkWell(
                      onTap: () {
                        newContactEvent();
                      },
                      child: ButtonCard(
                        icon: Icons.person_add,
                        name: "New contact",
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      contactTap(
                          contacts[index - 2].anotherUserId.toString(),
                          contacts[index - 2].name.toString(),
                          contacts[index - 2].imgUrl.toString());
                    },
                    child: ContactCard(
                      contact: contacts[index - 2],
                    ),
                  );
                }));
  }

  contactTap(String toUserId, String toUser, String toImgUrl) {
    if (widget.fromPage == 'callonly') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => outCallPage(
                    toUserId: toUserId,
                    toUserName: toUser,
                    toUserImgUrl: toImgUrl,
                  )));
    }
    if (widget.fromPage == 'chat') {
      ChatModel chatModel1 = ChatModel(
        anotherUserId: toUserId,
        imgUrl: toImgUrl,
        name: toUser,
        isGroup: false,
        currentMessage: ' ',
        time: DateTime.now().toString(),
        startIn: DateTime.now(),
        icon: "person.svg",
        id: toUserId,
        userOne: userId,
        status: '',
      );
      ChatModel sourchat1 = ChatModel(
        anotherUserId: toUserId,
        imgUrl: toImgUrl,
        name: toUser,
        isGroup: false,
        currentMessage: ' ',
        time: DateTime.now().toString(),
        startIn: DateTime.now(),
        icon: "person.svg",
        id: userId,
        userOne: myName,
        status: '',
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => IndividualPage(
                    chatModel: chatModel1,
                    // sourchat: sourchat1,
                    newChat: true,
                  )));
    }
    print('contactTap');
  }

  newGroupEvent() {
    print('newGroupEvent');
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => CreateGroup()));
  }

  newContactEvent() {
    print('newContactEvent');
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return opponentModal(context);
        });
  }

  Widget opponentModal(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: EdgeInsets.only(
              top: 45,
              bottom: 8,
              left: 10,
              right: 10,
            ),
            // margin: EdgeInsets.only(top: 5),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(66, 163, 161, 161),
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                ////////////     phone No textField    ///
                TextField(
                  maxLength: 11,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      isDense: true, // important line
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      suffixIcon: Icon(Icons.contact_phone,
                          size: 30, color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: '  Search Phone No. '),
                  // 'title',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                  onChanged: (_) {
                    print('onEditingComplete');
                    if (_.isNotEmpty) {
                      setState(() {
                        opponentNo = _;
                      });
                    }
                  },
                  onEditingComplete: () {
                    print('onEditingComplete');
                  },
                  onSubmitted: (newString) {
                    print('onSubmitted');
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                (opponentNo.isNotEmpty)
                    ? (opponentNo[0] == '0' && opponentNo.length == 11)
                        ? opponentArea(context)
                        : Container(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(SearchErrorMessage),
                            ),
                          )
                    : Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(SearchErrorMessage),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: TextButton(
                    //     onPressed: () {
                    //       Navigator.pop(context, true);
                    //     },
                    //     child: Text(
                    //       'Cancel',
                    //       style: TextStyle(
                    //         color: Colors.redAccent,
                    //         fontFamily: 'bein',
                    //         fontSize: 16.0,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3 * 2,
                        height: 50,
                        child: Card(
                            margin: EdgeInsets.all(0),
                            elevation: 8,
                            color: Colors.greenAccent[700],
                            child: Center(
                              child: Text(
                                "cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            )),
                      ),
                    )

                    // Align(
                    //   alignment: Alignment.bottomLeft,
                    //   child: TextButton(
                    //     onPressed: () {
                    //       // if (suggestedChallengedUser.length != 0) {}

                    //       Navigator.pop(context, true);
                    //       // To close the dialog
                    //     },
                    //     child: Text(
                    //       'اخـتيار المنافـس',
                    //       style: TextStyle(
                    //         color: Colors.green,
                    //         fontFamily: 'bein',
                    //         fontSize: 16.0,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ));
    });
  }

  Widget opponentArea(BuildContext context) {
    if (opponentNo.isNotEmpty) {
      String searchFor = '+964' + opponentNo.substring(1);
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usersProfile')
              .where('phoneNo', isEqualTo: searchFor)
              // .where('gwNo', isEqualTo: 'QPEcAbaZS9672UtgeYqv')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Expanded(
                child: ListView(
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs.map((document2) {
                      print(document2);
                      return Container(
                          child: opponentCard(
                              context,
                              document2['name'].toString(),
                              document2['phoneNo'].toString(),
                              document2['imageUrl'].toString(),
                              document2.reference.id.toString(),
                              document2['status'].toString()));
                    }).toList()));
          });
    } else {
      return Container();
    }
  }

  Widget opponentCard(BuildContext context, String userName, String userPhoneNo,
      String imgUrl, String userId2, String userStuts) {
    return InkWell(
      onTap: () {
        iSelectOpponent = true;

        FirebaseFirestore.instance.collection("usersContactsList").add({
          "contactId": userId2,
          'contactName': userName,
          'imgUrl': imgUrl,
          'status': userStuts,
          'userId': userId,
        }).then((_) {
          print('object>>>>>>>>>>>>>>>>>');
          print(_.toString());
          // To close the dialog
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => CallScreen()));
        });

        // challengedUser.addAll([userName, userPhoneNo, userId, imgUrl]);
        // Navigator.pop(context, true);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF075E54), width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 170, 169, 169),
                        blurRadius: 3.0,
                        offset: Offset(2.0, 2.0))
                  ]),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              opponentNo,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              userStuts,
                              style: TextStyle(
                                fontFamily: 'bein',
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
