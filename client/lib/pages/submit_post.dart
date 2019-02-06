import 'package:flutter/material.dart';

class SubmitPost extends StatefulWidget {
  SubmitPost({Key key}) : super(key: key);

  @override
  _SubmitPostState createState() => _SubmitPostState();
}

class _SubmitPostState extends State<SubmitPost> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const TextField(
          decoration: InputDecoration(
            hintText: 'Name',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 0.0
        ),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Description',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 0.0
        ),
      ],
    );
  }
}