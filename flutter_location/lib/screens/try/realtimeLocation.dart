
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';


class RealTimeLocation extends StatefulWidget {
  @override
  _RealTimeLocationState createState() => _RealTimeLocationState();
}

class _RealTimeLocationState extends State<RealTimeLocation> {

  LocationData _currentLocation;
  Location location = new Location();
  StreamSubscription<LocationData> streamSubscription;
  @override
  void initState(){
    super.initState();
    getLocations();
  
    
   }

   
   

   getLocations(){

    
     streamSubscription = location.onLocationChanged.listen((event) {
       final result =event;

         setState(() {
           _currentLocation = result;
         });
     });
     
     
     streamSubscription.onDone(() =>{
       print("Done")
     });
   }

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        title:new Text("Real Time Location"),
        actions: <Widget>[
          FlatButton(onPressed: getLocations, child: Text("Get Real Time"))
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(_currentLocation.latitude.toString()),
              Text(_currentLocation.longitude.toString())
            ],
          ),
        ),)
      
    );
  }
}
