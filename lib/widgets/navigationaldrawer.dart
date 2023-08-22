import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';


class NavigationalDrawer {
  static String _url = 'https://thenewportparking.com/privacy-policy/';

  static Widget navigationDrawer(BuildContext context) {
    return new Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(height: 15,),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(5),
                            width: 70,
                            height: 70,
                            margin: EdgeInsets.all(5),
                            // decoration: BoxDecoration(
                            //   color: Colors.black,
                            //   border: Border.all(
                            //       color: Colors.grey,// set border color
                            //       width: 1.0),   // set border width
//                        borderRadius: BorderRadius.all(
//                            Radius.circular(10.0)), // set rounded corner radius
//                                 shape: BoxShape.circle,
//                               ),
                            child: Image.asset(
                              "assets/images/app-icon.png",
                              fit: BoxFit.fitHeight,
                              width: 60,
                              height: 60,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppState.fullname != null
                                      ? AppState.fullname
                                      : "NewPort User",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  AppState.email != null
                                      ? AppState.email
                                      : "newport@gmail.com",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                  maxLines: 1,
                                ),
                              ],
                            ))
                      ])
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: CustomColors.primaryColor,
            )),
        ListTile(
          title: Text(
            "Services",
            style: TextStyle(color: CustomColors.primaryColor, fontSize: 16),
          ),
          leading: Icon(
            Icons.person,
            color: CustomColors.primaryColor,
          ),
          onTap: () {
          //   Navigator.push(
          //       context,
          //       PageTransition(
          //           type: PageTransitionType.fade, child: ProfileScreen()));
          //   // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: NotificationScreen()));;
          },
        ),
        ListTile(
          title: Text(
            "Blogs",
            style: TextStyle(color: CustomColors.primaryColor, fontSize: 16),
          ),
          leading: Icon(
            Icons.history,
            color: CustomColors.primaryColor,
          ),
          onTap: () {
            // Navigator.push(
            //     context,
            //     PageTransition(
            //         type: PageTransitionType.fade,
            //         child: ParkingHistoryScreen()));
          },
        ),
        ListTile(

          title: Text("Partners",style: TextStyle(color: CustomColors.primaryColor,fontSize: 16),),
          leading: Icon(Icons.payment,color: CustomColors.primaryColor,),
          onTap: () {
            // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PaymentMethodsScreen()));
          },
        ),
        ListTile(
          title: Text(
            "About us",
            style: TextStyle(color: CustomColors.primaryColor, fontSize: 16),
          ),
          leading: Icon(
            Icons.info,
            color: CustomColors.primaryColor,
          ),
          onTap: () {
            // launchURL();
            // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MessengerScreen()));;
          },
        ),
        ListTile(
          title: Text(
            "Contact us",
            style: TextStyle(color: CustomColors.primaryColor, fontSize: 16),
          ),
          leading: Icon(
            Icons.privacy_tip,
            color: CustomColors.primaryColor,
          ),
          onTap: () {
            // launchURL();
            // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MessengerScreen()));;
          },
        ),

      ],
    ));
  }

}
