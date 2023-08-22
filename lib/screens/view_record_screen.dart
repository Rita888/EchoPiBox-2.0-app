import 'package:batsexplorer/models/record_item.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:batsexplorer/utils/utils.dart';
import 'package:batsexplorer/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ViewRecordScreen extends StatefulWidget {
  RecordItem record;
  ViewRecordScreen(this.record);

  @override
  State<StatefulWidget> createState() {
    return ViewRecordScreenState();
  }
}

class ViewRecordScreenState extends State<ViewRecordScreen> {
  GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        color: CustomColors.blackLightColor,
        progressIndicator: const CircularProgressIndicator(
          backgroundColor: CustomColors.primaryColor,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        child: Container(
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
            ),
            child: Stack(
              children: [
                TopBar("", "View Record Detail", "assets/images/back-arrow.png",
                    "", () {
                  returnBack();
                }, () {}, isActionButton: false),
                Positioned(
                    top: 100,
                    bottom: 0,
                    left: 25,
                    right: 25,
                    child: isLoading ? SizedBox() : body()),
              ],
            )),
      ),
    );
  }

  Widget body() {
    return Container(
        child: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // widget.record.species == Constants.UNKNOWN_BAT
        //     ? SizedBox()
        //     :
        Column(children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              child: Image.asset(
                Utils.getBatImage(widget.record.species),
                // width: 150.0,
                // height: 150.0,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 50,
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Species:",
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.record.species,
              style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Individuals:",
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.record.individuals,
              style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Address: ",
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.record.placeAddress,
              style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Latitude: ",
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.record.placeLatitude,
              style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Longitude: ",
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.record.placeLongitude,
              style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
            )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  "Comments: ",
                  style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              widget.record.comments,
              style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
            )),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        const Divider(
          height: 5.0,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    )));
  }

  void returnBack() {
    Navigator.pop(context);
  }

  void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showLoader() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoader() {
    setState(() {
      isLoading = false;
    });
  }
}
