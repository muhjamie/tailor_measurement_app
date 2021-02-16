import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daas/helpers/screen_navigation.dart';
import 'package:daas/helpers/style.dart';
import 'package:daas/models/customer_model.dart';
import 'package:daas/providers/customer_provider.dart';
import 'package:daas/screens/create_customer.dart';
import 'package:daas/screens/measurements.dart';
import 'package:daas/widgets/custom_text.dart';
import 'package:daas/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    CustomerProvider customers = Provider.of<CustomerProvider>(context);
    //customers.loadCustomers();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Customers'),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: white,),
              onPressed: () => changeScreen(context, CreateCustomer())
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore.instance.collection("customers").orderBy('name').snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData ? Loading() : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot customer = snapshot.data.documents[index];
                return GestureDetector(
                  onTap: () {
                    changeScreen(context, Measurements(customerId: customer.documentID, data: customer));
                  },
                  child: ListTile(
                    title: CustomText(
                        text: customer['name'],
                        weight: FontWeight.w900
                    ),
                    subtitle: CustomText(text:customer['phone'], color: Colors.grey),
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
