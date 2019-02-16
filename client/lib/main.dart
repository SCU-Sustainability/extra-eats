import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import './pages/feed.dart';
import './pages/settings.dart';
import './pages/submit_post.dart';
import './pages/login.dart';
import './actions.dart';
import './data/repository.dart';

void main() => runApp(TasteTheWaste());

class TasteTheWaste extends StatefulWidget {
  TasteTheWaste({Key key}): super(key: key);

  final tabNames = ['Home Feed', 'Submit Post', 'Settings'];
  final List<Widget> _children = [
    Feed(),
    SubmitPost(),
    Settings()
  ];

  @override
  _TasteTheWasteState createState() => _TasteTheWasteState();
  
}

class _TasteTheWasteState extends State<TasteTheWaste> {

  int _currentIndex = 0;
  String _accessToken = '';
  String _userId = '';

  @override
  void initState() {
    Repository.get().client.ping();
    super.initState();
  }

  void register(String email, String password, String name) async {
    await Repository.get().client.register(email, password, name).then(this._login);
  }

  void login(String email, String password) async {
    await Repository.get().client.login(email, password).then(this._login);
  }

  void logout() async {
    this._currentIndex = 0;
    this._setToken('');
  }

  void _login(dynamic res) {
    try {
        Map<String, dynamic> response = convert.jsonDecode(res.body);
        if (!response.containsKey('user_id') || !response.containsKey('token')) {
          // Handle
          print(res);
          return;
        }
        this._setToken(response['token']);
        this._userId = response['user_id'];
      } catch (Exception) {
        // Handle
        print(res);
        return;
      }
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
    return this._accessToken != '';
  }

  Widget _handleMainScreen() {
    return _isLoggedIn() ? widget._children[this._currentIndex] : Login();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InheritedClient(child: MaterialApp(
      title: 'Taste the Waste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
      appBar: AppBar(
        title: Text(_isLoggedIn() ? widget.tabNames[this._currentIndex] : 'Login'),
      ),
      body: _handleMainScreen(),
      bottomNavigationBar: _isLoggedIn() ? BottomNavigationBar(
        onTap: this._setIndex,
        currentIndex: this._currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('Post'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Extras')
          )
        ],
      ) : null,
    ),
    ),
    login: this.login,
    logout: this.logout,
    register: this.register,
    accessToken: this._accessToken,
    userId: this._userId,
    );
  }
}