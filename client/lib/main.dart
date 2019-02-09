import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './pages/feed.dart';
import './pages/settings.dart';
import './pages/submit_post.dart';
import './pages/login.dart';
import './actions.dart';

void main() => runApp(TasteTheWaste());

class TasteTheWaste extends StatefulWidget {
  TasteTheWaste({Key key}): super(key: key);

  @override
  _TasteTheWasteState createState() => _TasteTheWasteState();
  
}

class _TasteTheWasteState extends State<TasteTheWaste> {

  int _currentIndex = 0;
  String _accessToken = '';
  String _userId = '';

  @override
  void initState() {
    _wakeApi();
    super.initState();
  }

  final tabNames = ['Home Feed', 'Submit Post', 'Settings'];
  final List<Widget> _children = [
    Feed(),
    SubmitPost(),
    Settings()
  ];

  void _setIndex(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  Future<http.Response> _wakeApi() async {
    return http.get('http://10.0.2.2:8080/api/', headers: {
      'Accept': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((res) {
      
    });
  }

  bool _isLoggedIn() {
    return this._accessToken != '';
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
    return _isLoggedIn() ? _children[this._currentIndex] : Login();
  }

  void _setToken(String token) {
    setState(() {
      this._accessToken = token;
    });
  }

  void _logout() {
    this._currentIndex = 0;
    this._setToken('');
  }

  Future<http.Response> _login(String email, String password) async {
    return http.post('http://10.0.2.2:8080/api/login', body: {
      'email': email,
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
        this._setToken(response['token']);
        this._userId = response['user_id'];
      } catch (Exception) {
        // Todo: handle error
        return;
      }
     
    });
  }

  Future<http.Response> _register(String name, String password, String email) async {
    return http.post('http://10.0.2.2:8080/api/users', body: {
      'email': email,
      'password': password,
      'name': name,
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
        this._setToken(response['token']);
        this._userId = response['user_id'];
      } catch (Exception) {
        // Todo: handle exception (API connection error likely)
        return;
      }
    });
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
        title: Text(_isLoggedIn() ? tabNames[this._currentIndex] : 'Login'),
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
    login: this._login,
    logout: this._logout,
    register: this._register,
    accessToken: this._accessToken,
    userId: this._userId,
    );
  }
}