

import 'package:flutter/material.dart';
import 'package:flutter_location/screens/home/webCrawlerView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class ApiCall extends StatefulWidget {
  @override
  _ApiCallState createState() => _ApiCallState();
}

class _ApiCallState extends State<ApiCall> {

  final webview = FlutterWebviewPlugin();
  _ApiCallState(){
    getData();
  }
  

 
  List<String> urls = [];
   getData() async{
    http.Response response = await http.get(
      "https://aqueous-dusk-36487.herokuapp.com/web",

      );
      
     

      Map user = jsonDecode(response.body);

      user.forEach((key, value) { 
        setState(() {
          urls.add(value.toString());
        });
      });

      print(urls);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Latest News"),),

      body: Container(
        child: ListView.builder(
        itemCount: urls.length,
        itemBuilder: (context, index) {

          return  Card(
            elevation: 8.0,
            child:Container(
               decoration: BoxDecoration(color: Colors.blue[100]),
              child:Column(
              
              children: <Widget>[
                ListTile(
                  title: Text('${urls[index]}'),
                  trailing: FlatButton(onPressed: null, child: Text("Open")),
                  onTap: ()=>Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WebCrawlerView(urls[index])),
                                ),
                ),
              
              ],
            )
            )
          );

          // return Column(children: <Widget>
          // [
          //   ListTile(
          //     title: Text('${urls[index]}'),
              
          //   ),
          //   FlatButton(onPressed: null,
          //    child: Text("Open")),
          //   Divider()
            
          // ],);
        

        },
      )
    ,)
      // body: Container(child: Center(child:FlatButton(onPressed: getData, child: Text("Press Me"))),),
    );
  }
}


