// import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
class DistanceBetween{
  final double lat1;
  final double lat2;
  final double long1;
  final double long2;

  DistanceBetween(this.lat1,this.lat2,this.long1,this.long2);
  



  Future<double> getDistance() async{
    final double distance = await Geolocator().distanceBetween( this.lat1, this.long1, this.lat2, this.long2);
    print(lat1);
    print(lat2);
    return distance;
  }


}