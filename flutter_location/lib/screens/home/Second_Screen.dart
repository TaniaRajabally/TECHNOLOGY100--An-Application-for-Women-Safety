import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecondScreen extends StatefulWidget {
  String payload ;
  SecondScreen(String payload){
    this.payload = payload;
  }
  @override
  _SecondScreenState createState() => _SecondScreenState(payload);
}

class _SecondScreenState extends State<SecondScreen> {
  String payload ;
  final databaseReference = FirebaseDatabase.instance.reference();

  List policeStations ;
  Iterable newPoliceStations;
  int len;
  Map<String, Marker> _markers = <String, Marker>{};
  Map<String, Circle> _circles = <String, Circle>{};
  double latitude;
  double longitude;
  String googleAPIKey = "AIzaSyDwIoJG0LW1L1zHTVUdN7UYERo3Q9QK03E";
  double currentLat;
  double currentLon;


  Set<Polyline> _polylines = {};// this will hold each polyline coordinate as Lat and Lng pairs
  // List<LatLng> polylineCoordinates = [];// this is the key object - the PolylinePoints

  GoogleMapPolyline googleMapPolyline = new  GoogleMapPolyline(apiKey:"AIzaSyATSILVt6J9ZqcCWJmIiup1-Y9R8U0sYas");


// which generates every polyline between start and finish
  

  var poly;

  
 _SecondScreenState(String payload){

  
    this.payload = payload;
   _setThings();
    
    
  }

@override
void initState(){
  super.initState();
  _setThings();
}

 getIt() async {
  var polylineCoordinates =  await googleMapPolyline?.getCoordinatesWithLocation(
          origin: LatLng(40.677939, -73.941755),
          destination: LatLng(40.698432, -73.924038),
          mode:  RouteMode.driving);		
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    print(polylineCoordinates);
          
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId("route 1"),
        visible: true,
        points: polylineCoordinates,
        width:4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap
      ));
    }); 
  }
void _setThings() async {
    
    Position currentLocation=  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    
    
      
      databaseReference.child("policeStation").once().then((DataSnapshot snapshot) {
      
      policeStations = snapshot.value;

      setState(() {
        len = policeStations.length;
        newPoliceStations = policeStations.getRange(1, len);
      
        _markers.clear();
        int i=0;
        for (var x in newPoliceStations){
            

            final marker1=Marker(
            markerId: MarkerId(x["name"]),
            position: LatLng(x["lat"],x["lon"]),
            infoWindow: InfoWindow(title: x["name"]),
            draggable: true,
            onTap: (){getIt();},
            
            );
            _markers["$i"]=marker1;
            i=i+1;
        }
        currentLat = currentLocation.latitude;
        currentLon = currentLocation.longitude;


        
        final circle = Circle(
            circleId: CircleId("One"),
            center: LatLng(currentLocation.latitude,currentLocation.longitude),
            radius: 1000,
            fillColor: Colors.blue[300].withOpacity(0.5),
            strokeColor: Colors.blue[100],
            strokeWidth: 2,
            
        );
        _circles["Current Location"] = circle;
        
        
        
    });

    
      
    });
  }

  

  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Police Station near You"),

      ),
      body: new Container(
          child: GoogleMap(
              // mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(19.4946, 72.8604),
                zoom:12.0
              ),
              markers: _markers.values.toSet(),
              // markers: allMarkers,
              circles: _circles.values.toSet(),
              polylines: _polylines,
          )  
      )
    );
  }
}
