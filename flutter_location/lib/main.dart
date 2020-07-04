import 'package:flutter/material.dart';
import 'package:flutter_location/models/locationData.dart';
// import 'package:flutter_location/screens/back/counter_service.dart';
// import 'package:flutter_location/screens/home/Second_Screen.dart';
// import 'package:flutter_location/screens/home/home.dart';
import 'package:flutter_location/services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:flutter_location/models/user.dart';
import 'package:flutter_location/screens/wrapper.dart';
import 'package:flutter_location/services/auth.dart';
import 'package:provider/provider.dart';


import 'package:flutter/services.dart';
// import 'package:flutter_location/screens/back/app_retain_widget.dart';
// import 'package:flutter_location/screens/back/background_main.dart';
// import 'package:flutter_location/screens/back/counter_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_location/app_retain_widget.dart';
import 'package:flutter_location/background_main.dart';
import 'package:flutter_location/counter_service.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
  //  var channel = const MethodChannel('com.example/background_service');
  // var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  // channel.invokeMethod('startService', callbackHandle.toRawHandle());

  // CounterService().startCounting();
  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

  CounterService().startCounting();
  print(CounterService().count);
  print("in");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
      ),
    );
  }

  
}







// class _MyAppState extends State<MyApp> {



  
  
//   @override
//   Widget build(BuildContext context) {
    
//     return new MaterialApp(
//         home: new HomeScreen());
//   }
    
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  
   
//    Map<String, Marker> _markers = <String, Marker>{};
//    Map<String, Circle> _circles = <String, Circle>{};
//   //  List<Marker> allMarkers =[];
//    Set<Marker> allMarkers = {};








//   Future _showNotificationWithoutSound() async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         playSound: false, importance: Importance.Max, priority: Priority.High);
//     var iOSPlatformChannelSpecifics =
//         new IOSNotificationDetails(presentSound: false);
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Post',
//       'How to Show Notification in Flutter',
//       platformChannelSpecifics,
//       payload: 'No_Sound',
//     );
//   }







  
//   //  Set<Circle> circles = {};
//   void _getLocation() async {
//     print("Hola");
//     var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        
//     setState(() {
//       print("vxvxcv");
      
//       allMarkers.clear();
      
//       final marker = Marker(
//           markerId: MarkerId("curr_loc"),
//           position: LatLng(currentLocation.latitude, currentLocation.longitude),
//           infoWindow: InfoWindow(title: 'My Location'),
//           draggable: true,
//           onTap: (){ print("College");},
//           icon: BitmapDescriptor.defaultMarker,
//       );
//       _markers["Current Location"] = marker;
      
//       allMarkers.add(marker);
//       print(allMarkers);


// });
//     double distanceInMeters = await Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude,19.2029, 72.8518);
//     print("^^^^^^^^^^^^^^");

//     print(distanceInMeters);
//     if (distanceInMeters >5000){
//       _showNotificationWithoutSound();
//     }
//   }
  
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();



//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     var initializationSettingsAndroid = AndroidInitializationSettings('womensafety');
//     var initializationSettingsIOS = IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
  
  
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

//     final marker1=Marker(
//     markerId: MarkerId("College Marker"),
//     position: LatLng(19.113646,72.869736),
//     infoWindow: InfoWindow(title: 'College Location'),
//     draggable: true,
//     onTap: (){ print("College");},
    
//     );
//     _markers["College Location"] = marker1;
//     print(marker1);
//     allMarkers.add(marker1);
//     _markers["College Location"]=marker1;
    
//     // allMarkers.add(Marker(
//     // markerId: MarkerId("College Marker"),
//     // draggable: true,
//     // onTap: (){ print("College");},
//     // position: LatLng(19.113646,72.869736)
//     // ));
//     //  circles = Set.from([Circle(
//     //       circleId: CircleId("One"),
//     //       center: LatLng(19.2029, 72.8518),
//     //       radius: 4000,
//     //   )]);
//     final circle = Circle(
//           circleId: CircleId("One"),
//           center: LatLng(19.2029, 72.8518),
//           radius: 1000,
//           fillColor: Colors.red[300].withOpacity(0.5),
//           strokeColor: Colors.red[100],
//           strokeWidth: 2,
          
//       );
//       _circles["Kandivali circle"] = circle;


//   }
//   Future onSelectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//     }
    
//      Navigator.push(
//       context,
//       new MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//     );
// }


//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//           appBar: new AppBar(
//               title: Text("Maps"),
//           ),
//           body: Container(
//             height: 800,
//             width: 500,
            
//             child: GoogleMap(
//               // mapType: MapType.hybrid,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(19.1136,  72.8697),
//                 zoom:12.0
//               ),
//               markers: _markers.values.toSet(),
//               // markers: allMarkers,
//               circles: _circles.values.toSet(),
//             ),
            
//           ), 

//           floatingActionButton: FloatingActionButton(
//           onPressed: _getLocation,
          
//           tooltip: 'Get Location',
//           child: Icon(Icons.flag),
//       ),
//     );

//   }
// }

