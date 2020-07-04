
import 'package:flutter/material.dart';
import 'package:flutter_location/screens/home/webCrawlerView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutube/flutube.dart';


class WebVideo extends StatefulWidget {
  @override
  _WebVideoState createState() => _WebVideoState();
}

class _WebVideoState extends State<WebVideo> {

  _WebVideoState(){
    getData();
  }
  int currentPos;
  String stateText;
  List urls = [];
  @override
  void initState() {
    currentPos = 0;
    stateText = "Video not started";
    getData();
    super.initState();
  }
  
  getData() async{
    http.Response response = await http.get(
      "https://dry-plains-98793.herokuapp.com/webVideo",

      );
      
     

      Map user = jsonDecode(response.body);

      user.forEach((key, value) { 
        setState(() {
          urls.add(value.toString());
        });
      });

      print(urls);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Self defence tutorials"),),

      body: Container(
        child: ListView.builder(
        itemCount: urls.length,
        itemBuilder: (context, index) {

          return  Card(
            elevation: 8.0,
            child:Container(
               decoration: BoxDecoration(color: Colors.blue[100]),
              child:Column(
              
              children: <Widget>[
                ListTile(
                  title: Text('${urls[index]}'),
                  trailing: FlatButton(onPressed: null, child: Text("Open")),
                  onTap: ()=>Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WebCrawlerView(urls[index])),
                                ),
                ),
              
              ],
            )
            )
          );

          // return Column(children: <Widget>
          // [
          //   ListTile(
          //     title: Text('${urls[index]}'),
              
          //   ),
          //   FlatButton(onPressed: null,
          //    child: Text("Open")),
          //   Divider()
            
          // ],);
        

        },
      )
    ,)
      // body: Container(child: Center(child:FlatButton(onPressed: getData, child: Text("Press Me"))),),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('FluTube Test'),
  //     ),
  //     body:  Container(
  //       child: FluTube.playlist(
  //                   urls[0],
  //                   autoInitialize: true,
  //                   aspectRatio: 16 / 9,
  //                   allowMuting: false,
  //                   looping: true,
  //                   deviceOrientationAfterFullscreen: [
  //                     DeviceOrientation.portraitUp,
  //                     DeviceOrientation.landscapeLeft,
  //                     DeviceOrientation.landscapeRight,
  //                   ],
  //                   systemOverlaysAfterFullscreen: SystemUiOverlay.values,
  //                   onVideoStart: () {
                      
  //                   },
  //                   onVideoEnd: () {
                      
  //                   },
  //                 ),
          
  //           child:ListView.builder(
  //             scrollDirection: Axis.vertical,
  //             shrinkWrap: true,
  //             itemCount: urls.length,
  //             itemBuilder: (context, index) {

  //               return ListTile(
  //                 title: Text('${urls[index]}'),
  //                 trailing: FluTube.playlist(
  //                   urls[index],
  //                   autoInitialize: true,
  //                   aspectRatio: 16 / 9,
  //                   allowMuting: false,
  //                   looping: true,
  //                   deviceOrientationAfterFullscreen: [
  //                     DeviceOrientation.portraitUp,
  //                     DeviceOrientation.landscapeLeft,
  //                     DeviceOrientation.landscapeRight,
  //                   ],
  //                   systemOverlaysAfterFullscreen: SystemUiOverlay.values,
  //                   onVideoStart: () {
                      
  //                   },
  //                   onVideoEnd: () {
                      
  //                   },
  //                 ),
                  
  //             );
  //             }
  //           ),
        
      
  //     ),
      
  //   );
  // }
}

//  final List<String> playlist = <String>[
//     'https://www.youtube.com/watch?v=scvi2EemtDw',
   
//   ];
//   int currentPos;
//   String stateText;

//   @override
//   void initState() {
//     currentPos = 0;
//     stateText = "Video not started";
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Women Safety Video'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Text('Youtube video URL: ${playlist[currentPos]}', style: TextStyle(fontSize: 16.0),),
//             FluTube.playlist(
//               playlist,
//               autoInitialize: true,
//               aspectRatio: 16 / 9,
//               allowMuting: false,
//               looping: true,
//               deviceOrientationAfterFullscreen: [
//                 DeviceOrientation.portraitUp,
//                 DeviceOrientation.landscapeLeft,
//                 DeviceOrientation.landscapeRight,
//               ],
//               systemOverlaysAfterFullscreen: SystemUiOverlay.values,
//               onVideoStart: () {
//                 setState(() {
//                   stateText = 'Video started playing!';
//                 });
//               },
//               onVideoEnd: () {
//                 setState(() {
//                   stateText = 'Video ended playing!';
//                   if((currentPos + 1) < playlist.length)
//                     currentPos++;
//                 });
//               },
//             ),
//             Text(stateText),
//           ],
//         ),
//       ),
//     );
//   }
// }

