import 'package:flutter/material.dart';
import 'dart:math';
import '../models/post.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

List<Post> seed = [
  new Post('H4H Leftovers', 'Leftover snacks...'),
  new Post('Free food at Locatelli', 'Food and water...'),
  new Post('Fake event post!', 'This is mock data...'),
];

List<Post> mockFeed = [
  new Post('Leftover food', 'Some leftover food here...'),
  new Post('Broncdasfdsaohacks', 'Leftover perishables...'),
  new Post('H4H Leftdsafdsaovers', 'Leftover snacks...'),
  new Post('Free food sdafat Locatelli', 'Food and water...'),
  new Post('Fake evedsafsadnt post!', 'This is mock data...'),
  new Post('H4fdsafdaH Leftovers', 'Leftover snacks...'),
  new Post('Free dsafdsaffood at Locatelli', 'Food and water...'),
  new Post('Fakedsafdsa event post!', 'This is mock data...'),
];

List<Post> mockArchive = [
  new Post('Broncohacks', 'Leftover perishables...')
];

class _FeedState extends State<Feed> {

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    mockFeed.add(seed[(new Random()).nextInt(seed.length)]);
    setState(() {

    });
    return null;  
  }

  Widget _postCards(List<Post> posts) {
    Widget listView = new ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return new Card(
          child: new ListTile(
            leading: Icon(Icons.fastfood),
            title: Text(posts[posts.length - index - 1].name),
            subtitle: Text(posts[posts.length - index - 1].description)
          )
        );
      }
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(child: TabBar(
              
              tabs: [
                Tab(icon: Icon(Icons.trending_up), text: 'Feed'),
                Tab(icon: Icon(Icons.history), text: 'Archive'),
              ],
              labelColor: Colors.blueGrey,
            )),
          Expanded(child: TabBarView(
            children: <Widget>[
              new RefreshIndicator(
                child: _postCards(mockFeed),
                onRefresh: _handleRefresh,
              ),
              _postCards(mockArchive),
            ]
          )),
        ],
      ),
    );
  }
}