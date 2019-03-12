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
  DateTime expiration = DateTime.now().add(Duration(hours: 1));
  List<int> _selectedAllergens = new List<int>();
  List<String> _allergens = [
    'gluten',
    'peanuts',
    'dairy',
    'fish',
    'mixed nuts',
    'wheat',
    'shellfish',
    'soy'
  ];
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._image = image;
    });
  }

  Future selectExpiration(BuildContext context) async {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        expiration = date;
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
                            this.expiration,
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
    var items = [
      Padding(
        child: Center(
            child: _image == null
                ? Padding(
                    child: FlatButton(
                      textColor: Colors.brown[300],
                      child: Icon(Icons.add_a_photo),
                      onPressed: getImage,
                    ),
                    padding: EdgeInsets.all(20))
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
      InkWell(
          child: Padding(
              child: Column(children: [
                Text('Expires on ${expiration.month}/${expiration.day}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                Text('@ ${expiration.hour}:${expiration.minute}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200))
              ]),
              padding: EdgeInsets.all(15.0)),
          onTap: () => selectExpiration(context)),
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

      Center(
        child: Padding(
            child: Row(
              children: [
                FlatButton(
                    textColor: Colors.brown,
                    child: Text('Cancel'),
                    onPressed: () {
                      _clear();
                    }),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.brown[300],
                  child: Text('Submit'),
                  onPressed: () {
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
