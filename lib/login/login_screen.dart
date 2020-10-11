import 'package:cisum/custom_icons/custom_icons_icons.dart';
import 'package:cisum/home/player.dart';
import 'package:cisum/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {

  final VoidCallback onSignedIn;

  LoginScreen({this.onSignedIn});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  static final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context){
    var data = MediaQuery.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model){
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: data.size.height / 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cursorColor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100.0),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                child: SvgPicture.asset(
                                  'images/other/login.svg',
                                  height: 250,
                                  width: data.size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 25,left: 30,bottom: 10),
                                child: Text(
                                  "Sign In",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.85,
                                    fontFamily: 'WinterSans',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(30.0, 0.0, data.size.width / 2.5, 0.0),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).cursorColor,
                                    letterSpacing: 1.0,
                                    fontFamily: 'WinterSans',
                                  ),
                                  focusNode: _emailFocus,
                                  onFieldSubmitted: (String value) {
                                    if (value != null || value.isNotEmpty) {
                                      FocusScope.of(context).requestFocus(_passwordFocus);
                                    }
                                  },
                                  validator: (String value) {
                                    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value) ||
                                        value.isEmpty ||
                                        value == null)
                                      return "Email Inválido";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 18.0),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).cursorColor,)),
                                    hintText: "Email",
                                    prefixIcon: Icon(
                                      CustomIcons.mail_4,
                                      color: Theme.of(context).cursorColor,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).cursorColor,
                                      letterSpacing: 1.0,
                                      fontFamily: 'WinterSans',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(30.0, 20.0, data.size.width / 2.5, 0.0),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).cursorColor,
                                    letterSpacing: 1.0,
                                    fontFamily: 'WinterSans',
                                  ),
                                  validator: (String value) {
                                    if (value.length <= 5 || value.isEmpty || value == null)
                                      return 'Invalid Password';
                                    else
                                      return null;
                                  },
                                  focusNode: _passwordFocus,
                                  obscureText: _passwordVisible,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 18.0),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).cursorColor,)),
                                    hintText: "Password",
                                    prefixIcon: Icon(
                                      CustomIcons.lock_2,
                                      color: Theme.of(context).cursorColor,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).cursorColor,
                                      letterSpacing: 1.0,
                                      fontFamily: 'WinterSans',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Theme.of(context).cursorColor,
                                        size: 18.0,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).cursorColor,
                                  ),
                                  child: FlatButton(
                                    onPressed: () => validateFirebaseLogin(),
                                    child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 20,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading == true ? Container(color: Colors.black54.withOpacity(0.2),child: Center(child: CircularProgressIndicator())) : Container(),
            ],
          ),
        );
      })
    );
  }
  void showSnackBarOnFail(){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).cursorColor,
        content: Container(
          margin: EdgeInsets.fromLTRB(35.0, 5.0, 0.0, 5.0),
          child: Text("Failed to load\nTry again Later",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontFamily: "Bobbleboddy",
              letterSpacing: 1.5,
            ),
          ),
        ),
      duration: Duration(seconds: 2),
      )
    );
  }

  void validateFirebaseLogin() async {
    try{
      setState(() {
        _isLoading = true;
      });
      FirebaseUser user  = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((user) => user.user);
      await UserModel.of(context).loadCurrentUser();
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___) => Player()));
      print("Signed In: ${user.uid}");
    } catch (e){
      setState(() {
        _isLoading = false;
      });
      print(e);
      print("Fail to Log In");
      showSnackBarOnFail();
    }
  }
}
