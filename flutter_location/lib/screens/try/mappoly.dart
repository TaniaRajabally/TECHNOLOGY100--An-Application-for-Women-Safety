import "package:flutter_polyline_points/flutter_polyline_points.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

import "package:flutter/material.dart";
class MapPoly extends StatefulWidget {
  @override
  _MapPolyState createState() => _MapPolyState();
}

class _MapPolyState extends State<MapPoly> {


  Set<Polyline> _polylines = {};// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];// this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyDwIoJG0LW1L1zHTVUdN7UYERo3Q9QK03E";

  _MapPolyState(){
    setPolylines();
  }

  setPolylines() async {   
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
         googleAPIKey,
         19.2307, 
         72.8567,
         19.4946, 
         72.8604);   
         if(result.isNotEmpty)
         {      
          setState(() {
                result.forEach((PointLatLng point){
                  polylineCoordinates.add(
                    LatLng(point.latitude, point.longitude));
                });
            
        
                Polyline polyline = Polyline(
                  polylineId: PolylineId("poly"),
                  color: Color.fromARGB(255, 40, 122, 198),
                  points: polylineCoordinates
                );
          
                _polylines.add(polyline);   
          });
        }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("hi"),
      
      ),
      body: new Container(
        child:GoogleMap(
              // mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(19.1136,  72.8697),
                zoom:12.0
              ),
              polylines: _polylines
            ),
      )
    );
  }
}