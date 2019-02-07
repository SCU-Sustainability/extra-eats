import 'package:flutter/material.dart';
import '../actions/user_actions.dart';

class Splash extends StatelessWidget {
  Splash({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Transform.scale(child: IconButton(
          icon: Icon(Icons.phonelink_setup),
          onPressed: () {
            GoogleLoginAction.of(context).login();
          }
        ), scale: 2.0),
      ),
    );
  }
}