import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}



class _ChatState extends State<Chat> {
  
  var databaseReference;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _txtCtrl = TextEditingController();
  String userId ='';
  String date;
  _ChatState(){
    _getCurrentUser();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    
    String formattedDate = formatter.format(now);
    this.date = formattedDate;
    print("%%%%%%%%%%%%%%");
    print(formattedDate);
    var temp = FirebaseDatabase.instance.reference().child("chats").child(formattedDate);
    
    this.databaseReference = temp;
    
    
  }

  _getCurrentUser() async{
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;
  }

  sendMessage(){
    
    var mass = _txtCtrl.text;
    var now = new DateTime.now();
    var formatter = new DateFormat.Hms();
    
    String time = formatter.format(now);
    // print(time);
    // String s = time.toString();
    
    print(mass);
    var temp = {
      'message': mass,
      'userId' : userId,
    };
    try{
      FirebaseDatabase.instance.reference().child("chats").child(this.date).child(time).set(temp);
    }
    catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"),),

      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snap) {

          if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
              
              Map data = snap.data.snapshot.value;
              List item = [];
              print(data);
            data.forEach((key, value) {
              //  print(">>>>>>>>>>>>>>>>>>>>>");
              //  print(key);
              //  print(value);
              var temp = value;
              temp["date"]= date;
              temp["time"] = key;
              //  print(temp);
              if(value["userId"] == userId){
                temp["self"]="yes";
              }
              else{
                temp["self"]="no";
              }
              item.add(temp);
            });
            item.sort((a, b) => a["time"].compareTo(b["time"]));

              return ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {

                  if(item[index]['self']=="yes"){
                    return Card(
                      elevation: 8.0,
                      
                      margin: new EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:<Widget>[
                            
                            Text(
                            item[index]['message'],
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            
                            ), 
                              
                          ]),
                        )
                      ),
                    );
                  }
                else{
                  return Card(
                    elevation: 8.0,
                    
                    margin: new EdgeInsets.symmetric(horizontal: 40.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.pink),
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget>[
                          
                          Text(
                          item[index]['message'],
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          
                          ), 
                            
                        ]),
                      )
                    ),
                  );
                }
                });
          }
          else{
              return Text("No data");
          }
        }
      ),

      bottomNavigationBar: BottomAppBar(
        child:Row(children: <Widget>[
        Expanded(child: TextField(controller: _txtCtrl)),
        SizedBox(
            width: 80,
            child: OutlineButton(child: Text("Add"), onPressed: () => sendMessage()))
          ]),
        color: Colors.blue,
      ),
    );
  }
}