import 'package:cisum/home/home.dart';
import 'package:cisum/home/player.dart';
import 'package:cisum/login/login_screen.dart';
import 'package:cisum/root/auth.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  final Color bgColor;
  RootPage({this.auth,this.bgColor});

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginScreen(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return Player(bgColor: widget.bgColor,);
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}