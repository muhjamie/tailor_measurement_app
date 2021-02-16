import 'package:daas/models/measurements_model.dart';
import 'package:daas/services/measurements_services.dart';
import 'package:flutter/cupertino.dart';

class MeasurementsProvider extends ChangeNotifier {

  List<MeasurementsModel> measurementsList = [];
  MeasurementServices _measurementServices = MeasurementServices();
  TextEditingController burstController = TextEditingController();
  TextEditingController shoulderController = TextEditingController();
  TextEditingController kneeController = TextEditingController();

  MeasurementsProvider.initialize() {
    loadMeasurements();
  }

  Future<void> loadMeasurements() async {
    measurementsList = await _measurementServices.getMeasurements();
    print(measurementsList);
    notifyListeners();
  }

  Future<bool> addMeasurements(String customerId) async {
    try {
      Map<String, dynamic> data = {
        'customerId': customerId,
        'burst': burstController.text,
        'shoulder': shoulderController.text,
        'knee': kneeController.text,
      };
      _measurementServices.createMeasurements(data);
      clearForm();
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  void clearForm() {
    burstController.text = '';
    shoulderController.text = '';
    kneeController.text = '';
  }
}