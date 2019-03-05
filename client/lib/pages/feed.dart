import 'package:flutter/material.dart';

import 'dart:async';

import '../models/post.dart';
import '../data/client.dart';
import '../actions.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  Future<List<Post>> _getPosts(BuildContext context) async {
    var res =
        await Client.get().getPosts(InheritedClient.of(context).accessToken);
    if (res.data['code'] == 1) {
      List<Post> posts = [];
      for (var post in res.data['posts']) {
        posts.add(Post.fromJson(post));
      }
      return posts;
    } else
      return [];
  }

  Widget _listPosts(List<Post> posts) {
    Widget listView = ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var currentPost = posts[posts.length - index - 1];
          return Padding(
              padding: EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 0),
              child: Card(
                  child: ListTile(
                      leading: Icon(Icons.fastfood),
                      title: Text(currentPost.name),
                      subtitle: Text(currentPost.description))));
        });
    return listView;
  }

  Widget _postBuilder(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: this._getPosts(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                    child: Text('No posts currently, check back later!'));
              }
              return _listPosts(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('Something went wrong!');
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: Expanded(
                child: Container(
          padding: EdgeInsets.all(9.0),
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
          child: _postBuilder(context),
        ))),
      ],
    );
  }
}
