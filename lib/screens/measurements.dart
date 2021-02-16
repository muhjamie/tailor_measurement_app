import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daas/helpers/screen_navigation.dart';
import 'package:daas/helpers/style.dart';
import 'package:daas/models/customer_model.dart';
import 'package:daas/models/measurements_model.dart';
import 'package:daas/providers/customer_provider.dart';
import 'package:daas/providers/measurements_provider.dart';
import 'package:daas/screens/create_customer.dart';
import 'package:daas/screens/create_measurement.dart';
import 'package:daas/screens/measurements.dart';
import 'package:daas/widgets/custom_text.dart';
import 'package:daas/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Measurements extends StatefulWidget {
  final String customerId;
  final DocumentSnapshot data;

  const Measurements({Key key, this.customerId, this.data}) : super(key: key);

  @override
  _MeasurementsState createState() => _MeasurementsState();
}

class _MeasurementsState extends State<Measurements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Measurements'),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: white,),
              onPressed: () => changeScreen(context, CreateMeasurement(customerId: widget.customerId,))
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore.instance.collection("measurements").where('customerId', isEqualTo: widget.customerId).snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData ? Loading() : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot measurements = snapshot.data.documents[index];
                return GestureDetector(
                  onTap: () {
                    //changeScreen(context, Measurements(customerId: customer.documentID, data: customer));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: Table(
                       textDirection: TextDirection.ltr,
                       defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                       border: TableBorder.symmetric(
                         inside: BorderSide(color: Colors.grey),
                       ),
                        children: [
                          TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Measurement", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Value", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                              ]
                          ),
                          _showTableRow('Burst', measurements['burst']),
                          _showTableRow('Knee', measurements['knee']),
                          _showTableRow('Shoulder', measurements['shoulder']),

                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
      ),
    );
  }

  _showTableRow(String title, String field) {
    return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(field),
          ),
        ]
    );
  }
}
