import 'package:flutter/material.dart';
import 'package:whats_new/CustomUI/HeadOwnStatus.dart';
import 'package:whats_new/CustomUI/OthersStatus.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (builder) => SelectContact()));
            },
            child: Icon(
              Icons.edit,
              size: 34,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          FloatingActionButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (builder) => SelectContact()));
            },
            child: Icon(
              Icons.camera_alt,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            HeadOwnStatus(),
            labeledDivider('Recent updates '),
            OthersStatus(
              name: 'Ali H',
              time: '6:23',
              imageName: 'assets/status1.png',
              isSeen: false,
              statusNum: 3,
            ),
            OthersStatus(
              name: 'Ali H',
              time: '6:23',
              imageName: 'assets/status1.png',
              isSeen: false,
              statusNum: 2,
            ),
            OthersStatus(
              name: 'Ali H',
              time: '6:23',
              imageName: 'assets/status1.png',
              isSeen: false,
              statusNum: 3,
            ),
            labeledDivider('Viewed updates '),
            OthersStatus(
              name: 'Mohanad H',
              time: '6:23',
              imageName: 'assets/status4.jpeg',
              isSeen: true,
              statusNum: 5,
            ),
            OthersStatus(
              name: 'Mohanad H',
              time: '6:23',
              imageName: 'assets/status4.jpeg',
              isSeen: true,
              statusNum: 1,
            ),
            OthersStatus(
              name: 'Mohanad H',
              time: '6:23',
              imageName: 'assets/status4.jpeg',
              isSeen: true,
              statusNum: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget labeledDivider(String lable) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          lable,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
