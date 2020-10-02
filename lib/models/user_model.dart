import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();

  bool isloading = false;

  String verificationId;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadCurrentUser();
  }

  void signUpEMailAndPassword({Map<String,dynamic> userData,String pass,VoidCallback onSuccess,VoidCallback onFail}) {

    isloading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass,
    ).then((user) async {

      firebaseUser = user.user;

      await saveUserData(userData);

      onSuccess();
      isloading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      print(e);
      isloading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email,@required String pass,@required VoidCallback onSuccess,@required VoidCallback onFail}) async {

    isloading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    ).then((user) async {

      await loadCurrentUser();

      firebaseUser = user.user;

      onSuccess();
      isloading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      print(e);
      isloading = false;
      notifyListeners();
    });
  }

  bool loggedIn() {
    return FirebaseUser != null;
  }

  Future<Null> loadCurrentUser() async {
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;

        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future<Null> saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }
}
