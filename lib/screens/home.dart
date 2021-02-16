import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daas/helpers/screen_navigation.dart';
import 'package:daas/providers/customer_provider.dart';
import 'package:daas/providers/user_provider.dart';
import 'package:daas/screens/customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _customerCount = 0;

  @override
  void initState() {
    getCustomersCount();
    super.initState();
  }

  Future<void> getCustomersCount() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection('customers').getDocuments();
    List<DocumentSnapshot> querySnapshotCount = querySnapshot.documents;
    setState(() {
      _customerCount = querySnapshotCount.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    customerProvider.loadCustomers();
    return Scaffold(
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () {
                      changeScreen(context, Customers());
                    },
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Customers', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                          Text(_customerCount.toString(), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 27),)
                        ],
                      ))),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //print('Measurement Clicked!!');
                      authProvider.signOut();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Measurements', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                          Text('125', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 27),)
                        ],
                      ))),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
