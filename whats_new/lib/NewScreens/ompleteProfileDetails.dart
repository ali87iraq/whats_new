import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../Screens/Homescreen.dart';

class CompliteProfileDetails extends StatefulWidget {
  const CompliteProfileDetails(
      {Key? key, required this.isFirestTime, this.phoneNo})
      : super(key: key);
  final bool isFirestTime;
  final String? phoneNo;

  @override
  _CompliteProfileDetailsState createState() => _CompliteProfileDetailsState();
}

class _CompliteProfileDetailsState extends State<CompliteProfileDetails> {
  TextEditingController _accountName = TextEditingController();
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/whattsnew-c23fb.appspot.com/o/images%20(1).jpeg?alt=media&token=f338fbd8-d4a7-4b47-a3aa-df77cff2805d';
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool loadingFlag = false;
  final String userId =
      firebase_auth.FirebaseAuth.instance.currentUser!.uid.toString();
  String hisPhone =
      firebase_auth.FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  File? _photo;
  final image_picker.ImagePicker _picker = image_picker.ImagePicker();
  DateTime myDate = DateTime.now();
  String userName = '';
  String userStatus = 'Available';

  Future imgFromGallery() async {
    final pickedFile =
        await _picker.pickImage(source: image_picker.ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
        print('uploadFile()');
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: image_picker.ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        print('uploadFile()');
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    setState(() {
      loadingFlag = true;
    });
    if (_photo == null) return;
    final fileName = path.basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!).then((p0) {
        print('uploaded');
        // print(p0);
      }).onError((error, stackTrace) {
        print(error);
      });
      print(ref.fullPath);
      String tempUrl = await ref.getDownloadURL();
      setState(() {
        imageUrl = tempUrl;
      });

      print(imageUrl);
      print(ref);
    } catch (e) {
      print('error occured');
    }
    setState(() {
      loadingFlag = false;
    });
    updateProfile();
  }

  updateProfile() async {
    FirebaseFirestore.instance.collection("usersProfile").doc(userId).set({
      "accountType": 1,
      "lastUpdate": myDate,
      "status": userStatus,
      "name": userName,
      "phoneNo": hisPhone,
      // "email": userEmailIdentifier,
      "imageUrl": imageUrl,
      'nowIs': 'Online',
      'lastSeen': DateTime.now(),
      'usersNotificationToken': 'token'
    }).then((_) {
      print("success!");
      // bioEditMod = false;
      // getUserDetails();
      setState() {
        loadingFlag = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text("Profile"),
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  updateProfile();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => Homescreen()),
                      (route) => false);
                })
          ],
        ),
        body: Container(
          color: Colors.grey[300],
          child: Column(
            children: [
              profileImage(imageUrl),
              textItem(" اسم المستخدم", _accountName, false),
              SizedBox(
                height: 5,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "This is not your username or pin. this name will be visible to your WhatsApp contacts",
                    maxLines: 3,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Phone and status',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF075E54),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              statusWidget(userStatus),
              phoneWidget(hisPhone),
            ],
          ),
        ));
  }

  String drawPhoneNo(String no) {
    return '';
  }

  Widget profileImage(String imgUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: <Widget>[
            Hero(
              tag: 'User profile Image',
              child: CircleAvatar(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  radius: MediaQuery.of(context).size.height / 10,
                  child: ClipOval(
                    child: loadingFlag
                        ? CircularProgressIndicator()
                        : Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.height / 5,
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                  )),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (builder) => Homescreen()));
                  _showPicker(context);
                },
                child: CircleAvatar(
                    backgroundColor: Color(0xFF075E54),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        // width: MediaQuery.of(context).size.width - 70,
        height: 55,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 240, 240, 240),
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 0.1, //extend the shadow
            offset: Offset(
              0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ]),

        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextFormField(
            onChanged: (e) {
              userName = e;
            },
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: 25,
              // color: Colors.white,
            ),
            decoration: InputDecoration(
              // labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 17,
                // color: Colors.white,
              ),
              suffixIcon: IconButton(
                onPressed: () => controller.clear(),
                icon: Icon(
                  Icons.edit,
                  color: Color(0xFF075E54),
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget statusWidget(String status) {
    return Expanded(
      child: ListView(children: <Widget>[
        InkWell(
          onTap: (() => _showStutsPicker(context)),
          child: ListTile(
            title: Text(
              "Status",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF075e54)),
            ),
            trailing: Icon(Icons.edit),
          ),
        ),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget phoneWidget(String phone) {
    return Expanded(
      child: ListView(children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              phone,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
          ),
        ),
      ]),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showStutsPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.checklist_rtl_outlined),
                      title: new Text('Available'),
                      onTap: () {
                        setState(() {
                          userStatus = 'Available';
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.event_busy_outlined),
                    title: new Text('Busy'),
                    onTap: () {
                      setState(() {
                        userStatus = 'Busy';
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.notification_important_outlined),
                    title: new Text('Important Only'),
                    onTap: () {
                      setState(() {
                        userStatus = 'Important Only';
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

// class Avatar extends StatelessWidget {
//   Avatar(
//     this.imgUrl,
//   );
//   final String imgUrl;

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
