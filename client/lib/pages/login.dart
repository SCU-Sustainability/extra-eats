import 'package:flutter/material.dart';

import '../actions.dart';

import '../data/alerts.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  int _index = 0;
  bool _provider = false;

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void setIndex(int index) {
    setState(() {
      this._index = index;
    });
  }

  Widget registerForm() {
    var items = [
      Image(image: AssetImage('assets/logo.png'), width: 200.0, height: 200.0),
      Divider(color: Colors.white, height: 5.0),
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.all(20.0),
          border: InputBorder.none,
        ),
      ),
      Divider(color: Colors.grey, height: 0.0),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.all(20.0),
          border: InputBorder.none,
        ),
      ),
      Divider(color: Colors.grey, height: 0.0),
      TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: 'Name (optional)',
          contentPadding: EdgeInsets.all(20.0),
          border: InputBorder.none,
        ),
      ),
      Divider(color: Colors.grey, height: 0.0),
      Padding(
          padding: EdgeInsets.all(32.0),
          child: Row(children: [
            Transform.scale(
                scale: 1.3,
                child: FlatButton(
                    textColor: Colors.brown[300],
                    child: Text('Go back'),
                    onPressed: () {
               this.setIndex(0);
                    })),
            Spacer(flex: 1),
            Transform.scale(
                scale: 1.3,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.brown[300],
                    child: Text('Register'),
                    onPressed: () {
                     //alert msgs
		     if(emailController.text == '' && passwordController.text.length <= 5){
			String alert_msg = "Please enter your email and a password with 6 characters or more";
			alertDialog(context, alert_msg);
			return;
			}
		     if(emailController.text == '') {
			String alert_msg = "Please enter your email.";
			alertDialog(context, alert_msg);
                        return; 
                      }
       
                      if (passwordController.text.length <= 5){
				String alert_msg = "Please enter a password with 6 characters or more.";
				alertDialog(context, alert_msg);
				return;
			}  InheritedClient.of(context).register(
                          nameController.text,
                          passwordController.text,
                          emailController.text,
                          this._provider);
                      Navigator.pop(context);
                    })),
          ])),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return items[index];
                }),
            padding: EdgeInsets.only(top: 50)));
  }

  @override
  Widget build(BuildContext context) {
    return this._index == 1
        ? registerForm()
        : Scaffold(
            appBar: AppBar(title: Text('Select an account type')),
            body: Container(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  FlatButton(
                      textColor: Colors.brown,
                      child: Text('I want food',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300)),
                      onPressed: () {
                        this.setIndex(1);
                        this._provider = false;
                      }),
                  RaisedButton(
                      textColor: Colors.white,
                      color: Colors.brown[300],
                      child: Padding(
                          child: Text('I\'m an event planner',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300)),
                          padding: EdgeInsets.all(15)),
                      onPressed: () {
                        this.setIndex(1);
                        this._provider = true;
                      })
                ]))));
  }
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

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
    var items = [
      Image(image: AssetImage('assets/logo.png'), width: 200.0, height: 200.0),
      Divider(color: Colors.white, height: 5.0),
      TextField(
        controller: emailController,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.all(20.0),
            border: InputBorder.none),
      ),
      Divider(color: Colors.grey, height: 0.0),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.all(20.0),
          border: InputBorder.none,
        ),
      ),
      Divider(color: Colors.grey, height: 0.0),
      Padding(
          padding: EdgeInsets.all(32.0),
          child: Row(children: [
            Transform.scale(
                scale: 1.3,
                child: FlatButton(
                    textColor: Colors.brown[300],
                    child: Text('Register'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    })),
            Spacer(flex: 1),
            Transform.scale(
                scale: 1.3,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.brown[300],
                    child: Text('Login'),
                    onPressed: () {
             	    
		    //alert msgs
		    if (emailController.text == '' && passwordController.text == ''){
				String alert_msg = "Please enter your registered email and password";
				alertDialog(context, alert_msg);
				return;
			}
                      if (emailController.text == ''){
				String alert_msg = "Please enter your email.";
				alertDialog(context, alert_msg);
				return;
			}
                      if (passwordController.text == '') {
                        	String alert_msg = "Please enter your password.";
				alertDialog(context, alert_msg);
				return; 
                      }

                       InheritedClient.of(context)
                          .login(emailController.text, passwordController.text);
                    })),
          ])),
    ];

    return Padding(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return items[index];
            }),
        padding: EdgeInsets.only(top: 50));
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
          //content: new Text("Alert Dialog body"), //used for a body in the msg
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
