import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'package:page_transition/page_transition.dart';
import 'package:batsexplorer/screens/main_screen.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loader();
  }

  Future<Timer> loader() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: MainScreen(0)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: CustomColors.backgroundColor,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/logo_transparent_black.png',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rita Smoldareva BSc (Hons), PGDip.',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          'Ecologist - Qualifying Member CIEEM, ALI, AEIMA.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
