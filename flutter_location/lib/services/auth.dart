import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_location/models/user.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  // crate user object based on firebase user

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid : user.uid):null;
  }

  // auth chnge user stream 
  Stream <User> get user{
    return _auth.onAuthStateChanged
    .map((FirebaseUser user)=>_userFromFirebaseUser(user));
  }

  // sign in Anonymously
  Future signInAnon() async {
    try {
      AuthResult user= await _auth.signInAnonymously();
       
      return _userFromFirebaseUser(user.user);
    }
    catch(e){
      print(e.toString());
      return Null;
    }
  }

  // sign in with email and password

  Future signInWithEmailAndPassword(email,password) async{
    try {
      AuthResult user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
       
      return _userFromFirebaseUser(user.user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

 

  //reg with email and pass
   Future signUpWithEmailAndPassword(email,password,name,contact) async {

    try {
      AuthResult user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String userId = user.user.uid;
      print("______________");
      print(userId);
      databaseReference.child("users").child(userId).set({
        'email': email,
        'name' : name,
        'contact':contact
      });
      return _userFromFirebaseUser(user.user);
    }catch(e){
      print(e.toString());
      return null;
    }
    


  }
  // signout
  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
} 