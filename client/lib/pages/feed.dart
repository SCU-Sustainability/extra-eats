import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:async';

import '../models/post.dart';
import '../data/client.dart';
import '../actions.dart';

class PostView extends StatelessWidget {
  final Post post;

  PostView({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = [
      Text(this.post.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
      Text(this.post.location, style: TextStyle(fontWeight: FontWeight.w200)),
      Center(
        child: Padding(
            child: Image.network(post.image), padding: EdgeInsets.all(15)),
      ),
      Text(this.post.description,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
      Text(
          'Expires at ' +
              DateFormat('h:mm a on MMM d')
                  .format(this.post.expiration.toLocal()),
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
      if (this.post.tags.length > 0)
        Padding(child: Text('May Contain:'), padding: EdgeInsets.only(top: 15)),
      Wrap(
          spacing: 2.0,
          runSpacing: 0.0,
          children: List<Widget>.generate(this.post.tags.length, (int index) {
            return Chip(label: Text(this.post.tags[index]));
          }))
    ];
    return Scaffold(
        appBar: AppBar(title: Text(this.post.name)),
        body: Padding(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) => items[index]),
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

  static _openPost(Post post, BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PostView(post: post)));
  }

  Widget _listPosts(List<Post> posts, BuildContext context) {
    String userId = InheritedClient.of(context).userId;
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        var currentPost = posts[posts.length - index - 1];
        return Padding(
          padding: EdgeInsets.all(15),
          child: Card(
            child: Column(children: [
              ListTile(
                  title: Text(currentPost.name,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                  subtitle: Text(currentPost.location)),
              InkWell(
                  child: Image.network(currentPost.image),
                  onTap: () => _openPost(currentPost, context)),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: [
                    FlatButton(
                        child: Text('More Info'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          _openPost(currentPost, context);
                        }),
                    if (userId == currentPost.creator)
                      FlatButton(
                        child: Text('Delete',
                            style:
                                TextStyle(color: Theme.of(context).errorColor)),
                        onPressed: () {
                          String alert_msg =
                              "Are you sure you want to delete this post?";
                          alertDialog(context, alert_msg, currentPost,
                              () => setState(() {}));
                        },
                      ),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
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

// alerts func
void alertDialog(
    BuildContext context, String alert_msg, Post post, Function reload) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(alert_msg),
        //content: new Text("Alert Dialog body"), //used for a body in the msg
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Yes"),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop();
              Client.get()
                  .deletePost(InheritedClient.of(context).accessToken, post.id);
              reload(); //reload the page
            },
          ),
          new FlatButton(
            child: new Text("No"),
            textColor: Theme.of(context).primaryColor,
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}
