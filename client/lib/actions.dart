import 'package:flutter/material.dart';

class ClientAction extends InheritedWidget {
  ClientAction({Key key, @required this.login, @required this.logout, @required Widget child}): assert(login != null),
    assert(logout != null),
    super(key: key, child: child);
  final VoidCallback logout;
  final Function(String, String) login;

  static ClientAction of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ClientAction);
  }

  @override
  bool updateShouldNotify(ClientAction old) {
    return (old.login != login) && (old.logout != logout);
  }
}

class GoogleLoginAction extends InheritedWidget {
  GoogleLoginAction({Key key, @required this.login, @required Widget child}): assert(login != null), 
    assert(child != null),
    super(key: key, child: child);
  final VoidCallback login;

  static GoogleLoginAction of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(GoogleLoginAction);
  }
  
  @override
  bool updateShouldNotify(GoogleLoginAction old) => login != old.login;
}