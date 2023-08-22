
import 'package:batsexplorer/models/location_item.dart';
import 'package:batsexplorer/models/record_item.dart';
import 'package:batsexplorer/screens/location_screen.dart';
import 'package:batsexplorer/screens/main_screen.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/constants.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:batsexplorer/widgets/top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:page_transition/page_transition.dart';



class AddRecordScreen extends StatefulWidget {

  AddRecordScreen();


  @override
  State<StatefulWidget> createState() {
    return AddRecordScreenState();
  }
}

class AddRecordScreenState extends State<AddRecordScreen> {
  GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final commentsController = TextEditingController();
  LocationItem? loc;

  String? comments="";
  bool isLoading=false;
  String latitude="";
  String longitude="";
  String address="";
  String speciesValue = 'Alcathoe bat';
  String individualsValue = '1';
  String substrateValue = 'Block';

  List <String> speciesItems = [
    "Alcathoe bat",
    "Barbastelle",
    "Bechstein’s bat",
    "Brandt’s bat",
    "Brown long-eared bat",
    "Common pipistrelle",
    "Daubenton’s bat",
    "Greater horseshoe bat",
    "Grey long-eared bat",
    "Leisler’s bat",
    "Lesser horseshoe bat",
    "Nathusius’ pipistrelle",
    "Natterer’s bat",
    "Noctule",
    "Serotine",
    "Soprano pipistrelle",
    "Whiskered bat",
    "Greater mouse-eared bat",
    "Unknown"
  ] ;


  List <String> individualsItems = [
    "1",
    "2",
    "3",
    "4",
    "5",
        "6",
        "7",
        "8",
        "9",
        "10"
  ] ;




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
          child:Container(
          decoration: BoxDecoration(
            color: CustomColors.backgroundColor,
          ),
          child:
          Stack(children: [
            TopBar(
                "",
                "Add Record",
                "assets/images/back-arrow.png",
                "", () {
              returnBack();
            }, () {}, isActionButton: false),
            Positioned(
              top: 100,
              bottom: 0,
              left: 25,
              right: 25,
              child:
              Container(
                  child: SingleChildScrollView(
                    child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: _formStateKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Species: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                                DropdownButton<String>(
                                  value: speciesValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? data) {
                                    setState(() {
                                      speciesValue = data!;
                                    });
                                  },
                                  items: speciesItems.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Individuals: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),

                                DropdownButton<String>(
                                  value: individualsValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? data) {
                                    setState(() {
                                      individualsValue = data!;
                                    });
                                  },
                                  items: individualsItems.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Location: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                                SizedBox(
                                      width:150,
                                      child:
                                      TextButton(
                                        style: ButtonStyle(
                                          //splash color
                                          overlayColor: MaterialStateColor.resolveWith(
                                                  (states) => Colors.white.withOpacity(0.2)),
                                          // // text color
                                          foregroundColor:
                                          MaterialStateProperty.resolveWith<Color>(

                                                (Set<MaterialState> states) => Colors.white,
                                          ),
                                          // background color
                                          backgroundColor:
                                          MaterialStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) =>
                                            CustomColors.selectedColor,
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Select Location',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          navigateToMapScreen();
                                        },
                                      )),

                              ],
                            ),

                            SizedBox(height: 10,),
                            loc==null?SizedBox():Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Address: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                                    SizedBox(width: 10,),
                                    Expanded(child:
                                    Text(address, style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Latitude: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                                    SizedBox(width: 10,),
                                    Text(latitude, style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Longitude: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                                    SizedBox(width: 10,),
                                    Text(longitude, style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),),
                                  ],
                                ),

                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text("Comments: ", style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                                SizedBox(width: 20,),
                                Expanded(
                                  child:
                                  TextFormField(
                                    style: TextStyle(color: CustomColors.primaryColor, fontSize: 18),
                                      textCapitalization: TextCapitalization.sentences,
                                      validator: (value) {
                                        // if (value!.isEmpty) {
                                        //   return 'Please Enter Comments';
                                        // }
                                        // if (value.trim() == "")
                                        //   return "Only Space is Not Valid!!!";
                                        return null;
                                      },
                                      onSaved: (value) {
                                        comments = value!;
                                      },
                                      controller: commentsController,
                                      decoration: InputDecoration(
                                          focusedBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: CustomColors.primaryColor,
                                                  width: 2,
                                                  style: BorderStyle.solid)),
                                          disabledBorder: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: CustomColors.primaryColor,
                                                  width: 2,
                                                  style: BorderStyle.solid)),
                                          // hintText: "Student Name",
                                          fillColor: Colors.white,
                                          labelStyle: TextStyle(
                                            color: CustomColors.primaryColor,
                                          ))),
                                ),

                              ],
                            ),







                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width:150,
                            child:
                            TextButton(
                                style: ButtonStyle(
                                  //splash color
                                  overlayColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.white.withOpacity(0.2)),
                                  // // text color
                                  foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(

                                        (Set<MaterialState> states) => Colors.white,
                                  ),
                                  // background color
                                  backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) =>
                                    CustomColors.selectedColor,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.white),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                              'Add Record',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                                if (_formStateKey.currentState!.validate()) {
                                  _formStateKey.currentState!.save();
                                  showLoader();
                                  try {

                                    final RecordItem record = new RecordItem();

                                    record.species = speciesValue;
                                    record.individuals = individualsValue;
                                    record.placeAddress = address;
                                    record.placeLatitude = latitude;
                                    record.placeLongitude = longitude;
                                    record.comments = comments!;
                                    // record.timeStamp=FieldValue.serverTimestamp();
                                    FirebaseFirestore.instance
                                        .collection("records")
                                        .doc(
                                      AppState.userId,
                                    )
                                        .collection("records")
                                        .doc()
                                        .set(
                                      record.toMap(),
                                    );
                                    sendEmail(record);
                                  }catch(ex){
                                    hideLoader();
                                    debugPrint(ex.toString());
                                  }
                                }
                              }
                          )),
                        ],
                      ),
                      const Divider(
                        height: 5.0,
                      ),

                      SizedBox(height: 20,),

                    ],))

              )),

          ],)



        ),
      ),
    );
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

  Future<void> navigateToMapScreen() async {
    loc = await Navigator.push(context, PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: LocationScreen()));
    if (loc != null) {

        setState(() {
          latitude = loc!.addressLatlng.latitude.toString();
          longitude = loc!.addressLatlng.longitude.toString();
          address = loc!.address;

        });
    }
  }

  void sendEmail(RecordItem recordItem) async {
    String username = Constants.EMAIL_ADDRESS;
    String password = Constants.PASS;
    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'BatsExplorer')
      ..recipients.add(Constants.RECIPIENT)
      ..subject = 'New Record Added}'
      ..text = 'Species: '+recordItem.species+"\n"
          'Individuals: '+recordItem.individuals+"\n"
          'Address: '+recordItem.placeAddress+"\n"
          'Latitude: '+recordItem.placeLatitude+"\n"
          'Longitude: '+recordItem.placeLongitude+"\n"
          'Comments: '+recordItem.comments+"\n";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      hideLoader();
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: MainScreen(2)));
    } on MailerException catch (e) {
      hideLoader();
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}