import 'package:flutter/material.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return new Scaffold(
      appBar: new AppBar(
        title: new Text('User Settings'),
      )
    );
  }
}

class PostArchive extends StatelessWidget {
  PostArchive({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Post Archive'),
      )
    );
  }
}

class Settings extends StatelessWidget {
  Settings({Key key}) : super(key: key);

  final widgetList = [UserSettings()];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: Text('User Settings'),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => UserSettings()),
            );
          },
        ),
        Divider(color: Colors.grey, height: 0.0),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Post Archive'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostArchive()),
            );
          },
        )
      ]
    );
  }
}