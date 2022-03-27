import 'package:flutter/material.dart';

class HeadOwnStatus extends StatelessWidget {
  const HeadOwnStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/status2.jpeg'),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 10,
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      title: Text(
        'My Status',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(
        'Tap to add update',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}
