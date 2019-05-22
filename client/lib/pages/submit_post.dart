import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  TextEditingController locationController = TextEditingController();
  DateTime postTime = DateTime.now();
  //DateTime expiration = );
  bool _isScheduled = false;
  List<int> _selectedAllergens = new List<int>();
  List<String> _allergens = [
    'gluten',
    'dairy',
    'fish',
    'peanuts',
    'treenuts',
    'wheat',
    'shellfish',
    'soy',
    'egg'
  ];
  File _image;

  Future getImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    setState(() {
      this._image = image;
    });
  }

  Future selectPostTime(BuildContext context) async {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        postTime = date;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _clear() {
    nameController.clear();
    descriptionController.clear();
    locationController.clear();
    this._selectedAllergens.clear();
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
                  child: Text('OK'), onPressed: Navigator.of(context).pop)
            ],
          );
        });
  }

  Future<void> _ensureSubmit() async {
    var accessToken = InheritedClient.of(context).accessToken;
    List<String> tags = [];
    for (int tagIndex in this._selectedAllergens) {
      tags.add(this._allergens[tagIndex]);
    }
    Client.get()
        .post(
            accessToken,
            this.nameController.text,
            this.descriptionController.text,
            this._image,
            this.locationController.text,
            this.postTime,
            this.postTime.add(Duration(minutes: 30)), //expiry
            tags,
            this._isScheduled)
        .then((res) {
      this._submitResponse(res.data['message']).then((void next) {
        Navigator.of(context).pop();
      });
      if (res.data['code'] == 1) {
        this._clear();
      }
    });
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: LinearProgressIndicator(value: null),
              titlePadding: EdgeInsets.all(30));
        });
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      Padding(
        child: Center(
            //if no image yet then show upload buttons, otherwise show image.
            child: _image == null
                ? Row(children: <Widget>[
                    OutlineButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.add_a_photo),
                        onPressed: () => getImage(ImageSource.camera)),
                    OutlineButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.add_photo_alternate),
                        onPressed: () => getImage(ImageSource.gallery))
                  ], mainAxisAlignment: MainAxisAlignment.center)
                : new Image.file(this._image, fit: BoxFit.fitWidth)),
        padding: EdgeInsets.all(20),
      ),

      TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: 'Event name',
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
        ),
      ),
      // Divider(color: Colors.grey, height: 0.0),
      TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: 'Event description',
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
        ),
      ),

      TextField(
        controller: locationController,
        decoration: InputDecoration(
          hintText: 'Location',
          hintStyle: TextStyle(fontWeight: FontWeight.w300),
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
        ),
      ),
      Padding(
          child: Column(children: [
            Center(
              child: Padding(
                child: Text(
                  'Allergens',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                padding: EdgeInsets.all(15),
              ),
            ),
            Center(
              child: Wrap(
                  spacing: 2.0,
                  runSpacing: 0.0,
                  children: List<Widget>.generate(this._allergens.length,
                      (int index) {
                    return ChoiceChip(
                        label: Text(this._allergens[index]),
                        selected: this._selectedAllergens.contains(index),
                        onSelected: (bool selected) {
                          setState(() {
                            if (!this._selectedAllergens.contains(index)) {
                              this._selectedAllergens.add(index);
                            } else {
                              this._selectedAllergens.remove(index);
                            }
                          });
                        });
                  })),
            ),
          ]),
          padding: EdgeInsets.all(15)),
      InkWell(
          child: Padding(
              child: Column(children: [
                CheckboxListTile(
                    value: _isScheduled,
                    onChanged: (bool changed) {
                      setState(() {
                        _isScheduled = changed;
                      });
                      //print(changed);
                    },
                    title: Text("Schedule Post?"),
                    controlAffinity: ListTileControlAffinity.leading),

                Text(
                    'Post at ${postTime.month}/${postTime.day}/${postTime.year}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: _isScheduled ? Colors.black : Colors.white)),
                        //TODO: background color to make it look clickable

                Text('@ ${postTime.hour}:${postTime.minute}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: _isScheduled ? Colors.black : Colors.white))
              ]),
              padding: EdgeInsets.all(15.0)),
          onTap: !_isScheduled ? null : () => selectPostTime(context)),
      Center(
        child: Padding(
            child: Row(
              children: [
                FlatButton(
                    textColor: Theme.of(context).errorColor,
                    child: Text('Cancel'),
                    onPressed: () {
                      _clear();
                    }),
                RaisedButton(
                  textColor: Colors.white,
                  child: !_isScheduled
                      ? Text('Submit Now')
                      : Text('Schedule Post'),
                  onPressed: () {
                    // when a post does not have all necessary fields,
                    // will give a list of what fields the post is missing
                    Set<String> fields = {};
                    if (nameController.text == '') {
                      fields.add('name');
                    }
                    if (descriptionController.text == '') {
                      fields.add('description');
                    }
                    if (_image == null) {
                      fields.add('photo');
                    }
                    if (locationController.text == '') {
                      fields.add("location");
                    }
                    if (fields.length != 0) {
                      String alert_msg = "Please add the following field" +
                          (fields.length > 1 ? "s" : "") +
                          " to your post: ";
                      for (var i in fields) {
                        if (fields.length == 1) {
                          alert_msg += i + ".";
                          break;
                        }
                        alert_msg += (fields.elementAt(fields.length - 1) == i
                            ? "and " + i + "."
                            : i + ", ");
                      }
                      alertDialog(context, alert_msg);
                      return;
                    }
                    _ensureSubmit();
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            padding: EdgeInsets.only(bottom: 32)),
      ),
    ];
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return items[index];
        });
  }
}

// alerts func
void alertDialog(BuildContext context, String alert_msg) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(alert_msg),
        //content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
