import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daas/models/customer_model.dart';
import 'package:daas/models/user_model.dart';
import 'package:flutter/material.dart';

class CustomerServices {
  CollectionReference _customerCollectionReference = Firestore.instance.collection('customers');

  void createCustomer(Map<String, dynamic> values) {
    try{
      print(values);
      _customerCollectionReference.add(values);
    } catch(e) {
      print(e.toString());
    }
  }

  Future<List<CustomerModel>> getCustomers() async {
    _customerCollectionReference.getDocuments().then((result) {
      List<CustomerModel> customers = [];
      for (DocumentSnapshot customer in result.documents) {
        customers.add(CustomerModel.fromSnapshot(customer));
      }
      print(customers);
      return customers;
    });

    return [];
  }

  void getCustomerCount() async {
    QuerySnapshot _myDoc = await Firestore.instance.collection('product').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    _customerCollectionReference.getDocuments().then((value) => {

    });
    print(_myDocCount.length);  // Count of Documents in Collection
  }

/*
  void updateCustomerData(Map<String, dynamic> values){
    _firestore.collection(collection).document(values['id']).updateData(values);
  }

  Future<UserModel> getCustomerById(String id) => _firestore.collection(collection).document(id).get().then((doc){
    return UserModel.fromSnapshot(doc);
  });*/


}