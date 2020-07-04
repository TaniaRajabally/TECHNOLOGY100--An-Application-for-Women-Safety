import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class QrScan extends StatefulWidget {
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {

  _QrScanState(){
    // _setDat();
    _getDriverDetails();
  }
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List driverDetails =[];
  var detDict ={};
  String userId ='';

  _setDat() async{
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
     var temp= {
            'name':"Pokemon",
            'driverId': "12345tr67",
            'contact': '9876543210'
          };
          setState(() {
            databaseReference.child("users").child(userId).child("qrScans").set(temp);
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            driverDetails =[];
          });
  }
  _getDriverDetails() async{
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
    try {
      databaseReference.child("users").child(userId).child("qrScans").once().then((DataSnapshot snapshot) {

        var temp = snapshot.value;

        if (snapshot.value ==null){
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            setState(() {
              driverDetails.clear();
            });
            
        }
        else{
            setState(() {
              driverDetails.clear();
              driverDetails.add(temp);
            });
        }
      });
    }
    catch(e){
      setState(() {
        driverDetails =[];
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      });
    }


  }


  _deleteTravel() async{
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
    setState(() {
      databaseReference.child("users").child(userId).child("qrScans").remove();
      
    });
    _getDriverDetails();
    

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Qrcode Scanner Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              new Text("Ongoing Ride Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
              new Expanded(child: 
                new ListView.builder(
                  scrollDirection: Axis.vertical,
                itemCount: driverDetails == null?  0: driverDetails.length,
                itemBuilder: (BuildContext context,int index){
                  return new Card(
                    child: new Column(
                      children: <Widget>[
                         new Text("Driver Name:"+driverDetails[index]["name"]+"\n"+"Registered Id:"+driverDetails[index]["driverId"]+'\n'+"Contacts:"+driverDetails[index]["contact"]),
                         new Center(
                           child: RaisedButton(onPressed: _deleteTravel, child: Text("Journey Complete ")),
                         )
                      ],
                    ),

                  
                  );
                  
                },
                physics: NeverScrollableScrollPhysics(),
              ),
              
            ),
            Divider(
            thickness: 3.0,
            color: Colors.black,
            ),
            Center(
              child:new Text("Add new Ride Details.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0))
            ),
            // Text('RESULT  $barcode'),
            RaisedButton(onPressed: _scan, child: Text("Scan")),
            // 
            // RaisedButton(onPressed: _scan, child: Text("Scan")),
            // RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
            // RaisedButton(onPressed: _generateBarCode, child: Text("Generate Barcode")),


            
              
            ],
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;
    String barcode = await scanner.scan();

    Alert();
    setState(() {
      this.barcode = barcode;
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(this.barcode);



      var temp = (this.barcode).split(" ");

      var name = temp[0]+" "+temp[1];
      var driverId = temp[2];
      var contact = temp[3];
      print(driverId);
      var tempDict ={
        'name':name,
        'driverId':driverId,
        'contact': contact,
      };
      this.detDict = tempDict;

    databaseReference.child("users").child(userId).child("qrScans").set(temp);
    });
    
  }


  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }

  // Future _generateBarCode() async {
  //   Uint8List result = await scanner.generateBarCode('https://github.com/leyan95/qrcode_scanner');
  //   this.setState(() => this.bytes = result);
  // }
  Future<void> Alert() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add new travel.'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Previous travel details will be deleted.'),
              
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              setState(() {
                databaseReference.child("users").child(userId).child("qrScans").set(detDict);
                _getDriverDetails();
                Navigator.of(context).pop();
              });
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              
            },
          ),
        ],
      );
    },
  );
}

 
}

