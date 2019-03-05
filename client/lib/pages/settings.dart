import 'package:flutter/material.dart';

import '../actions.dart';

class UserSettings extends StatefulWidget {
  UserSettings({Key key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Push notifications: '),
              Spacer(flex: 1),
              Transform.scale(
                  scale: 1.5,
                  child: Switch(
                    value: _pushNotifications,
                    onChanged: (bool changed) {
                      setState(() {
                        _pushNotifications = changed;
                      });
                    },
                  )),
            ],
          ),
          Divider(color: Colors.grey, height: 16.0),
        ]),
      ),
    );
  }
}

class ArchiveSettings extends StatelessWidget {
  ArchiveSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive Settings'),
      ),
      body: Column(),
    );
  }
}

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(physics: NeverScrollableScrollPhysics(), children: <Widget>[
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
        title: Text('Archive Settings'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArchiveSettings()),
          );
        },
      ),
      Divider(color: Colors.grey, height: 0.0),
      ListTile(
        leading: Icon(Icons.arrow_back_ios),
        title: Text('Signout'),
        onTap: InheritedClient.of(context).logout,
      ),
    ]);
  }
}
