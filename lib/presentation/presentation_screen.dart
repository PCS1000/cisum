import 'dart:async';
import 'package:cisum/root/auth.dart';
import 'package:cisum/root/root_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PresentationScreen extends StatefulWidget {
  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  Color bgColor = Color(0xFFEAEBF3);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 8),()=> Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___) => RootPage(auth: Auth(),bgColor: bgColor,))));
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() => setState(() {animationController.repeat();}));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: GestureDetector(
          onTap: (){
            if(bgColor == Theme.of(context).primaryColorDark){
              setState(() {
                bgColor = Color(0xFFEAEBF3);
              });
            } else {
               setState(() {
                 bgColor = Color(0xFF31373C);
               });
            }
          },
          child: bgColor == Theme.of(context).primaryColorDark ?
          _buttonPlayer2(
            height: 130,
            width: 130,
            height2: 120,
            width2: 120,
            isBigButton: true,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset('images/logo/logo.png'),
              ),
            ),
          ) :
          _buttonPlayer(
            height: 130,
            width: 130,
            height2: 120,
            width2: 120,
            isBigButton: true,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset('images/logo/logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonPlayer({double height,double width,double height2,double width2,IconData icon,bool isBigButton,Widget child}){
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF0F0F3),
        boxShadow: [
          BoxShadow(
            spreadRadius: 4,
            blurRadius: isBigButton == true ? 20 : 10,
            offset: isBigButton == true ? Offset(-16, -14) : Offset(-5, -7),
            color: Color(0xFFFFFFFF).withOpacity(isBigButton == true ? 0.70 : 0.80),
          ),
          BoxShadow(
            spreadRadius: 0,
            blurRadius: isBigButton == true ? 20 : 15,
            offset: isBigButton == true ? Offset(28, 15) : Offset(10, 10),
            color: Color(0xFFAEAEC0).withOpacity(isBigButton == true ? 0.20 : 0.40),
          ),
        ],
      ),
      child: Container(
        height: height2,
        width: width2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Color(0xFFF0F0F3),
              Color(0xFFFFFFFF),
            ],begin: Alignment.topLeft,end: Alignment.bottomRight)
        ),
        child: icon != null ? Icon(icon,color: Colors.black54,) : child,
      ),
    );
  }

  Widget _buttonPlayer2({double height,double width,double height2,double width2,IconData icon,bool isBigButton,Widget child}){
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColorDark,
        boxShadow: [
          BoxShadow(
            spreadRadius: 3,
            blurRadius: isBigButton == true ? 20 : 10,
            offset: isBigButton == true ? Offset(-17, -16) : Offset(-5, -7),
            color: Color(0xFF7F858A).withOpacity(isBigButton == true ? 0.1 : 0.15),
          ),
          BoxShadow(
            spreadRadius: 3,
            blurRadius: isBigButton == true ? 20 : 15,
            offset: isBigButton == true ? Offset(28, 15) : Offset(10, 10),
            color: Color(0xFF000000).withOpacity(isBigButton == true ? 0.15 : 0.2),
          ),
        ],
      ),
      child: Container(
        height: height2,
        width: width2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Color(0xFF3D444A),
              Color(0xFF31373C),
            ],begin: Alignment.topLeft,end: Alignment.bottomRight)
        ),
        child: icon != null ? Icon(icon,color: Colors.white,) : child,
      ),
    );
  }
}

