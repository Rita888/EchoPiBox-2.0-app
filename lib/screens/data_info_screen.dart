import 'package:batsexplorer/utils/customcolors.dart';
import 'package:flutter/material.dart';

class DataInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DataInfoScreenState();
  }
}

class DataInfoScreenState extends State<DataInfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 10,
                  right: 0,
                  child: Center(),
                ),
              ],
            )),
      ),
    );
  }
}
