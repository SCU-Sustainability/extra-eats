import 'package:flutter/material.dart';

class SubmitPost extends StatefulWidget {
  SubmitPost({Key key}) : super(key: key);

  @override
  _SubmitPostState createState() => _SubmitPostState();
}

class _SubmitPostState extends State<SubmitPost> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _clear() {
    nameController.clear();
    descriptionController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _ensureCancel() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel this post?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            RaisedButton(
              textColor: Colors.white,
              child: Text('Cancel'),
              onPressed: () {
                _clear();
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Name',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: 'Description',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                children: [
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text('Cancel'),
                    onPressed: () {
                      _ensureCancel();
                    }
                  ),
                  Spacer(flex: 1),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    child: Text('Submit'),
                    onPressed: () {
                      _clear();
                    },
                  ),
                ]
              )
            ),
          ),
        ),
      ],
    );
  }
}