import "package:flutter/material.dart";
import 'package:flutter_location/screens/authenticate/register.dart';
import 'package:flutter_location/services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({this.toggleView}) ;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
   
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text("Sign In"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign Up"),
            onPressed: (){
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal:50.0),
        child: Form (
          key: _formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height:10.0),
              TextFormField (
                decoration: InputDecoration(
                  hintText: "Email",
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width:2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink,width:2.0)
                  )
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
                  hintText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:BorderSide(width:2.0,color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:BorderSide(width:2.0,color: Colors.pink)
                  )
                ),

              
                obscureText: true,
                validator: (val) => val.isEmpty ? "Please enter your Password": null,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height:10.0),
              RaisedButton(
                color: Colors.pink,
                child: Text(
                  "Sign In",
                  style: TextStyle(color:Colors.white),
                ),
                onPressed: () async{
                  if (_formkey.currentState.validate()){
                    print("Email:"+email);
                    print("Password:"+password);
                    dynamic user = await _auth.signInWithEmailAndPassword(email, password);

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
      Center(
        child: Text("Your Safety Matters to Us..."),
      ),
      
      ],)
    );
  }
}