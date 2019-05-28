import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  bool _isScheduled = false;
  List<int> _selectedAllergens = new List<int>();
  List<String> _allergens = [
    'gluten',
    'dairy',
    'fish',
    'peanuts',
    'tree nuts',
    'wheat',
    'shellfish',
    'soy',
    'egg'
  ];
  //TODO: add tags ['vegetarian', 'vegan'] etc. see google drive
  File _image;

  Future getImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    setState(() {
      this._image = image;
    });
  }

  Future selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(postTime),
    );
    if (time != null && time != TimeOfDay.fromDateTime(postTime)) {
      setState(() {
        postTime = DateTime(postTime.year, postTime.month, postTime.day,
            time.hour, time.minute);
      });
    }
  }

  Future selectDay(BuildContext context) async {
    final day = await showDatePicker(
      context: context,
      initialDate: postTime,
      firstDate: DateTime.now()
          .subtract(Duration(hours: DateTime.now().hour)), //beginning of today
      lastDate: DateTime.now().add(
          Duration(days: 14)), //TODO: ask Lindsey how many weeks ahead can pick
    );
    if (day != null && day != postTime) {
      setState(() {
        postTime = day;
      });
    }
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
      Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
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
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
            : new Image.file(this._image, fit: BoxFit.fitWidth),
      ),
      TextField(
        controller: nameController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Event name',
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.symmetric(horizontal: 40,vertical: 20), //TODO: fix margins
        ),
      ),
      TextField(
        controller: descriptionController,
        keyboardType: TextInputType.multiline,
        maxLines: null, //expands as more lines added
        decoration: InputDecoration(
          icon: Icon(Icons.subject),
          hintText: 'Event description',
          contentPadding: EdgeInsets.symmetric(vertical:20),
        ),
      ),
      TextField(
        controller: locationController,
        decoration: InputDecoration(
          icon: Icon(Icons.location_on),
          hintText: 'Location',
          contentPadding: EdgeInsets.symmetric(vertical:20),
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
                child: Wrap(spacing: 2.0, runSpacing: 0.0, children: [
              for (var index = 0; index < this._allergens.length; index++)
                ChoiceChip(
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
                    })
            ])),
          ]),
          padding: EdgeInsets.all(15)),
      Container(
          padding: EdgeInsets.all(15.0),
          color: _isScheduled ? Theme.of(context).cardColor : Colors.white, //TODO: Why is this white different from all other whites?
          child: Column(children: [
            CheckboxListTile(
                value: _isScheduled,
                onChanged: (bool changed) {
                  setState(() {
                    _isScheduled = changed;
                  });
                  //print(changed);
                },
                title: Text(
                  "Schedule Post?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                controlAffinity: ListTileControlAffinity.leading),
            if (_isScheduled)
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                OutlineButton(
                  child: Text('Date: ${DateFormat.yMMMMd().format(postTime)}'),
                  onPressed: () => selectDay(context),
                ),
                OutlineButton(
                  child: Text('Time: ${DateFormat.jm().format(postTime)}'),
                  onPressed: () => selectTime(context),
                )
              ])
          ])),
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
                  child:
                      !_isScheduled ? Text('Post Now') : Text('Schedule Post'),
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
                      String alertMsg = "Please add the following field" +
                          (fields.length > 1 ? "s" : "") +
                          " to your post: ";
                      for (var i in fields) {
                        if (fields.length == 1) {
                          alertMsg += i + ".";
                          break;
                        }
                        alertMsg += (fields.elementAt(fields.length - 1) == i
                            ? "and " + i + "."
                            : i + ", ");
                      }
                      alertDialog(context, alertMsg);
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
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.white,
              height: 0,
            ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return items[index];
        });
  }
}

// alerts func
void alertDialog(BuildContext context, String alertMsg) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(alertMsg),
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
