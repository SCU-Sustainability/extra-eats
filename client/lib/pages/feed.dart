import 'package:flutter/material.dart';

import 'dart:async';

import '../models/post.dart';
import '../data/client.dart';
import '../actions.dart';

class PostView extends StatelessWidget {
  Post post;

  PostView({Key key, Post post}) : super(key: key) {
    this.post = post;
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      Text(this.post.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
      Text(this.post.location, style: TextStyle(fontWeight: FontWeight.w200)),
      Center(
        child: Padding(child: Text('Filler'), padding: EdgeInsets.all(50)),
      ),
      Text(this.post.description,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
      Text('Expires on ' +
          this.post.expiration.toLocal().month.toString() +
          '/' +
          this.post.expiration.toLocal().day.toString() +
          ' at ' +
          this.post.expiration.toLocal().hour.toString() +
          ':' +
          this.post.expiration.toLocal().minute.toString()),
      Padding(
          child: Wrap(
              spacing: 2.0,
              runSpacing: 0.0,
              children:
                  List<Widget>.generate(this.post.tags.length, (int index) {
                return Chip(label: Text(this.post.tags[index]));
              })),
          padding: EdgeInsets.only(top: 15)),
    ];
    return Scaffold(
        appBar: AppBar(title: Text(this.post.name)),
        body: Padding(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return items[index];
                }),
            padding: EdgeInsets.all(30)));
  }
}

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

  _openPost(Post post, BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PostView(post: post)));
  }

  Widget _listPosts(List<Post> posts, BuildContext context) {
    String userId = InheritedClient.of(context).userId;
    Widget listView = ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var currentPost = posts[posts.length - index - 1];
          var buttons = [
            FlatButton(
                child: Text('More Info'),
                onPressed: () {
                  this._openPost(currentPost, context);
                }),
          ];
          if (userId == currentPost.creator) {
            buttons.add(FlatButton(
                child: Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Client.get()
                      .deletePost(InheritedClient.of(context).accessToken,
                          currentPost.id)
                      .then((res) {
                    setState(() {});
                  });
                }));
          }
          return Padding(
              padding: EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 0),
              child: Card(
                  child: Column(children: [
                ListTile(
                    title: Text(currentPost.name),
                    subtitle: Text(currentPost.location)),
                Padding(
                    child: Text(currentPost.description),
                    padding: EdgeInsets.all(15)),
                ButtonTheme.bar(child: ButtonBar(children: buttons))
              ])));
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
              return _listPosts(snapshot.data, context);
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
