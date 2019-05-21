import 'package:flutter/material.dart';

import '../actions.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(physics: NeverScrollableScrollPhysics(), children: <Widget>[
      ListTile(
          leading: Icon(Icons.notifications),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Push notifications: ',
                  style: TextStyle(fontWeight: FontWeight.w300)),
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
          onTap: () => setState(() {
                _pushNotifications = !_pushNotifications;
              })),
      ListTile(
          leading: Icon(Icons.fastfood),
          title: Text('Hygiene guidelines',
              style: TextStyle(fontWeight: FontWeight.w300)),
          onTap: (){} //nothing yet
          ),
      ListTile(
          leading: Icon(Icons.assignment),
          title: Text('Legal', style: TextStyle(fontWeight: FontWeight.w300)),
          onTap: (){} //nothing yet
          ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign out', style: TextStyle(fontWeight: FontWeight.w300)),
        onTap: InheritedClient.of(context).logout,
      ),
    ]);
  }
}
