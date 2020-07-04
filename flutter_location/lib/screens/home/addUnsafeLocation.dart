import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AddUnsafeLocation extends StatefulWidget {
  @override
  _AddUnsafeLocationState createState() => _AddUnsafeLocationState();
}

class _AddUnsafeLocationState extends State<AddUnsafeLocation> {

  final _unsafeLocationData = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref();
  var lat;
  var long;
  var isBar = "No";
  var fOfPeople ="Low";
  var isPolice = "No";
  var unsafeTime;
  var message;
  var postKey;
  var userId;
postToUnsafe() async{
    String url = 'https://secret-lake-00961.herokuapp.com/unsafe';
      Map<String, String> headers = {"Content-type": "application/json"};
      // String json = '{"frequencyOfPeople" : "Low","id":"-M71FAC16RuNUaFVtABJ","isBar" : "No","isPolice" : "No","lat" : 12,"long" : 72,"message" : "font go at night","unsafeHours" : "12","userId":"ghts"}';
      // String json = '{"frequencyOfPeople" : $fOfPeople,"id":$postKey,"isBar" : $isBar,"isPolice" : $isPolice,"lat" : $lat,"long" : $long,"message" : $message,"unsafeHours" : $unsafeTime,"userId":$userid}';
      Response response = await post(url, headers: headers, body: jsonEncode({"frequencyOfPeople" : fOfPeople,"id":postKey,"isBar" : isBar,"isPolice" : isPolice,"lat" : lat,"long" : long,"message" : message,"unsafeHours" : unsafeTime,"userId":userId}));

      // Map user = jsonDecode(response.body);

      print("&&&&&&&&&&&&&");
      print(response.body);
  }
  _storeDetails() async{
    
    var temp = {
      "lat":lat,
      "long":long,
      "isBar":isBar,
      "fOfPeople":fOfPeople,
      "isPolice":isPolice,
      "unsafeTime":unsafeTime,
      "message": message,
      "upvote":0,
      "downvote":0
          
      };

      

     
      // String json = '{"frequencyOfPeople" : "Low","id":"-M71FAC16RuNUaFVtABJ","isBar" : "No","isPolice" : "No","lat" : 12,"long" : 72,"message" : "font go at night","unsafeHours" : "12","userId":"ghts"}';
      
  
      // Map user = jsonDecode(response.body);

    final FirebaseUser user = await auth.currentUser();
    setState(() {
      
      final userid = user.uid;


      
      var key = databaseReference.child("UnsafeZone").child(userid).push();
      key.set(temp);
      postKey = key.key;
      userId=userid;
      postToUnsafe();
      
     
      // databaseReference.child("upvote").child(key.key).set(temp1);
      databaseReference.child("UnsafeZone").child(userid).child(key.key).child("upvoteUsers").push().set("10101101");
      databaseReference.child("UnsafeZone").child(userid).child(key.key).child("downvoteUsers").push().set("10101101");

      _unsafeLocationData.currentState?.reset();
    });
    // String url = 'https://secret-lake-00961.herokuapp.com/unsafe';
    // Map<String, String> headers = {"Content-type": "application/json"};
    // String json = '{"frequencyOfPeople" : $fOfPeople,"id":$postKey,"isBar" : $isBar,"isPolice" : $isPolice,"lat" : $lat,"long" : $long,"message" : $message,"unsafeHours" : $unsafeTime,"userId":$userid}';
    // // json = son.toString();
    //   print("@@@@@@@@@@@@@@@@@@@@@22222222");
    //   print(json);
    // Response response = await post(url, headers: headers, body: json);
    // print("&&&&&&&&&&&&&");
    // print(response.body);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Add Unsafe Location")
      ),

      body: SingleChildScrollView(
        child:Form(
          key: _unsafeLocationData,
          child:Column(
            children: <Widget>[

              TextFormField(
                      decoration: InputDecoration(
                        hintText: "Latitude",
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white,width:2.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink,width:2.0)
                        ),
                      ),
                      validator: (val) => val.isEmpty ? "Please enter the Latitude": null,
                      onChanged: (val){
                        
                        setState(() {
                          lat = val;
                        });
                      },
                    ),
              new Divider(),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Longitude",
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width:2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink,width:2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? "Please enter the Longitude": null,
                onChanged: (val){
                  
                  setState(() {
                    long = val;
                  });
                },
              ),
              new Divider(),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Unsafe Hours",
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width:2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink,width:2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? "Please enter the Details": null,
                onChanged: (val){
                  
                  setState(() {
                    unsafeTime = val;
                  });
                },
              ),
              new Divider(),
              Column(
                children: <Widget>[
                  Text("Frequency Of People in this Area"),
                  ListTile(
                    title: const Text('Low'),
                    leading:
                    new Radio(
                      
                      value: "Low",
                      groupValue: fOfPeople,
                      onChanged: (val){
                        setState(() {
                          fOfPeople = "Low";
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Medium'),
                    leading:
                    new Radio(
                      value:"Medium",
                      groupValue: fOfPeople,
                      onChanged: (val){
                        setState(() {
                          fOfPeople = "Medium";
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('High'),
                    leading:
                    new Radio(
                      value: "High",
                      groupValue: fOfPeople,
                      onChanged: (val){
                        setState(() {
                          fOfPeople = "High";
                        });
                      },
                    ),
                  ),

                ],
              ),
              new Divider(),
              Column(
                children: <Widget>[
                  Text("Is there a Bar Nearby"),
                  ListTile(
                    title: const Text('Yes'),
                    leading:
                    new Radio(
                      value: "Yes",
                      groupValue: isBar,
                      onChanged: (val){
                        setState(() {
                          isBar = "Yes";
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading:
                    new Radio(
                      value: "No",
                      groupValue: isBar,
                      onChanged: (val){
                        setState(() {
                          isBar = "No";
                        });
                      },
                    ),
                  ),
                ],
              ),
              new Divider(),
              Column(
                children: <Widget>[
                  Text("Is there a Police Station within 500 meters?"),
                  ListTile(
                  title: const Text('Yes'),
                  leading:
                    new Radio(
                      value: "Yes",
                      groupValue: isPolice,
                      onChanged: (val){
                        setState(() {
                          isPolice = "Yes";
                          
                        });
                      },
                    )
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading:
                    new Radio(
                      value: "No",
                      groupValue: isPolice,
                      onChanged: (val){
                        setState(() {
                          isPolice = "No";
                        });
                      },
                    ),
                  )
                ],
              ),

              new Divider(),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Message",
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder( 
                    borderSide: BorderSide(color: Colors.white,width:2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink,width:2.0)
                  ),
                ),
                validator: (val) => val.isEmpty ? "Please enter the Details": null,
                onChanged: (val){
                  
                  setState(() {
                    message = val;
                  });
                },
              ),
              RaisedButton(
                    color: Colors.pink,
                    child: Text(
                      "Add Contact",
                      style: TextStyle(color:Colors.white),
                    ),
                    onPressed: () async{
                      if (_unsafeLocationData.currentState.validate()){
                        
                        print("Yeaaaaaa");
                        _storeDetails();
                        
                      }
                      else{
                        print("Wrong Details");
                      }
                      
                    },
                    
                  ),
            ],
            
        ),
      ),
      ),
    );
  }
}