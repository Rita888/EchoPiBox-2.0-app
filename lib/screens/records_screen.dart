import 'package:batsexplorer/models/record_item.dart';
import 'package:batsexplorer/screens/add_record_screen.dart';
import 'package:batsexplorer/screens/main_screen.dart';
import 'package:batsexplorer/tiles/records_tile.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RecordsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecordsScreenState();
  }
}

class RecordsScreenState extends State<RecordsScreen> {
  @override
  void initState() {
    super.initState();
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
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.contain,
                          )),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            backgroundColor: CustomColors.selectedColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onPressed: () {
                            AppState.isLogin = false;
                            AppState.logout().then((value) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: MainScreen(2)));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 150,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: recordList()),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: CustomColors.primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: AddRecordScreen()));
          },
        ),
      ),
    );
  }

  void returnBack() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: MainScreen(2),
      ),
    );
  }

  Widget recordList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("records")
          .doc(
            AppState.userId,
          )
          .collection("records")
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
            ),
          );
        } else {
          final QuerySnapshot<Map<String, dynamic>>? querySnapshot =
              snapshot.data;

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            // itemBuilder: (context, index) => ChatStyle(ChatItem.fromMap(snapshot.data.documents[index].data as Map<String,dynamic>)  ),
            // itemCount: snapshot.data.documents.length as int,
            itemBuilder: (context, index) => RecordsTile(
              RecordItem.fromMap(querySnapshot!.docs[index].data()),
            ),
            itemCount: querySnapshot!.size,
          );
        }
      },
    );
  }
}
