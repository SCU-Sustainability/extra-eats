import 'package:flutter/material.dart';

class LogoutAction extends InheritedWidget {
  LogoutAction({Key key, @required this.logout, @required Widget child}): assert(logout != null), 
    assert(child != null),
    super(key: key, child: child);
  final VoidCallback logout;

  static LogoutAction of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(LogoutAction);
  }
  
  @override
  bool updateShouldNotify(LogoutAction old) => logout != old.logout;
}

class LoginAction extends InheritedWidget {
  LoginAction({Key key, @required this.login, @required Widget child}): assert(login != null), 
    assert(child != null),
    super(key: key, child: child);
  final VoidCallback login;

  static LoginAction of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(LoginAction);
  }
  
  @override
  bool updateShouldNotify(LoginAction old) => login != old.login;
}