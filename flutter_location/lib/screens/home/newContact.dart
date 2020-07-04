import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart'; 

// class CustomContact {

//   String name;
//   String contact;

//   CustomContact({this.contact,this.name});

//   static List<CustomContact> getContacts(List _contacts){
//     List <CustomContact> tempList ;
//     for (final contact in _contacts) {
//         name = contact.

//     }
    
//   }


// }

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {

  bool pressed = false;
 final PermissionHandler _permissionHandler = PermissionHandler();
  List<Contact> _contacts;
  final List<DropdownMenuItem> list1 = [];
  // List<DropdownMenuItem<Contact>> _dropDownMenuItems;

  List contactList;
  // Contact _selectedContact;
  // printContacts() async{
  //    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
  //    print(contacts);
  // }

  checkPermission() async{
    var permissionStatus = await _permissionHandler.checkPermissionStatus(PermissionGroup.contacts);
    if(permissionStatus != PermissionStatus.granted){
      getPermission();

    }
    else{
        
    
    getContacts();
    
    }
  }

  getContacts()async {
    print("______________________");
        var contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();
        setState(() {
          _contacts = contacts;
          int i=0;
          for (final contact in _contacts){
          print("Ho");
          Iterable<Item> phones = contact.phones;
          print(contact.displayName);
          
          phones.forEach((element) {
            var phoneNumber = element.value;
            // contactList[phoneNumber.toString()]=contact.displayName;
            print(phoneNumber);

            var temp = {
              "name":contact.displayName,
              "contact":phoneNumber,
            };
            contactList.add(temp);

            // list1.add(DropdownMenuItem(value: i,child: Container(child: Text(contact.displayName),)));
            i=i+1;
            });
        }

         
        });
        
    
  }
  getPermission() async{
      var result = await _permissionHandler.requestPermissions([PermissionGroup.contacts]);

      if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
          print("Hurrey");
          getContacts();
      }
  }

  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("New Contacts"),
      ),
    
     floatingActionButton: FloatingActionButton(
         
          onPressed: ()=>{
            checkPermission(),
            pressed = true,

            },
          
          tooltip: 'Add Emergency Contact',
          child: Icon(Icons.people),
      ),


    );
  }
}