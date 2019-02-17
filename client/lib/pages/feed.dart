import 'dart:math';
import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../data/client.dart';
import '../actions.dart';

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

  Future<Response> _getPosts() async {
    try {
      var response = await Dio().get(Client.url() + 'posts', options: Options(
      headers: {
        'x-access-token': InheritedClient.of(context).accessToken
      }
    ));
    return response;
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    mockFeed.add(seed[(new Random()).nextInt(seed.length)]);
    setState(() {

    });
    return null;  
  }

  Widget _postCards(List<Post> posts) {
    Widget listView = ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Padding(padding: EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 0), child: Card(
          child: ListTile(
            leading: Icon(Icons.fastfood),
            title: Text(posts[posts.length - index - 1].name),
            subtitle: Text(posts[posts.length - index - 1].description)
          )
        ));
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
          Expanded(
            child: Container(padding: EdgeInsets.all(9.0), decoration: BoxDecoration(
              color: Colors.black12,
            ), child: TabBarView(
              children: <Widget>[
                RefreshIndicator(
                  child: _postCards(mockFeed),
                  onRefresh: _handleRefresh,
                ),
                _postCards(mockArchive),
              ]
            ))
          ),
        ],
      ),
    );
  }
}