import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.trending_up, color: Colors.blueGrey)),
                Tab(icon: Icon(Icons.history, color: Colors.blueGrey)),
              ]
            )),
          Expanded(child: TabBarView(
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.fastfood), 
                          title: Text('Hack for Humanity'),
                          subtitle: Text('Leftover perishables...'),
                        )
                      ]
                    )
                  ),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.local_drink), 
                          title: Text('Broncohacks'),
                          subtitle: Text('Leftover perishables...'),
                        )
                      ]
                    )
                  ),
                  
                ]
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.local_drink), 
                          title: Text('Broncohacks'),
                          subtitle: Text('Leftover perishables...'),
                        )
                      ]
                    )
                  ),
                  
                ]
              ),
            ]
          )),
        ],
      ),
    );
  }
}