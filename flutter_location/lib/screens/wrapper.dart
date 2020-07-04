import "package:flutter/material.dart";
import 'package:flutter_location/models/user.dart';
import 'package:flutter_location/screens/authenticate/authenticate.dart';
import 'package:flutter_location/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    // return either home or authenticate widdget
    if( user == null){
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}