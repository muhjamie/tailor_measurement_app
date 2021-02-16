import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel{
  String _name;
  String _phone;


//  getters
  String get name => _name;
  String get phone => _phone;

  CustomerModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data['name'];
    _phone = snapshot.data['phone'];
  }
}