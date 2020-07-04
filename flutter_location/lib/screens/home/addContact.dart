// import "package:flutter/material.dart";
// import 'package:firebase_database/firebase_database.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter_location/services/contact.dart';
// import 'package:simple_permissions/simple_permissions.dart';
// class AddContact extends StatefulWidget {


//   @override
//   _AddContactState createState() => _AddContactState();
// }

// class _AddContactState extends State<AddContact> {

  
//   Iterable<Contact> contacts;
//   _AddContactState(){

//     // _getContacts();
//     // contacts.forEach((element) {
//     //   print(element);
//     // });

//   }
//   String status;
//   Permission permission;

//   void _getContacts() async{
//     contacts = await ContactsService.getContacts(withThumbnails: false);
//   }
//   final _contactForm = GlobalKey<FormState>();

//   requestPermission() async{
//     final res = await SimplePermissions.requestPermission(permission);
//     print("permission request result is " + res.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: new Center(
//           child:new Text("Add Contacts"),
//         ),
//       ),
//       body: new Container(
//           child:new Column(
//             children:<Widget>[

//               new Text("Status"),
//               new RaisedButton(
//                 onPressed: () {
//                   PermissionsService().requestContactsPermission();
//                 },
//                 child: new Text("Check Permission"),
//               )
//             ]

            
//           )

//       ),
      
//     );
//   }
// }