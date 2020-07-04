class Contact{
  final int id;
  final String name;
  final String phone;

  Contact({this.id,this.name,this.phone});

  Contact.fromJson(Map<String,dynamic> parsedJson)
  : id = parsedJson['id'],
  name = parsedJson['name'],
  phone = parsedJson['phone'];

}