import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onesignal/onesignal.dart';
import 'dart:io' show Platform;

import './pages/feed.dart';
import './pages/settings.dart';
import './pages/submit_post.dart';
import './pages/login.dart';
import './actions.dart';
import './data/client.dart';

void main() => runApp(TasteTheWaste());

class TasteTheWaste extends StatefulWidget {
  TasteTheWaste({Key key}) : super(key: key);

  @override
  _TasteTheWasteState createState() => _TasteTheWasteState();
}

class _TasteTheWasteState extends State<TasteTheWaste> {
  List _tabNames = ['Home Feed', 'Settings'];
  List<Widget> _children = [Feed(), Settings()];
  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings'))
  ];

  int _currentIndex = 0;
  String _accessToken = '';
  String _userId = '';
  bool _provider = false;

  @override
  void initState() {
    Client.get().ping();
    super.initState();
  }

  void register(
      String email, String password, String name, bool provider) async {
    await Client.get()
        .register(email, password, name, provider)
        .then(this._login);
  }

  Future<bool> login(String email, String password) async {
    bool loginWorked =
        await Client.get().login(email, password).then(this._login);
    return loginWorked;
  }

  void logout() async {
    this._currentIndex = 0;
    this._setToken('');
    if (this._items.length == 3) {
      this._items.removeAt(1);
      this._children.removeAt(1);
      this._tabNames.removeAt(1);
      this._provider = false;
    }
  }

  bool _login(res) {
    try {
      if (!res.data.containsKey('user_id') ||
          !res.data.containsKey('token') ||
          !res.data.containsKey('provider')) {
        // Handle
        print(res);
        return false;
      }
      this._setToken(res.data['token']);
      this._userId = res.data['user_id'];
      this._provider = res.data['provider'];
      if (Platform.isAndroid) {
        OneSignal.shared.init('6d50216a-231d-4cf5-9abd-7928d4f020fb');
        OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);
      }
      if (this._provider && this._items.length == 2) {
        this._items.insert(
            1,
            BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo),
              title: Text('Post'),
            ));
        this._children.insert(1, SubmitPost());
        this._tabNames.insert(1, 'Submit Post');
      }
    } catch (Exception) {
      // Handle
      print(res);
      return false;
    }
    return true;
  }

  void _setToken(String token) {
    setState(() {
      this._accessToken = token;
    });
  }

  void _setIndex(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  bool _isLoggedIn() {
    return this._accessToken !=
        ''; //changed to make the project run for the first time
    //return true;
  }

  Widget _handleMainScreen() {
    return _isLoggedIn() ? _children[this._currentIndex] : Login();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InheritedClient(
      child: MaterialApp(
        title: 'ExtraEats',
        theme: ThemeData(
          //green
          primaryColor: const Color(0xFF489835), //App bar
          buttonColor: const Color(0xFF489835), //buttons
          //light green
          accentColor: const Color(0xFF9BCF31), //reload, option slider
          //there is no yellow
          //red
          errorColor: const Color(0xFFCE0000), //Cancel, Go Back
          //off white
          backgroundColor: const Color(0xFFF7F7ED), //not used
        ),
        home: Scaffold(
          appBar: AppBar(
            title:
                Text(_isLoggedIn() ? _tabNames[this._currentIndex] : 'Login'),
          ),
          body: _handleMainScreen(),
          bottomNavigationBar: _isLoggedIn()
              ? BottomNavigationBar(
                  onTap: this._setIndex,
                  currentIndex: this._currentIndex,
                  items: _items,
                )
              : null,
        ),
      ),
      login: this.login,
      logout: this.logout,
      register: this.register,
      accessToken: this._accessToken,
      userId: this._userId,
    );
  }

// alerts func
  void alertDialog(BuildContext context, String alert) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(alert),
          //content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }
}
