import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_location/screens/home/addContact.dart';
import 'package:flutter_location/screens/home/emergencyMessageDetails.dart';
import 'package:flutter_location/screens/home/newContact.dart';


class EmergencyMessage extends StatefulWidget {
  @override
  _EmergencyMessageState createState() => _EmergencyMessageState();
}

class _EmergencyMessageState extends State<EmergencyMessage> {

  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List messageListUnseen =[] ;
  List messageListSeen =[];
  //  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _getMessageList();
  //   print(messageListUnseen);
  //   print(messageListSeen);

  // }

  
 
  void _getMessageList() async{

    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;
   
    databaseReference.child("emergencyMessage").child(userId).once().then((DataSnapshot snapshot) {
      setState(() {
        Map x = snapshot.value;
        print(".....................................................");
        print(x);
        
          if (x != null){
            x.forEach((key, value) {
              if (value["seen"]== "Y"){
                messageListSeen.add(value);

              }
              else{
                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

                // print(value);
                messageListUnseen.add(value);
              }
            });
          }
          else{
            messageListSeen =[];
            messageListUnseen =[];
          }
        });
    print(messageListUnseen);
    print(messageListSeen);
        
      
    });

  

  }

  _EmergencyMessageState() {
    
    _getMessageList();
    

    



  }

  List l1 = [{'name':"Deepika","surname":"Pomendkar"},{'name':"Smita",'surname':"pomendkar"}];
  @override
  Widget build(BuildContext context) {
    
    
    //   return new Scaffold(
    //     appBar: AppBar(title: Text("Emergency Contacts")),
    //     body: new Container(
    //       child: ListView.separated(
    //         itemCount: messageListUnseen.length,
    //         itemBuilder: (context, index) {
    //           return new Container(

    //             child: new Column(
    //               children: <Widget>[
    //                 new ListTile(
    //                 title: Text(messageListUnseen[index]["content"]),
    //               ),
    //                 new ListTile(
    //                 title: Text(messageListUnseen[index]["From"]),
    //               ),
    //               new ListTile(
    //                 title: Text(messageListUnseen[index]["To"]),
    //               ),
    //               new ListTile(
    //                 title: Text(messageListUnseen[index]["date"]),
    //               ),
    //               new ListTile(
    //                 title: Text(messageListUnseen[index]["time"]),
    //               ),
    //               new ListTile(
    //                 title: Text(messageListUnseen[index]["date"]),
    //               ),
    //               new ListTile(
    //                 title: Text(messageListUnseen[index]["lat"].toString()),
    //               ),
    //               new ListTile(
    //                 title: Text(messageListUnseen[index]["long"].toString()),
    //               ),
    //               ],
    //             ),
    //           );
              
             
    //         },
    //         separatorBuilder: (context, index) {
    //           return Divider();
    //         },
    //       ),
    //     ),
      
    // );





    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Messages"),
      ),
      body: new Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: messageListUnseen.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                      border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24)
                      )
                    ),
                    child: Icon(Icons.autorenew, color: Colors.white),
                  ),
                  title: Text(
                    "From:- "+messageListUnseen[index]['From'],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      Icon(Icons.linear_scale, color: Colors.yellowAccent),
                      Text("Latitude   :-"+messageListUnseen[index]["lat"].toString()+"\n"+"Longitude:-"+messageListUnseen[index]["long"].toString(), style: TextStyle(color: Colors.white))
                    ],
                  ),
                  trailing:
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0,),
                      onPressed: ()=>Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MessageDetails(messageListUnseen[index]["content"],
                                                                               messageListUnseen[index]["From"],
                                                                               messageListUnseen[index]["date"],
                                                                               messageListUnseen[index]["time"],
                                                                               messageListUnseen[index]["lat"].toString(),
                                                                               messageListUnseen[index]["long"].toString()
                        ),
                        ),
                      ),
                    ),
                ),
              ),
            );
          }
        )
      )
    );
  }
}