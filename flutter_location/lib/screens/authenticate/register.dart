import "package:flutter/material.dart";
import 'package:flutter_location/screens/authenticate/sign_in.dart';
import 'package:flutter_location/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView}) ;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String contact ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text("Sign Up"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign In"),
            onPressed: (){
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal:50.0),
        child: Form (
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height:10.0),
              TextFormField (
                decoration: InputDecoration(
                  hintText: "Email"
                ),
                validator: (val) => val.isEmpty ? "Please enter your Email": null,
                onChanged: (val){
                  
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height:10.0),
              TextFormField (
                decoration: InputDecoration(
                  hintText: "Password"
                ),
                obscureText: true,
                validator: (val) => val.length < 6 ? "Please enter a password with more than 6 char": null,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height:10.0),
              TextFormField (
                decoration: InputDecoration(
                  hintText: "Name"
                ),
                obscureText: false,
                
                onChanged: (val){
                  setState(() {
                    name = val;
                  });
                },
              ),
              SizedBox(height:10.0),
              TextFormField (
                decoration: InputDecoration(
                  hintText: "Contact"
                ),
                obscureText: false,
                
                onChanged: (val){
                  setState(() {
                    contact = val;
                  });
                },
              ),
              SizedBox(height:10.0),
              RaisedButton(
                color: Colors.pink,
                child: Text(
                  "Register",
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: () async{
                  if (_formkey.currentState.validate()){
                    print("Email:"+email);
                    print("Password:"+password);
                    dynamic user = await _auth.signUpWithEmailAndPassword(email, password,name,contact);

                    if(user == null){
                      setState(() {
                        error = 'Please enter correct details';
                      });
                    }
                    else{
                      print(user);
                    }

                  }
                  else{
                    print("Oops wrong credentials!");
                  }
                  
                },
                
              ),
              SizedBox(height:15.0),
              Text(
                error,
                style: TextStyle(fontSize: 14.0,color:Colors.red),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}