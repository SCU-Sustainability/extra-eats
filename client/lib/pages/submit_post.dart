import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../data/repository.dart';

class SubmitPost extends StatefulWidget {
  SubmitPost({Key key}) : super(key: key);

  @override
  _SubmitPostState createState() => _SubmitPostState();
}

class _SubmitPostState extends State<SubmitPost> {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._image = image;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _clear() {
    nameController.clear();
    descriptionController.clear();
    setState(() {
      _image = null;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _ensureSubmit() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit this post?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            RaisedButton(
              textColor: Colors.white,
              child: Text('Submit'),
              onPressed: () {
                _clear();
                // Implement Repository.get().client.post() here
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
        Padding(child: FlatButton(
          textColor: Colors.blue,
          child: Icon(Icons.add_a_photo),
          onPressed: getImage,
        ), padding: EdgeInsets.only(top: 15)),
        Center(
          child: _image == null ? Text('No image selected.') : Text('Image confirmed.')
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
                      _clear();
                    }
                  ),
                  Spacer(flex: 1),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    child: Text('Submit'),
                    onPressed: () {
                      _ensureSubmit();
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