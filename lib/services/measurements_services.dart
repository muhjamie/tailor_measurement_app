import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daas/models/customer_model.dart';
import 'package:daas/models/measurements_model.dart';
import 'package:daas/models/user_model.dart';
import 'package:flutter/material.dart';

class MeasurementServices {
  CollectionReference _measurementsCollectionReference = Firestore.instance.collection('measurements');

  void createMeasurements(Map<String, dynamic> values) {
    try{
      _measurementsCollectionReference.add(values);
    } catch(e) {
      print(e.toString());
    }
  }

  Future<List<MeasurementsModel>> getMeasurements() async {
    List<MeasurementsModel> measurements = [];
    _measurementsCollectionReference.getDocuments().then((result) {
      for (DocumentSnapshot measurement in result.documents) {
        measurements.add(MeasurementsModel.fromSnapshot(measurement));
      }
      print(measurements);

    });
    return measurements;
  }
}