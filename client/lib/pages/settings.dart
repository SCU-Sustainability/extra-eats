import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var settings = {
    'notifications': true,
    'stayLogin': true,
  };
  bool _saved = true;

  Future savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', settings['notifications']);
    prefs.setBool('stayLogin', settings['stayLogin']);
    setState(() {
      _saved = true;
    });
    return true;
  }

  Future getPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    settings['notifications'] = prefs.getBool('notifications') ?? true;
    settings['stayLogin'] = prefs.getBool('stayLogin') ?? true;
    _saved = true;
    return settings;
  }

  Widget settingsSwitch(BuildContext context,
      {Icon icon, String label, String setting}) {
    return ListTile(
        leading: icon,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(label, style: TextStyle(fontWeight: FontWeight.w300)),
            Spacer(flex: 1),
            Transform.scale(
                scale: 1.5,
                child: Switch(
                  value: settings[setting],
                  onChanged: (bool changed) async {
                    setState(() {
                      settings[setting] = changed;
                      _saved = false;
                    });
                  },
                ))
          ],
        ),
        onTap: () async {
          setState(() {
            settings[setting] = !settings[setting];
            _saved = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        settingsListOrError(context),
        Spacer(),
        Text('Sponsored by:',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/sambazon.png'), width: 200.0),
        ),
      ],
    );
  }

  Widget settingsListOrError(BuildContext context) {
    var errorStyle = TextStyle(color: Theme.of(context).errorColor);
    if (!_saved)
      return settingsList(context);
    else
      return FutureBuilder(
          future: getPreferences(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Can\'t connect', style: errorStyle);
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}', style: errorStyle);
                //else
                return settingsList(context);
            }
          });
  }

  Widget settingsList(BuildContext context) {
    return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          settingsSwitch(context,
              icon: Icon(Icons.person),
              label: 'Stay logged in',
              setting: 'stayLogin'),
          settingsSwitch(context,
              icon: Icon(Icons.notifications),
              label: 'Push notifications',
              setting: 'notifications'),
          ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Hygiene guidelines',
                  style: TextStyle(fontWeight: FontWeight.w300)),
              onTap: () {} //nothing yet
              ),
          ListTile(
              leading: Icon(Icons.assignment),
              title:
                  Text('Legal', style: TextStyle(fontWeight: FontWeight.w300)),
              onTap: () {} //nothing yet
              ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title:
                Text('Sign out', style: TextStyle(fontWeight: FontWeight.w300)),
            onTap: () async {
              settings['stayLogin'] = false;
              await savePreferences();
              InheritedClient.of(context).logout();
            },
          ),
          if (!_saved)
            RaisedButton(
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: savePreferences),
        ]);
  }
}
