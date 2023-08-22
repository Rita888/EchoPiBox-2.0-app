
import 'package:flutter/material.dart';
import 'package:batsexplorer/utils/customcolors.dart';

typedef BackCallback = void Function();
typedef OperationCallback = void Function();

class TopBar extends StatefulWidget {
  final String userType;
  final String title;
  final String prefixIcon;
  final String suffixIcon;
  final BackCallback backCallback;
  final OperationCallback operationCallback;
  final bool isActionButton;
  const TopBar(
      this.userType,
      this.title,
      this.prefixIcon,
      this.suffixIcon,
      this.backCallback,
      this.operationCallback,
      {required this.isActionButton});

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        backgroundColor: CustomColors.selectedColor,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            widget.prefixIcon,
            height: 25,
            width: 25,
            color: CustomColors.whiteColor,
          ),
          onPressed: () {
            widget.backCallback();
          },
        ),
        titleSpacing: 0.0,
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(
              fontSize: 20.0,
              color: CustomColors.whiteColor,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          if (widget.isActionButton)
            IconButton(
              icon: Image.asset(
                widget.suffixIcon,
                height: 20,
                width: 20,
                color: CustomColors.selectedColor,
              ),
              onPressed: () {
                widget.operationCallback();
              },
            )
          else
            const SizedBox()
        ],
      ),
    );
  }
}
