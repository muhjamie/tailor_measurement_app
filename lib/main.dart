import 'package:daas/providers/app_provider.dart';
import 'package:daas/providers/customer_provider.dart';
import 'package:daas/providers/measurements_provider.dart';
import 'package:daas/providers/user_provider.dart';
import 'package:daas/screens/home.dart';
import 'package:daas/screens/login.dart';
import 'package:daas/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppProvider()),
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: CustomerProvider.initialize()),
        ChangeNotifierProvider.value(value: MeasurementsProvider.initialize()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DAAS Apparel',
          theme: ThemeData(
            primarySwatch: Colors.brown,
          ),
          home: ScreensController())));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return Home();
      default:
        return LoginScreen();
    }
  }
}