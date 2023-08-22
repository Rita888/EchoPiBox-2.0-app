import 'package:batsexplorer/models/info_item.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InfoScreenState();
  }
}

class InfoScreenState extends State<InfoScreen> {
  List<InfoItem> batsInfo = <InfoItem>[];

  @override
  void initState() {
    super.initState();
    // infoList();
  }

  // void infoList() {
  //   batsInfo.add(InfoItem("Alcathoe bat", "assets/images/alcathoe_bat.jpg"));
  //   batsInfo.add(InfoItem("Barbastelle", "assets/images/barbastelle_bat.jpg"));
  //   batsInfo
  //       .add(InfoItem("Bechstein’s bat", "assets/images/bechsteins_bat.jpg"));
  //   batsInfo.add(InfoItem("Brandt’s bat", "assets/images/brandts_bat.jpg"));
  //   batsInfo.add(InfoItem(
  //       "Brown long-eared bat", "assets/images/brown_long_eared_bat.jpg"));
  //   batsInfo.add(InfoItem(
  //       "Common pipistrelle", "assets/images/common_pipistrelle_bat.jpg"));
  //   batsInfo
  //       .add(InfoItem("Daubenton’s bat", "assets/images/daubentons_bat.jpg"));
  //   batsInfo.add(InfoItem(
  //       "Greater horseshoe bat", "assets/images/greater_horseshoe_bat.jpg"));
  //   batsInfo.add(InfoItem(
  //       "Grey long-eared bat", "assets/images/grey_long_eared_bat.jpg"));
  //   batsInfo.add(InfoItem("Leisler’s bat", "assets/images/leislers_bat.jpg"));
  //   batsInfo.add(InfoItem(
  //       "Lesser horseshoe bat", "assets/images/lesser_horseshoe_bat.jpg"));

  //   batsInfo.add(InfoItem("Nathusius’ pipistrelle",
  //       "assets/images/nathusius_pipistrelle_bat.jpg"));
  //   batsInfo.add(InfoItem("Natterer’s bat", "assets/images/natterers_bat.jpg"));
  //   batsInfo.add(InfoItem("Noctule", "assets/images/noctule_bat.jpg"));
  //   batsInfo.add(InfoItem("Serotine", "assets/images/serotine_bat.jpg"));
  //   batsInfo.add(InfoItem(
  //       "Soprano pipistrelle", "assets/images/soprano_pipistrelle_bat.jpg"));
  //   batsInfo.add(InfoItem("Whiskered bat", "assets/images/whiskered_bat.jpg"));
  //   batsInfo.add(InfoItem("Greater mouse-eared bat",
  //       "assets/images/greater_mouse_eared_bat.jpg"));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
            ),
            child: Text('Instruction')
            // Stack(
            //   children: [
            //     Positioned(
            //         top: 0,
            //         bottom: 0,
            //         left: 0,
            //         right: 0,
            //         child: Center(
            //             child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: <Widget>[
            //             Flexible(
            //                 child: GridView.builder(
            //                     // controller: scrollController,
            //                     gridDelegate:
            //                         const SliverGridDelegateWithMaxCrossAxisExtent(
            //                             maxCrossAxisExtent: 200,
            //                             mainAxisExtent: 200,
            //                             childAspectRatio: 3 / 2,
            //                             crossAxisSpacing: 20,
            //                             mainAxisSpacing: 10),
            //                     itemCount: batsInfo.length,
            //                     itemBuilder: (BuildContext ctx, index) {
            //                       return Container(
            //                           decoration: BoxDecoration(
            //                               color: CustomColors.backgroundColor,
            //                               borderRadius:
            //                                   BorderRadius.circular(15),
            //                               border: Border.all(
            //                                   color:
            //                                       CustomColors.primaryColor)),
            //                           child: GestureDetector(
            //                             child: Column(children: [
            //                               SizedBox(
            //                                 height: 20,
            //                               ),
            //                               Container(
            //                                   height: 150,
            //                                   alignment: Alignment.center,
            //                                   decoration: BoxDecoration(
            //                                     color: CustomColors
            //                                         .backgroundColor,
            //                                     borderRadius:
            //                                         BorderRadius.circular(15),
            //                                     // border: Border.all(
            //                                     //     color: Colors.black45)
            //                                   ),
            //                                   child: Stack(
            //                                     children: [
            //                                       ClipRRect(
            //                                         borderRadius:
            //                                             BorderRadius.circular(
            //                                                 15.0),
            //                                         child: Image.asset(
            //                                           batsInfo[index].img!,
            //                                           width: 150.0,
            //                                           height: 150.0,
            //                                           fit: BoxFit.cover,
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   )),
            //                               Container(
            //                                   // height: MediaQuery.of(context).size.height-150,
            //                                   padding: EdgeInsets.fromLTRB(
            //                                       10, 10, 10, 0),
            //                                   child: Align(
            //                                     alignment: Alignment.center,
            //                                     child: Text(
            //                                       batsInfo[index].name!,
            //                                       textAlign: TextAlign.center,
            //                                       maxLines: 2,
            //                                       overflow:
            //                                           TextOverflow.ellipsis,
            //                                       style: TextStyle(
            //                                           color: CustomColors
            //                                               .blackLightColor,
            //                                           fontSize: 14,
            //                                           fontWeight:
            //                                               FontWeight.bold),
            //                                     ),
            //                                   )),
            //                             ]),
            //                             onTap: () {},
            //                           ));
            //                     })),
            //           ],
            //         ))),
            //   ],
            // )),
        )
      ),
    );
  }
}
