import 'package:flutter/material.dart';
import 'package:whats_new/NewScreens/LoginPage.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                "Welcome to Whatsapp",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 29,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 14,
              ),
              Image.asset(
                "assets/bg.png",
                color: Colors.greenAccent[700],
                height: MediaQuery.of(context).size.height / 2.5,
                width: 340,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        children: [
                          TextSpan(text: "Agree and continue to accept the "),
                          TextSpan(
                              text:
                                  "Whatsapp terms of service and privacy policy ",
                              style: TextStyle(color: Colors.cyan)),
                          TextSpan(text: "Agree and continue to accept the "),
                        ])),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 16,
              ),
              InkWell(
                onTap: () {
                  print('page hieght ==> ' +
                      (MediaQuery.of(context).size.height / 2.5).toString());
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => LoginPage()),
                      (route) => false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 110,
                  height: 50,
                  child: Card(
                      margin: EdgeInsets.all(0),
                      elevation: 8,
                      color: Colors.greenAccent[700],
                      child: Center(
                        child: Text(
                          "AGREE AND CONTINUE",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
