import 'package:batsexplorer/models/record_item.dart';
import 'package:batsexplorer/screens/view_record_screen.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:batsexplorer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RecordsTile extends StatelessWidget {
  const RecordsTile(this.record);
  final RecordItem record;

  @override
  Widget build(BuildContext context) {
    String timestamp = record.timeStamp == null
        ? ""
        : Utils.timeStampToTime(record.timeStamp!);
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          border: Border.all(color: CustomColors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.asset(
                    Utils.getBatImage(record.species),
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        child: Row(
                          children: [
                            Text(
                              record.species,
                              style: const TextStyle(
                                  color: CustomColors.blackLightColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            timestamp,
                            style: const TextStyle(
                                color: CustomColors.blackLightColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ]),
            ]),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ViewRecordScreen(record)));
      },
    );
  }
}
