import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:async';

import '../data/client.dart';
import '../actions.dart';

class SubmitPost extends StatefulWidget {
  SubmitPost({Key key}) : super(key: key);

  @override
  _SubmitPostState createState() => _SubmitPostState();
}

class _SubmitPostState extends State<SubmitPost> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<int> _selectedTags = new List<int>();
  List<String> _tags = [
    'gluten-free',
    'peanut-free',
    'vegetarian',
    'vegan',
    'pork',
    'beef',
    'chicken'
  ];
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
    this._selectedTags.clear();
    setState(() {
      _image = null;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _submitResponse(String response) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(response),
            actions: <Widget>[
              FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
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
                  }),
              RaisedButton(
                  textColor: Colors.white,
                  child: Text('Submit'),
                  onPressed: () {
                    var accessToken = InheritedClient.of(context).accessToken;
                    List<String> tags = [];
                    for (int tagIndex in this._selectedTags) {
                      tags.add(this._tags[tagIndex]);
                    }
                    Client.get()
                        .post(
                            accessToken,
                            this.nameController.text,
                            this.descriptionController.text /**, this._image*/,
                            tags)
                        .then((res) {
                      // Todo: fix this POS
                      print(res);
                      Navigator.of(context).pop();
                      this._submitResponse(res.data['message']);
                      if (res.data['code'] == 1) {
                        this._clear();
                      }
                    });
                  }),
            ],
          );
        });
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
        Divider(color: Colors.grey, height: 0.0),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: 'Description',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(color: Colors.grey, height: 0.0),
        /* Padding(child: FlatButton(
          textColor: Colors.blue,
          child: Icon(Icons.add_a_photo),
          onPressed: getImage,
        ), padding: EdgeInsets.only(top: 15)),
        Center(
          child: _image == null ? Text('No image selected.') : Text('Image confirmed.')
        ), */
        Wrap(
            spacing: 2.0,
            runSpacing: 0.0,
            children: List<Widget>.generate(this._tags.length, (int index) {
              return ChoiceChip(
                  label: Text(this._tags[index]),
                  selected: this._selectedTags.contains(index),
                  onSelected: (bool selected) {
                    setState(() {
                      if (!this._selectedTags.contains(index)) {
                        this._selectedTags.add(index);
                      } else {
                        this._selectedTags.remove(index);
                      }
                    });
                  });
            })),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomRight,
            child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Row(children: [
                  FlatButton(
                      textColor: Colors.blue,
                      child: Text('Cancel'),
                      onPressed: () {
                        _clear();
                      }),
                  Spacer(flex: 1),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.lightBlue,
                    child: Text('Submit'),
                    onPressed: () {
                      _ensureSubmit();
                    },
                  ),
                ])),
          ),
        ),
      ],
    );
  }
}
