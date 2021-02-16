import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daas/models/customer_model.dart';
import 'package:daas/providers/app_provider.dart';
import 'package:daas/services/customer_services.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends AppProvider {

  Firestore _firestore = Firestore.instance;
  CustomerServices _customerService = CustomerServices();
  List<CustomerModel> customers = [];
  int customersCount = 0;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  CustomerProvider.initialize(){
    loadCustomers();
  }

  loadCustomers() async {
    customers = await _customerService.getCustomers();
    customersCount = customers.length;
    notifyListeners();
  }

  Future<bool> addCustomer() async {
    print(phone.text);
    try {
      Map<String, dynamic> data = {
        'name': name.text,
        'phone': phone.text
      };
      _customerService.createCustomer(data);
      clearForm();
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  clearForm() {
    name.text = '';
    phone.text = '';
  }
}