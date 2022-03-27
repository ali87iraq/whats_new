import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:whats_new/Model/ChatModel.dart';
import 'package:whats_new/Screens/Homescreen.dart';
import 'package:whats_new/services/Auth_service.dart';
// import 'package:whats_new/Screens/LoginScreen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.number, required this.countryCode})
      : super(key: key);
  final String number;
  final String countryCode;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  late ChatModel sourceChat;
  List<ChatModel> chatmodels = [
    ChatModel(
      name: "Muhannad H",
      imgUrl: '',
      anotherUserId: "anotherUserId",
      isGroup: false,
      currentMessage: "Hi Everyone",
      time: "4:00",
      icon: "person.svg",
      id: '1',
      status: '',
    ),
    ChatModel(
      name: "Ahmed M",
      imgUrl: '',
      anotherUserId: "anotherUserId",
      isGroup: false,
      currentMessage: "Hi Kishor",
      time: "13:00",
      icon: "person.svg",
      id: '2',
      status: '',
    ),
    ChatModel(
      name: "Ali h",
      imgUrl: '',
      anotherUserId: "anotherUserId",
      isGroup: false,
      currentMessage: "Hi Dev Stack",
      time: "8:00",
      icon: "person.svg",
      id: '3',
      status: '',
    ),
    ChatModel(
      name: "Balram Rathore",
      imgUrl: '',
      anotherUserId: "anotherUserId",
      isGroup: false,
      currentMessage: "Hi Dev Stack",
      time: "2:00",
      icon: "person.svg",
      id: '4',
      status: '',
    ),
    ChatModel(
      name: "M21 it groub",
      imgUrl: '',
      anotherUserId: "anotherUserId",
      isGroup: true,
      currentMessage: "New NodejS Post",
      time: "2:00",
      icon: "group.svg",
      id: '5',
      status: '',
    ),
  ];

  AuthClass authClass = AuthClass();
  String verficationIdIs = '';
  bool loading = true;
  @override
  void initState() {
    authClass.verifyPhoneNumber(
        widget.countryCode + ' ' + widget.number, context, setData);
    super.initState();
  }

  setData(String verfId) {
    verficationIdIs = verfId;
    setState(() {
      loading = false;
    });
    print('verficationIdIs =======>');
    print(verficationIdIs);
    print('loadig =======>');
    print(loading);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'verfy ' + widget.countryCode + ' ' + widget.number,
                style: TextStyle(color: Colors.teal[800], fontSize: 19),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  ],
                )))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'verfy ' + widget.countryCode + ' ' + widget.number,
                style: TextStyle(color: Colors.teal[800], fontSize: 19),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'We have sent an SMS with a code to ',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                          TextSpan(
                              text: widget.countryCode +
                                  ' ' +
                                  widget.number +
                                  '. ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Wrong number?',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.cyan[800])),
                        ])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 25,
                    style: TextStyle(fontSize: 15),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onChanged: (e) {
                      print("OTP CHANGE IS =======>" + e);
                    },
                    onCompleted: (pin) {
                      // firebase auth code

                      print("Completed: " + pin);
                      sourceChat = chatmodels.removeAt(0);

                      authClass.signInwithPhoneNumber(
                          verficationIdIs, pin, context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Homescreen()));
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (builder) => LoginScreen()),
                      //     (route) => false);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Enter 6-digit code',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  bottomButton('Resend SMS', Icons.message),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                  bottomButton('Call me', Icons.call),
                ],
              ),
            ),
          );
  }

  Widget bottomButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.teal,
            size: 25,
          ),
          SizedBox(
            width: 30,
          ),
          Text(text,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
