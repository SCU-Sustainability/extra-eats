import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' as convert;
import './pages/feed.dart';
import './pages/settings.dart';
import './pages/submit_post.dart';
import './pages/login.dart';
import './actions/user_actions.dart';

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
  List<Widget> _children = [
    Feed(),
    SubmitPost(),
  ];

  final _names = ['Home Feed', 'Submit Post', 'Settings'];
  final _googleSignIn = GoogleSignIn();

  _AppContainerState() {
    _children.add(Settings());
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
        if (response.containsKey('token')) {
          this.setToken(response['token']);
        }
      } catch (Exception) {
        return;
      }
     
    });
  }

  void _loginWithGoogle() async {
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
  }

  Widget _handleMainScreen() {
    /* return new StreamBuilder<FirebaseUser>(
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
    return LoginAction(
      child: LogoutAction(
      child: Scaffold(
      appBar: AppBar(
        title: Text(_isLoggedIn() ? _names[_currentIndex] : 'Login'),
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
    ), login: this._login);
    
  }
}