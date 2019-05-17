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
                      if (passwordController.text == '' ||
                          emailController.text == '') {
                        return; // Show a dialog?
                      }
                      InheritedClient.of(context).register(
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
                      if (emailController.text == '' ||
                          passwordController.text == '') {
                        return; // Show a dialog?
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
