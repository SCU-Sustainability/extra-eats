import 'package:flutter/material.dart';

import '../actions.dart';


class Register extends StatefulWidget {

  Register({Key key}): super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
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
        Padding(
          padding: EdgeInsets.all(32.0),
          child: Row(children: [
            Transform.scale(scale: 1.3, child: FlatButton(
              textColor: Colors.blue,
              child: Text('Login'),
              onPressed: () {
                Navigator.pop(context);
              }
            )),
            Spacer(flex: 1),
            Transform.scale(scale: 1.3, child: RaisedButton(
              textColor: Colors.white,
              color: Colors.lightBlue,  
              child: Text('Register'),
              onPressed: () {
                if (nameController.text == '' 
                  || passwordController.text == '' 
                  || emailController.text == '') {
                  return; // Show a dialog?
                }
                InheritedClient.of(context).register(nameController.text, passwordController.text, emailController.text);
                Navigator.pop(context);
              }
                
            )),
          ]
        )),
      ],
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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.0
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none,
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Register()
                ));
              }
            )),
            Spacer(flex: 1),
            Transform.scale(scale: 1.3, child: RaisedButton(
              textColor: Colors.white,
              color: Colors.lightBlue,  
              child: Text('Login'),
              onPressed: () {
                if (emailController.text == '' || passwordController.text == '') {
                  return; // Show a dialog?
                }
                InheritedClient.of(context).login(emailController.text, passwordController.text);
              }
                
            )),
          ]
        )),
      ],
    );
  }

}