import 'package:batsexplorer/tiles/videos_tile.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VideoScreenState();
  }
}

class VideoScreenState extends State<VideoScreen> {
  List<String> srcs = [
    "assets/videos/video_1.mp4",
    "assets/videos/video_2.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
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
                    child: SingleChildScrollView(child: videosList())),
              ],
            )),
      ),
    );
  }

  Widget videosList() {
    return Container(
        // height: 150,
        child: ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => VideosTile(srcs[index]),
      itemCount: srcs.length,
    ));
  }
}
