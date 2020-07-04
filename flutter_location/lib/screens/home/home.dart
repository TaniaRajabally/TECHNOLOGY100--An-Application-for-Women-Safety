import 'dart:math';
import 'package:flutter_location/screens/home/getLat.dart';
import 'package:flutter_location/screens/home/timer.dart';
import 'package:flutter_location/screens/home/unsafeApi.dart';
import 'package:merge_map/merge_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location/models/locationData.dart';
import 'package:flutter_location/screens/home/ApiCall.dart';
// import 'package:flutter_location/screens/back/backHome.dart';
import 'package:flutter_location/screens/home/EmergencyContactList.dart';
import 'package:flutter_location/screens/home/Second_Screen.dart';
import 'package:flutter_location/screens/home/chat.dart';
import 'package:flutter_location/screens/home/emergencyMessage.dart';
import 'package:flutter_location/screens/home/fingerprint.dart';
import 'package:flutter_location/screens/home/hardwareEvent.dart';
import 'package:flutter_location/screens/home/addUnsafeLocation.dart';
import 'package:flutter_location/screens/home/webVideo.dart';
import 'package:flutter_location/services/distance.dart';
import 'package:location/location.dart';



import 'package:flutter_location/screens/home/home.dart';
import 'package:flutter_location/screens/home/newContact.dart';

import 'package:flutter_location/screens/home/scanqr.dart';

