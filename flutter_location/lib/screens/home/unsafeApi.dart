

import 'package:flutter/material.dart';


import 'dart:async';

import 'package:http/http.dart';
import 'dart:convert';


class UnsafeApi extends StatefulWidget {
  @override
  _UnsafeApiState createState() => _UnsafeApiState();
}

class _UnsafeApiState extends State<UnsafeApi> {
  @override
  void initState() {
    postToUnsafe();
    super.initState();

    

  }
  postToUnsafe() async{
    String url = 'https://secret-lake-00961.herokuapp.com/unsafe';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"frequencyOfPeople" : "Low","id":"-M71FAC16RuNUaFVtABJ","isBar" : "No","isPolice" : "No","lat" : 12,"long" : 72,"message" : "font go at night","unsafeHours" : "12","userId":"ghts"}';
      Response response = await post(url, headers: headers, body: json);

      // Map user = jsonDecode(response.body);

      print("&&&&&&&&&&&&&");
      print(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("hi"),
    );
  }
}