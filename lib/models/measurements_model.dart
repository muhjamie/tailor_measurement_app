import 'package:cloud_firestore/cloud_firestore.dart';

class MeasurementsModel{
  String _customerId;
  String _title;
  Map<String, dynamic> _data;
  String _date;


//  getters
  String get customerId => _customerId;
  String get title => _title;
  Map<String, dynamic> get data => _data;
  String get date => _date;

  MeasurementsModel.fromSnapshot(DocumentSnapshot snapshot){
    _customerId = snapshot.data['customerId'];
    _title = snapshot.data['title'];
    _data = snapshot.data['data'];
    _date = snapshot.data['date'];
  }
}