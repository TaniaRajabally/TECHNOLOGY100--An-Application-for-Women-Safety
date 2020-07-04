import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class GetLat extends StatefulWidget {
  @override
  _GetLatState createState() => _GetLatState();
}



class _GetLatState extends State<GetLat> {
  @override
  void initState(){
    getCoordinates();

    super.initState();
  }

  getCoordinates() async{

    final query = "204 Blue Shelter, Kandarpada, Dahisar, Mumbai";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hiii"),
    );
  }
}