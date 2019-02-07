import 'package:flutter/material.dart';
import '../actions/user_actions.dart';

class Register extends StatefulWidget {
  Register({Key key}): super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register')
      ),
    );
  }
}

class Login extends StatefulWidget {

  Login({Key key}): super(key: key);


  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
        Padding(
          padding: EdgeInsets.all(32.0),
          child: Row(children: [
            Transform.scale(scale: 1.3, child: FlatButton(
              textColor: Colors.blue,
              child: Text('Register'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
              }
            )),
            Spacer(flex: 1),
            Transform.scale(scale: 1.3, child: RaisedButton(
              textColor: Colors.white,
              color: Colors.lightBlue,  
              child: Text('Login'),
              onPressed: LoginAction.of(context).login
            )),
          ]
        )),
      ],
    );
  }

}