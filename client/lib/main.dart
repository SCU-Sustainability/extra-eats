import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './pages/feed.dart';
import './pages/settings.dart';
import './pages/submit_post.dart';
import './pages/login.dart';
import './actions.dart';

void main() => runApp(TasteTheWaste());

class TasteTheWaste extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taste the Waste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppContainer(),
    );
  }
}

class AppContainer extends StatefulWidget {
  AppContainer({Key key}) : super(key: key);

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {

  int _currentIndex = 0;
  String _accessToken = '';
  String _userId = '';

  List<Widget> _children = [
    Feed(),
    SubmitPost(),
    Settings()
  ];

  final tabNames = ['Home Feed', 'Submit Post', 'Settings'];

  @override
  void initState() {
    _wakeApi();
    super.initState();
  }

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool _isLoggedIn() {
    return this._accessToken.toString() != '';
  }

  void setToken(String token) {
    setState(() {
      this._accessToken = token;
    });
  }

  void _logout() {
    this.setToken('');
  }

  Future<http.Response> _wakeApi() async {
    return http.get('https://taste-the-waste.herokuapp.com/api/', headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
      
    });
  }

  Future<http.Response> _login(String username, String password) async {
    this._currentIndex = 0;
    return http.post('https://taste-the-waste.herokuapp.com/api/login', body: {
      'username': username,
      'password': password
    }, headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
      try {

        Map<String, dynamic> response = convert.json.decode(res.body);
        if (!response.containsKey('token') || !response.containsKey('user_id')) {
          // Todo: handle this error
          return;
        }
        this.setToken(response['token']);
        this._userId = response['user_id'];
      } catch (Exception) {
        // Todo: handle error
        return;
      }
     
    });
  }

  Future<http.Response> _register(String username, String password, String email) async {
    return http.post('https://taste-the-waste.herokuapp.com/api/users', body: {
      'username': username,
      'password': password,
      'email': email
    }, headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
      try {
        Map<String, dynamic> response = convert.json.decode(res.body);
        if (!response.containsKey('code') || response['code'] != 1) {
          // Todo: handle error
          return ;
        }
        this.setToken(response['token']);
        this._userId = response['user_id'];
      } catch (Exception) {
        // Todo: handle exception (API connection error likely)
        return;
      }
    });
  }

  /*void _loginWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser current = await FirebaseAuth.instance.currentUser();
    if (user.uid == current.uid) {
      this.setToken(googleAuth.accessToken);
    }
  }**/

  Widget _handleMainScreen() {
    /*return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Splash();
        } else {
          if (snapshot.hasData) {
            return _children[_currentIndex];
          }
        }
      }
    );**/
    return _isLoggedIn() ? _children[_currentIndex] : Login();
  }

  @override
  Widget build(BuildContext context) {
    return ClientAction(
      child: Scaffold(
      appBar: AppBar(
        title: Text(_isLoggedIn() ? tabNames[_currentIndex] : 'Login'),
      ),
      body: _handleMainScreen(),
      bottomNavigationBar: _isLoggedIn() ? BottomNavigationBar(
        onTap: _setIndex,
        currentIndex: _currentIndex,
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
    logout: this._logout,
    login: this._login,
    register: this._register);
    
  }
}