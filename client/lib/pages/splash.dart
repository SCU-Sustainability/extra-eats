import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  Splash({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Transform.scale(child: IconButton(
          icon: Icon(Icons.phonelink_setup),
          onPressed: () {
          }
        ), scale: 2.0),
      ),
    );
  }
}