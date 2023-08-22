import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:batsexplorer/screens/splash_screen.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((res) => print("RES: $res"));

  runZonedGuarded(() {
    runApp(MyApp());
    // runApp(MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => ParkingHistoryProvider()),
    //     ChangeNotifierProvider(create: (_) => ParkingDetailsProvider()),
    //     ChangeNotifierProvider(create: (_) => PaymentsMethodProvider()),
    //   ],
    //   child: YourSecondHomeApp(),
    // ));
  }, (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: CustomColors.statusColor));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bats Explorer",
      theme: ThemeData(
        primaryColor: CustomColors.primaryColor,
        // accentColor: CustomColors.whiteColor,
        // toggleableActiveColor: Colors.white,
        unselectedWidgetColor: CustomColors.selectedColor,
        canvasColor: Colors.white,
      ),
      color: CustomColors.primaryAssentColor,
//          darkTheme: Constants.darkTheme,
      home: SplashScreen(),
    );
  }
}