import 'package:flutter_location/screens/try/mappoly.dart';
import 'package:flutter_location/services/auth.dart';
import 'package:flutter_location/services/location.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
class Home extends StatefulWidget {
  @override
 _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  
  
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
        home: new HomeScreen());
  }
    
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool show = false;
  BitmapDescriptor myIcon;
  LocationData currentLocation;


  Location location = new Location();
  StreamSubscription<LocationData> streamSubscription;


  _HomeScreenState(){
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(8, 8)), 'assets/index.png')
        .then((onValue) {
      this.myIcon = onValue;
    });
    
  }
  
  final databaseReference = FirebaseDatabase.instance.reference();
  String name = '';
  String email = '';
  AuthService _auth = new AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  
   
   Map<String, Marker> _markers = <String, Marker>{};
   Map<String, Marker> _unsafeMarkers = <String, Marker>{};
   Map<String, Circle> _circles = <String, Circle>{};
  //  List<Marker> allMarkers =[];
   Set<Marker> allMarkers = {};

   bool notify=true;

   Map unsafeDetails={};

   var postUserId;
   var postId;








  Future _showNotificationWithoutSound() async {

    if(notify==true){
      setState(() {
        notify=false;
      });
    }
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Unsafe Area',
      'You Are Entering Unsafe Area',
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
  }


  void getCurrLocations() async{

    final FirebaseUser user = await auth.currentUser();
    final userid = user.uid;
     streamSubscription = location.onLocationChanged.listen((event) {
       final result =event;

         setState(() {
           currentLocation = result;

           var temp = {
            'lat':currentLocation.latitude,
            'long':currentLocation.longitude
           };
           allMarkers.clear();
      
            final marker = Marker(
                markerId: MarkerId("curr_loc"),
                position: LatLng(currentLocation.latitude, currentLocation.longitude),
                infoWindow: InfoWindow(title: 'My Location'),
                draggable: true,
                onTap: (){ print("Mine");},
                icon: BitmapDescriptor.defaultMarkerWithHue(194.7),
            );
            _markers["Current Location"] = marker;
           databaseReference.child("users").child(userid).child("currentLocation").update(temp);
           getUnsafeDataApi(currentLocation.latitude, currentLocation.longitude);
         });
     });
     
     
     streamSubscription.onDone(() => {
       print("Done")
     });
   }


  getUnsafeDataApi(double lat, double long) async{
    http.Response response = await http.get(
      "https://damp-tundra-30686.herokuapp.com/unsafe",

      );
      Map user = jsonDecode(response.body);

      if(user.length != 0){
        Map latList = user["lat"];
        Map longList = user["long"];
        
        
        var len = latList.length;
        double min_dist=999999.9;
        double min_lat=0.0;
        double min_long=0.0;
        int detailsNumber = 0;
        for(int i=0;i<len;i++){
          double templat = latList[i.toString()];
          double templong = longList[i.toString()];
          
          var s = new DistanceBetween(lat,templat,long,templong);

          double distance = await s.getDistance();
          if (distance < min_dist){
            print("RRRRRRRRRRRRRR");
            min_lat = templat;
            min_long = templong;
            min_dist =distance ;
            detailsNumber = i;
          }
          
        }
        print("++++++++");
        print(min_dist);
        if(min_dist<300){

          setState(() {

            print("________________________");
            final marker1=Marker(
              markerId: MarkerId("Unsafe"),
              position: LatLng(min_lat,min_long),
              infoWindow: InfoWindow(title: 'Unsafe Location'),
              draggable: true,
              icon: BitmapDescriptor.defaultMarker,
              onTap: (){ 
                setState(() {
                  unsafeDetails["isBar"]=user["isBar"][detailsNumber.toString()];
                  unsafeDetails["isPolice"]=user["isPolice"][detailsNumber.toString()];
                  unsafeDetails["message"]=user["message"][detailsNumber.toString()];
                  unsafeDetails["unsafeHours"]=user["unsafeHours"][detailsNumber.toString()];
                  unsafeDetails["frequencyOfPeople"]=user["frequencyOfPeople"][detailsNumber.toString()];
                  postUserId = user["userId"][detailsNumber.toString()];
                  postId = user["id"][detailsNumber.toString()];

                  print("^^^^^^^^^^^^^^^^^^^^^^^^^6");
                //   databaseReference.child("UnsafeZone").child(postUserId).child(postId).child("votes").once().then((DataSnapshot snapshot) {
                    
                //   var userDetails = snapshot.value;
                //   if
                //   print("^^^^^^^^^^^^^^^^^^^^^^^^^6");
                //   print(userDetails);
                // });



                  if(show == true){
                    show = false;
                  }
                  else{
                    show =true;
                  }
            
                
              });
              },
              
              );
              
              _markers["Unsafe"] = marker1;
              _circles.clear();
              final circle = Circle(
                circleId: CircleId("One"),
                center: LatLng(min_lat,min_long),
                radius: 150,
                fillColor: Colors.red[300].withOpacity(0.5),
                strokeColor: Colors.red[100],
                strokeWidth: 2,
                
            );
            _circles["Kandivali circle"] = circle;
              
          });
          if (notify==true){
          _showNotificationWithoutSound();
        }
        print("*******************");
        }
      }

  }





  
  //  Set<Circle> circles = {};
  void _getLocation() async {
    print("Hola");
    setState(() {
      print("vxvxcv");
      
      allMarkers.clear();
      
      final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'My Location'),
          draggable: true,
          onTap: (){ print("College");},
          icon: myIcon,
      );
      _markers["Current Location"] = marker;
      
      allMarkers.add(marker);
      print(allMarkers);


});
    // double distanceInMeters = await Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude,19.2029, 72.8518);
    double distanceInMeters = 6000;
    print("^^^^^^^^^^^^^^");

    print(distanceInMeters);
    if (distanceInMeters >5000){
      _showNotificationWithoutSound();
    }
  }

  void getUid() async{
    final FirebaseUser user = await auth.currentUser();
    final userid = user.uid;

    databaseReference.child("users").child(userid).once().then((DataSnapshot snapshot) {
      
      var userDetails = snapshot.value;
      setState(() {
        email = userDetails["email"];
        name = userDetails["name"];
      });
    });

  }
  
  @override
  void initState() {
    // TODO: implement initState
    
    getCurrLocations();
    getUid();
    super.initState();





    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('womensafety');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  
  
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

    // final marker1=Marker(
    // markerId: MarkerId("College Marker"),
    // position: LatLng(19.113646,72.869736),
    // infoWindow: InfoWindow(title: 'College Location'),
    // draggable: true,
    // icon: BitmapDescriptor.defaultMarkerWithHue(100.0),
    // onTap: (){ print("College");},
    
    // );
    // _markers["College Location"] = marker1;
    // print(marker1);
    // allMarkers.add(marker1);
    // _markers["College Location"]=marker1;
    
    // allMarkers.add(Marker(
    // markerId: MarkerId("College Marker"),
    // draggable: true,
    // onTap: (){ print("College");},
    // position: LatLng(19.113646,72.869736)
    // ));
    //  circles = Set.from([Circle(
    //       circleId: CircleId("One"),
    //       center: LatLng(19.2029, 72.8518),
    //       radius: 4000,
    //   )]);
    // final circle = Circle(
    //       circleId: CircleId("One"),
    //       center: LatLng(19.2029, 72.8518),
    //       radius: 1000,
    //       fillColor: Colors.red[300].withOpacity(0.5),
    //       strokeColor: Colors.red[100],
    //       strokeWidth: 2,
          
    //   );
    //   _circles["Kandivali circle"] = circle;


  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    
     Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    );
}


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
          appBar: new AppBar(
              title: Text("Maps"),
              
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text("Sign Out"),
                  onPressed: () async {
                  await _auth.signOut();
                }, 
                ),
          
              ],
              
          
          ),
          drawer: new Drawer(
          
            child:new ListView(children:<Widget>[
              new UserAccountsDrawerHeader(
                accountName:new Text(name) ,
                accountEmail: new Text(email),
                decoration: new BoxDecoration(
                  image: new DecorationImage(fit: BoxFit.fill,
                  image: new NetworkImage("https://a57.foxnews.com/media2.foxnews.com/BrightCove/694940094001/2019/03/07/931/524/694940094001_6011111003001_6011106173001-vs.jpg?ve=1&tl=1")),
                ),
                ),

              new ListTile(
                title: new Text("Emergency Contacts"),
                trailing: new Icon(Icons.arrow_upward),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmergencyContactList()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("Emergency Messages"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmergencyMessage()),
                          ),
              ),
              // new Divider(),
              // new ListTile(
              //   title: new Text("Contacts"),
              //   trailing: new Icon(Icons.arrow_right),
              //   onTap: ()=>Navigator.push(
              //               context,
              //               MaterialPageRoute(builder: (context) => NewContact()),
              //             ),
              // ),
              new Divider(),
              new ListTile(
                title: new Text("Finger Print"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FingerPrint()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("Hardware Button"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HardwareButton()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("Qr Scanner"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QrScan()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("Chat "),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Chat()),
                          ),
              ),
              // new Divider(),
              // new ListTile(
              //   title: new Text("MapBox "),
              //   trailing: new Icon(Icons.arrow_right),
              //   onTap: ()=>Navigator.push(
              //               context,
              //               MaterialPageRoute(builder: (context) => MapPoly()),
              //             ),
              // ),
              new Divider(),
              new ListTile(
                title: new Text("Add Unsafe Areas "),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddUnsafeLocation()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("News"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ApiCall()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("Self Defence Tutorial"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WebVideo()),
                          ),
              ),
              new Divider(),
              new ListTile(
                title: new Text("GetLat"),
                trailing: new Icon(Icons.arrow_right),
                onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TimerSet()),
                          ),
              ),
            
              new Divider(),
              new ListTile(
                title: new Text("Sign Out"),
                trailing: new Icon(Icons.cancel),
              ),
            ])
          ),
          body: Container(
            height: 800,
            width: 500,
            child: Stack(
              children: <Widget>[

                new GoogleMap(
                // mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(19.2477,  	72.8501),
                  zoom:12.0
                ),
                markers: _markers.values.toSet(),
                // markers: allMarkers,
                circles: _circles.values.toSet(),
              ),
              show?
              new Container(
                alignment: Alignment.bottomCenter,

                child: new Container(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: new Card(
                    color: Colors.lightBlue[100],
                    elevation: 4.0,
                    child: Column(
                      children:<Widget>[
                        new Text("Unsafe Area Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red)),
                        new Text("Unsafe Hours: "+unsafeDetails["unsafeHours"]),
                        new Text("Bar in Area:"+unsafeDetails["isBar"]),
                        new Text("Nearby Police Station:"+unsafeDetails["isPolice"]),
                        new Text("Frequency Of People:"+unsafeDetails["frequencyOfPeople"]),
                        new Text("Message By User:"+unsafeDetails["message"]),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            IconButton(
                              icon: Icon(IconData(59612, fontFamily: 'MaterialIcons'),size: 35,color: Colors.blue,),
                              tooltip: 'Thumbs Up',
                              onPressed: () {
                                setState(() {
                            
                                });
                              },
                            ),
                            Text("20"),
                            Text("1"),
                            IconButton(
                              alignment:  Alignment.centerRight,
                              icon: Icon(IconData(59611, fontFamily: 'MaterialIcons'),size: 35,),
                              tooltip: 'Thumbs Down',
                              onPressed: () {
                                setState(() {
                                  
                                });
                              },
                            ),
                          ]
                        ) 
                      ]
                    ),
                  ),
                ),
                ): new Container()
              ],
            )
          ), 

      //     floatingActionButton: FloatingActionButton(
      //     onPressed: _getLocation,
          
      //     tooltip: 'Get Location',
      //     child: Icon(Icons.flag),
      // ),
    );

  }
}

