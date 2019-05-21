import 'package:flutter/material.dart';

import '../actions.dart';

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
      Text(
        'Extra Eats',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 45),
      ),
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
                    textColor: Theme.of(context).errorColor,
                    child: Text('Go back'),
                    onPressed: () {
               this.setIndex(0);
                    })),
            Spacer(flex: 1),
            Transform.scale(
                scale: 1.3,
                child: RaisedButton(
                    textColor: Colors.white,
                    child: Text('Register'),
                    onPressed: () {
                     //alert msgs
		     if(emailController.text == '' && passwordController.text.length <= 5){
			String alert_msg = "Please enter your email and a password with 6 characters or more";
			alertDialog(context, alert_msg);
			passwordController.clear();			
			return;
			}
		     if(emailController.text == '') {
			String alert_msg = "Please enter your email.";
			alertDialog(context, alert_msg);
                        passwordController.clear();
		        return; 
                      }
		    if (!emailController.text.contains("scu.edu")){
			 String alert_msg = "Please enter your scu.edu email.";
			 alertDialog(context, alert_msg);
			 emailController.clear();
			 passwordController.clear();
			 return;
			}
       
                      if (passwordController.text.length <= 5){
				String alert_msg = "Please enter a password with 6 characters or more.";
				alertDialog(context, alert_msg);
				passwordController.clear();
				emailController.clear();
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        textColor: Colors.white,
                        child: Padding(
                          child: Text('I just want food',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300)),
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () {
                          this.setIndex(1);
                          this._provider = false;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        textColor: Colors.white,
                        child: Padding(
                            child: Text('I\'m an event planner',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w300)),
                            padding: EdgeInsets.all(15)),
                        onPressed: () {
                          this.setIndex(1);
                          this._provider = true;
                        }),
                  )
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
      Text(
        'Extra Eats',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 45),
      ),
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
                child: OutlineButton(
                    textColor: Theme.of(context).primaryColor,
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
				passwordController.clear();
				return;
			}
                      if (passwordController.text == '') {
                        	String alert_msg = "Please enter your password.";
				alertDialog(context, alert_msg);
				emailController.clear();
				return; 
                      }

		      // dart has some pretty subpar async future types
		      // so this is me dealing with that

		      // in main.dart there's a login func and _login func 
		      // which i changed to return false when there's a login error
		      // use .then because login func is async, so you have to wait until 
		      // a value is returned, then you can call alertDialog
			InheritedClient.of(context).login(emailController.text, 
				passwordController.text).then((value){
					if(!value){
						String alert_msg = "Invalid password/email combination.";
						alertDialog(context, alert_msg);
						passwordController.clear();
						emailController.clear();
					}
			        });
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
