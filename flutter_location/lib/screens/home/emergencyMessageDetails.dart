import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageDetails extends StatefulWidget {
  final String content;
  final String from ;
  final String date;
  final String time;
  final String lat ;
  final String long ;

  MessageDetails(this.content,this.from,this.date,this.time,this.lat,this.long);

  

  
  @override
  _MessageDetailsState createState() => _MessageDetailsState(content,from,date,time,lat,long);
}

class _MessageDetailsState extends State<MessageDetails> {
  final String content;
  final String from ;
  final String date;
  final String time;
  final String lat ;
  final String long ;
  Map<String, Marker> _markers = <String, Marker>{};
  Map<String, Circle> _circles = <String, Circle>{};
  double latitude=19.0596 ;
  double longitude =72.8295;
  _MessageDetailsState(this.content,this.from,this.date,this.time,this.lat,this.long){
    _getLocation();
  }
    
  void _getLocation() async {
    print("Hola");
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        
    setState(() {
      print("vxvxcv");
      
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;
      final double lat1 = double.parse(lat);
      final double long1 = double.parse(long);
      
      final marker = Marker(
          markerId: MarkerId("Destination"),
          position: LatLng(lat1,long1),
          infoWindow: InfoWindow(title: 'Destination'),
          draggable: true,
          onTap: (){ print("Destination");},
          icon: BitmapDescriptor.defaultMarker,
      );
      _markers["Destination"] = marker;


      final circle = Circle(
          circleId: CircleId("Current Location"),
          center: LatLng(currentLocation.latitude, currentLocation.longitude),
          radius: 1000,
          fillColor: Colors.red[300].withOpacity(0.5),
          strokeColor: Colors.red[100],
          strokeWidth: 2,
          
      );
      _circles["Current loaction"] = circle;
    });

      
  }

     



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message")
      ),
      body: Container(
        child: new Column(
          children: <Widget>[
            Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  
                  title: Text(
                    "From:-"+from+"\n"+"Message:-"+content+"\n"+"Date:-"+date+"\n"+"Time:-"+time+"\n"+"Latitude:-"+lat+"\n"+"Longitude:-"+long,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                ),
              ),
            ),
            // new Text("From:-"+from+"\n"+"Message:-"+content+"\n"+"Date:-"+date+"\n"+"Time:-"+time+"\n"+"Latitude:-"+lat+"\n"+"Longitude:-"+long),
            new Container(
              padding: EdgeInsets.only(top: 12.0), 
              height: 450,
              width: 500,
              child: GoogleMap(
              // mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude,  longitude),
                  zoom:12.0
                ),
                markers: _markers.values.toSet(),
                // markers: allMarkers,
                circles: _circles.values.toSet(),
              ),
  
            )
          ],

        ),
      ),
    );
  }
}