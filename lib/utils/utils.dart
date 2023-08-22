import 'package:batsexplorer/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String timeStampToTime(Timestamp timestamp) {
    if (timestamp != null) {
      final inputDate = DateTime.tryParse(
        timestamp.toDate().toString(),
      );
      final outputFormat = DateFormat('hh:mm a');
      final outputDate = outputFormat.format(inputDate!);
      return outputDate;
    } else {
      return "";
    }

    // return date;
  }

  static void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static int getCurrentTime() {
    DateTime dateTime = DateTime.now();
    return dateTime.millisecondsSinceEpoch;
  }

  static String getBatImage(String batType) {
    String imagePath = "assets/images/logo.png";
    switch (batType) {
      case Constants.ALCATHOE_BAT:
        imagePath = "assets/images/alcathoe_bat.jpg";
        break;
      case Constants.BARBASTELLE_BAT:
        imagePath = "assets/images/barbastelle_bat.jpg";
        break;
      case Constants.BECHSTEIN_BAT:
        imagePath = "assets/images/bechsteins_bat.jpg";
        break;
      case Constants.BRANDT_BAT:
        imagePath = "assets/images/brandts_bat.jpg";
        break;
      case Constants.BROWN_LONG_EARED_BAT:
        imagePath = "assets/images/brown_long_eared_bat.jpg";
        break;
      case Constants.COMMON_PIPISTRELLE_BAT:
        imagePath = "assets/images/common_pipistrelle_bat.jpg";
        break;
      case Constants.DAUBENTON_BAT:
        imagePath = "assets/images/daubentons_bat.jpg";
        break;
      case Constants.GREATER_HORSE_SHOE_BAT:
        imagePath = "assets/images/greater_horseshoe_bat.jpg";
        break;
      case Constants.GREATER_MOUSE_EARED_BAT:
        imagePath = "assets/images/greater_mouse_eared_bat.jpg";
        break;
      case Constants.GREY_LONG_EARED_BAT:
        imagePath = "assets/images/grey_long_eared_bat.jpg";
        break;
      case Constants.LEISLER_BAT:
        imagePath = "assets/images/leislers_bat.jpg";
        break;
      case Constants.LESSER_HORSESHOE_BAT:
        imagePath = "assets/images/lesser_horseshoe_bat.jpg";
        break;
      case Constants.NATHUSIUS_PIPISTRELLE_BAT:
        imagePath = "assets/images/nathusius_pipistrelle_bat.jpg";
        break;
      case Constants.NATTERRER_BAT:
        imagePath = "assets/images/natterers_bat.jpg";
        break;
      case Constants.NOCTULE_BAT:
        imagePath = "assets/images/noctule_bat.jpg";
        break;
      case Constants.SEROTINE_BAT:
        imagePath = "assets/images/serotine_bat.jpg";
        break;
      case Constants.SOPRANO_PIPISTRELLE_BAT:
        imagePath = "assets/images/soprano_pipistrelle_bat.jpg";
        break;
      case Constants.WHISKERED_BAT:
        imagePath = "assets/images/whiskered_bat.jpg";
        break;
    }
    return imagePath;
  }
}
