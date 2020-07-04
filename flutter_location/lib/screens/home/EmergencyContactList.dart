import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_location/screens/home/addContact.dart';
import 'package:flutter_location/screens/home/newContact.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'dart:async';
// import 'package:simple_permissions/simple_permissions.dart';

class EmergencyContactList extends StatefulWidget {
  @override
  _EmergencyContactListState createState() => _EmergencyContactListState();
}

class _EmergencyContactListState extends State<EmergencyContactList> {



  // //////////////////////////////////////////////////////////
  String _latestHardwareButtonEvent;

  StreamSubscription<HardwareButtons.VolumeButtonEvent> _volumeButtonSubscription;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<HardwareButtons.LockButtonEvent> _lockButtonSubscription;
  var count=0;



  @override
  void initState() {
    super.initState();
    volume();
    

    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'HOME_BUTTON';
      });
    });

    _lockButtonSubscription = HardwareButtons.lockButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'LOCK_BUTTON';
      });
    });
  }

  void volume(){
    _volumeButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = event.toString();
        print("in");
        count=count+1;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    _volumeButtonSubscription?.cancel();
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
  }















  // ///////////////////////////////////////

























































  String status;
  String contact ='';
  int totalContacts=0;
  // Permission permission;
  final _contactForm = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List userDetails =[];
  List userList;
  _EmergencyContactListState(){
    getUid();
  }

// void handleTimeout() {  // callback function

// }

// startTimeout([int milliseconds]) {
//   const TIMEOUT = const Duration(seconds: 10);
//   const ms = const Duration(milliseconds: 1);
//   var duration = milliseconds == null ? TIMEOUT : ms * milliseconds;
//   return new Timer(duration, handleTimeout);
// }


  void sendMessage() async {

    print("****************");
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
    Position currentLocation=  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var now = new DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    var date = DateTime(now.day,now.month,now.year);
    
    userList.forEach((element) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      Map temp = {
        'content' :'I am in an unusual situation. I have shared my location with you. Please Help! ',
        'lat': currentLocation.latitude,
        'long':currentLocation.longitude,
        'date': date.toString(),
        'time': time.toString(),
        'To': element,
        'From': userId,
        'seen' : "N"
      };
      String tempKey = databaseReference.child("emergencyMessage").child(element).push().key;
      databaseReference.child("emergencyMessage").child(element).child(tempKey).set(temp);
      databaseReference.child("users").child(userId).child("emergencyMessage").child("sent").push().set(tempKey);
      databaseReference.child("users").child(element).child("emergencyMessage").child("received").push().set(tempKey);
      
      
      
      

    });
    
  }

  
  void _emergencyMessage() async{
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
    
    try {
      
      databaseReference.child("users").child(userId).child("emergencyContact").once().then((DataSnapshot snapshot) {
        
      
         setState(() {
          print(snapshot.value);
          Map  x = snapshot.value;
          List temp = [];
          userList = [];
          x.forEach((key, value) { 
            temp.add(value);
          });

          databaseReference.child("users").once().then((DataSnapshot snapshot) {
            // print(snapshot.value);
            // print(temp);
            Map x= snapshot.value;
            x.forEach((key, value) {
              String tempContact = value["contact"];
              if (temp.contains(tempContact)){
                userList.add(key);
                // print("yeajjjjj");
              }

            });
          });
        });
      });
     
      // print(userList);
      sendMessage();
    }
    catch(e){
      print("Mo");
        userDetails = [];
    }
  }
  void _storeContact(String contact) async{
    try {
      final FirebaseUser user = await auth.currentUser();
      final userId = user.uid;
      final int pos = totalContacts +1;
      databaseReference.child("users").child(userId).child("emergencyContact").push().set(contact);
      userDetails.clear();
      getUid();
      
    }catch(e){
      print(e.toString());
      
    }
  }

   void getUid() async{

    print("Twitch");
    final FirebaseUser user = await auth.currentUser();
    final userid = user.uid;
    try {
      
      databaseReference.child("users").child(userid).child("emergencyContact").once().then((DataSnapshot snapshot) {
        
      
        setState(() {
          
          // var len1 = x.length;
          // totalContacts = len1-1;
          // var temp = x.getRange(1, len1);
          // userDetails = temp.toList();

          // print(userDetails);
          if (snapshot.value == null){
            userDetails = [];
          }
          else{
            print(snapshot.value);
            Map  x = snapshot.value;
            x.forEach((key, value) { 
              userDetails.add(value);
            });
            print("<<<<<<<<<<<<<");
            print(x);
          }
          
          


          
        });
      });
    }
    catch(e){
      print("Mo");
        userDetails = [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: new Center(
          child: new Text("Emergency Contacts"),
        ),
      ),
     body: new Column(
       children: <Widget>[
         new Expanded(
           child:new ListView.builder(
            itemCount: userDetails == null?  0: userDetails.length,
            itemBuilder: (BuildContext context,int index){
              return new Card(
                child: new Text(userDetails[index].toString()),
              );
              
            },
            physics: NeverScrollableScrollPhysics(),
          ),
         ),
         new RaisedButton(
          color: Colors.pink,
          child: Text(
            "Help",
            style: TextStyle(color:Colors.white),
          ),
          onPressed:() async{ 
            _emergencyMessage();
            },
         ),
         new Container(
            child: Form(
              key: _contactForm,
              child: Column(
                children: <Widget>[
                  SizedBox(height:10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Add Contact",
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width:2.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink,width:2.0)
                      ),
                    ),
                    validator: (val) => val.length<10 ? "Please enter proper Contact": null,
                    onChanged: (val){
                      
                      setState(() {
                        contact = val;
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
                      if (_contactForm.currentState.validate()){
                        
                        print(contact);
                        _storeContact(contact);
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
          
          Text('Value: $_latestHardwareButtonEvent\n'),
          Text('Count $count\n'),
       ],

       
     ),
    
    //  floatingActionButton: FloatingActionButton(
    //       onPressed: ()=>Navigator.push(
    //                         context,
    //                         MaterialPageRoute(builder: (context) => NewContact()),
    //                       ),
    //       // onPressed: ()=>{},
          
    //       tooltip: 'Add Emergency Contact',
    //       child: Icon(Icons.people),
    //   ),
    );
  }
}