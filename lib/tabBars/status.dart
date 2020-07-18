import 'package:flutter/material.dart';

import '../home.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: HomePage.isSwitched?Colors.blueGrey:Colors.lightBlue,
        foregroundColor:HomePage.isSwitched?Colors.white70:Colors.white ,
        child: Center(
          child: Icon(Icons.camera_enhance),
        ),
        onPressed: null,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/en/thumb/3/3c/Chris_Hemsworth_as_Thor.jpg/220px-Chris_Hemsworth_as_Thor.jpg'),
                  ),
                  title: Text('My Status'),
                  subtitle: Text('Add Status'),
                ),
                Container(
                  color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width,
                  height: 25.0,
                  child: Center(
                    child: Text(
                      'Recent Updates',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/en/thumb/3/3c/Chris_Hemsworth_as_Thor.jpg/220px-Chris_Hemsworth_as_Thor.jpg'),
                  ),
                  title: Text('Maa'),
                  subtitle: Text('1 minute ago'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/en/thumb/3/3c/Chris_Hemsworth_as_Thor.jpg/220px-Chris_Hemsworth_as_Thor.jpg'),
                  ),
                  title: Text('Bro'),
                  subtitle: Text('Just now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}