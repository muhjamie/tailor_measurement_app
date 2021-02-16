import 'package:daas/helpers/screen_navigation.dart';
import 'package:daas/helpers/style.dart';
import 'package:daas/helpers/validations.dart';
import 'package:daas/providers/app_provider.dart';
import 'package:daas/providers/customer_provider.dart';
import 'package:daas/providers/measurements_provider.dart';
import 'package:daas/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CreateMeasurement extends StatefulWidget {
  final String customerId;

  const CreateMeasurement({Key key, this.customerId}) : super(key: key);

  @override
  _CreateMeasurementState createState() => _CreateMeasurementState();
}

class _CreateMeasurementState extends State<CreateMeasurement> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isBusy;
  bool autoValidate = false;
  Validations validations = new Validations();


  processCreateMeasurement() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      autoValidate = true; // Start validating on every change.
    } else {
      form.save();
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.changeLoading();
      MeasurementsProvider measurementsProvider = Provider.of<MeasurementsProvider>(context, listen: false);
      String customerId = widget?.customerId;
      if(!await measurementsProvider.addMeasurements(customerId))  {
        _key.currentState.showSnackBar(
            SnackBar(content: Text("Unable to add measurement."))
        );
        //appProvider.changeLoading();
        return;
      }
      appProvider.changeLoading();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _isBusy = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MeasurementsProvider measurementsProvider = Provider.of<MeasurementsProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Create Measurement'),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _createForm('Burst', measurementsProvider.burstController),
                  SizedBox(height: 20),
                  _createForm('Shoulder', measurementsProvider.shoulderController),
                  SizedBox(height: 20,),
                  _createForm('Knee', measurementsProvider.kneeController),
                  SizedBox(height: 30,),
                  ButtonTheme(
                    buttonColor: Colors.brown,
                    minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    child: RaisedButton(
                      child: appProvider.isLoading ? Loading() : Text('Create', style: TextStyle(color: white),),
                      onPressed: () => processCreateMeasurement(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _createForm(String hint, TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: hint
      ),
      controller: controller,
    );
  }
}
