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

  @override
  _TasteTheWasteState createState() => _TasteTheWasteState();
  
}

class _TasteTheWasteState extends State<TasteTheWaste> {

  List _tabNames = ['Home Feed', 'Settings'];
  List<Widget> _children = [
    Feed(),
    Settings()
  ];
  List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Extras')
    )
  ];

  int _currentIndex = 0;
  String _accessToken = '';
  String _userId = '';
  bool _provider = false;

  @override
  void initState() {
    Repository.get().client.ping();
    super.initState();
  }

  void register(String email, String password, String name, bool provider) async {
    await Repository.get().client.register(email, password, name, provider).then(this._login);
  }

  void login(String email, String password) async {
    await Repository.get().client.login(email, password).then(this._login);
  }

  void logout() async {
    this._currentIndex = 0;
    this._setToken('');
    this._items.removeAt(1);
    this._children.removeAt(1);
    this._tabNames.removeAt(1);
  }

  void _login(res) {
    try {
        if (!res.data.containsKey('user_id') || !res.data.containsKey('token') || !res.data.containsKey('provider')) {
          // Handle
          print(res);
          return;
        }
        this._setToken(res.data['token']);
        this._userId = res.data['user_id'];
        this._provider = res.data['provider'];
        // Todo: change _children and _items
        if (this._provider) {
          this._items.insert(1, BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('Post'),
          ));
          this._children.insert(1, SubmitPost());
          this._tabNames.insert(1, 'Submit Post');
        }

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
    return _isLoggedIn() ? _children[this._currentIndex] : Login();
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
        title: Text(_isLoggedIn() ? _tabNames[this._currentIndex] : 'Login'),
      ),
      body: _handleMainScreen(),
      bottomNavigationBar: _isLoggedIn() ? BottomNavigationBar(
        onTap: this._setIndex,
        currentIndex: this._currentIndex,
        items: _items,
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