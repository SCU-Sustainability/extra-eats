import 'package:flutter/material.dart';

class InheritedClient extends InheritedWidget {
  InheritedClient(
      {Key key,
      @required this.login,
      @required this.logout,
      @required this.register,
      @required this.accessToken,
      @required this.userId,
      @required Widget child})
      : assert(login != null),
        assert(logout != null),
        super(key: key, child: child);

  final VoidCallback logout;
  final Function(String, String) login;
  final Function(String, String, String, bool) register;
  final String userId;
  final String accessToken;

  static InheritedClient of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedClient);
  }

  @override
  bool updateShouldNotify(InheritedClient old) {
    return (old.login != login) &&
        (old.logout != logout) &&
        (old.register != register) &&
        (old.accessToken != accessToken) &&
        (old.userId != userId);
  }
}

// Deprecated
class GoogleLoginAction extends InheritedWidget {
  GoogleLoginAction({Key key, @required this.login, @required Widget child})
      : assert(login != null),
        assert(child != null),
        super(key: key, child: child);
  final VoidCallback login;

  static GoogleLoginAction of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(GoogleLoginAction);
  }

  @override
  bool updateShouldNotify(GoogleLoginAction old) => login != old.login;
}
