import 'package:daas/helpers/screen_navigation.dart';
import 'package:daas/helpers/style.dart';
import 'package:daas/helpers/validations.dart';
import 'package:daas/providers/app_provider.dart';
import 'package:daas/providers/customer_provider.dart';
import 'package:daas/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CreateCustomer extends StatefulWidget {
  @override
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isBusy;
  bool autoValidate = false;
  Validations validations = new Validations();


  processCreateCustomer() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      autoValidate = true; // Start validating on every change.
    } else {
      form.save();
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.changeLoading();
      CustomerProvider customerProvider = Provider.of<CustomerProvider>(context, listen: false);
      if(!await customerProvider.addCustomer())  {
        _key.currentState.showSnackBar(
            SnackBar(content: Text("Login failed!"))
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
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Create Customer'),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: validations.validateName,
                    decoration: InputDecoration(
                        hintText: 'Name'
                    ),
                    controller: customerProvider.name,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: validations.validateMobile,
                    decoration: InputDecoration(
                      hintText: 'Phone'
                    ),
                    controller: customerProvider.phone,
                  ),
                  SizedBox(height: 30,),
                  ButtonTheme(
                    buttonColor: Colors.brown,
                    minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    child: RaisedButton(
                      child: appProvider.isLoading ? Loading() : Text('Create', style: TextStyle(color: white),),
                      onPressed: () => processCreateCustomer(),
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
}
