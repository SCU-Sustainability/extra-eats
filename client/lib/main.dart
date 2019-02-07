import 'package:flutter/material.dart';
import './pages/feed.dart';
import './pages/settings.dart';
import './pages/submit_post.dart';

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

  final List<Widget> _children = [
    Feed(),
    SubmitPost(),
    Settings()
  ];

  final _names = ['Home Feed', 'Submit Post', 'Settings'];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_names[_currentIndex]),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
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
      ),
    );
  }
}