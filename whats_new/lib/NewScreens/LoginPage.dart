import 'package:flutter/material.dart';
import 'package:whats_new/Model/CountryModel.dart';
import 'package:whats_new/NewScreens/CountryPage.dart';
import 'package:whats_new/NewScreens/OtpScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String countryname = 'IRAQ';
  String countrycode = '+964';
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Enter your phone number",
          style: TextStyle(
              wordSpacing: 1,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.teal),
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.more_vert,
            color: Colors.black,
            size: 30,
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "Whatsapp will send an SMS to verify your number",
              style: TextStyle(fontSize: 13.5),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "what's my number",
              style: TextStyle(fontSize: 12.8, color: Colors.cyan[800]),
            ),
            SizedBox(
              height: 5,
            ),
            countryCard(),
            SizedBox(
              height: 25,
            ),
            number(),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                if (_controller.text.length == 10) {
                  showMydialog();
                } else
                  showAlert();
              },
              child: Container(
                color: Colors.teal,
                width: 70,
                height: 40,
                child: Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 55,
            )
          ],
        ),
      ),
    );
  }

  Widget number() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 38,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.teal, width: 1.5))),
            width: 50,
            child: Center(
              child: Row(
                children: [
                  Text(
                    countrycode,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5 - 70,
            padding: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.teal, width: 1.5))),
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(11),
                  hintText: 'Phone nomber'),
            ),
          )
        ],
      ),
    );
  }

  Widget countryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => CounryPage(
                      setCountryData: setCountryData,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.teal, width: 1.5))),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Center(
                    child: Text(
                  countryname,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 28,
              color: Colors.teal,
            )
          ],
        ),
      ),
    );
  }

  void setCountryData(CountryModel country1) {
    setState(() {
      countryname = country1.name;
      countrycode = country1.code;
    });
    Navigator.pop(context);
  }

  Future<void> showMydialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We will be veryfying your phone number',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(countrycode + ' ' + _controller.text,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Is this ok, or would you like to edit the number',
                      style: TextStyle(fontSize: 13.5))
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('EDIT',
                      style: TextStyle(fontSize: 14, color: Colors.blue))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => OtpScreen(
                                number: _controller.text,
                                countryCode: countrycode)));
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Future<void> showAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'There is no or invalid number you entered',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK',
                      style: TextStyle(fontSize: 14, color: Colors.blue))),
            ],
          );
        });
  }
}
