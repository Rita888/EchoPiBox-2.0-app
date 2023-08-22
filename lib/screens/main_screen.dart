import 'package:batsexplorer/screens/accuracy_screen.dart';
import 'package:batsexplorer/screens/bats_screen.dart';
import 'package:batsexplorer/screens/data_screen.dart';
import 'package:batsexplorer/screens/instructions_screen.dart';
import 'package:batsexplorer/screens/login_screen.dart';
import 'package:batsexplorer/screens/records_screen.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  final int index;
  MainScreen(this.index);

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController? controller;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget>? screens;
  Widget? currentScreen;
  int _selectedIndex = 0;
  Widget selectedWidget = LoginScreen();

  void _onItemTapped(int index) {
    setState(() {
      if (index == 3) {
        if (AppState.isLogin) {
          screens = [
            DataScreen(),
            InstructionsScreen(),
            BatsScreen(),
            // RecordsScreen(),
            AccuracyScreen(),
          ];
          selectedWidget = RecordsScreen();
        } else {
          screens = [
            DataScreen(),
            InstructionsScreen(),
            BatsScreen(),
            // LoginScreen(),
            AccuracyScreen(),
          ];
          // selectedWidget=LoginScreen();
        }
        _selectedIndex = index;
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppState.synchronizeSettingsFromPhone().then((value) {
      if (AppState.isLogin) {
        selectedWidget = RecordsScreen();
      } else {
        selectedWidget = LoginScreen();
      }
    });

    setState(() {
      if (AppState.isLogin) {
        screens = [
          DataScreen(),
          InstructionsScreen(),
          BatsScreen(),
          // RecordsScreen(),
          AccuracyScreen(),
        ];
      } else {
        screens = [
          DataScreen(),
          InstructionsScreen(),
          BatsScreen(),
          // LoginScreen(),
          AccuracyScreen(),
        ];
      }

      _selectedIndex = widget.index;
    });
    controller = TabController(length: 5, vsync: this);
    controller!.animateTo(_selectedIndex,
        duration: Duration(seconds: 1), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    // other dispose methods
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        child: screens?.elementAt(_selectedIndex),
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.query_stats,
                  text: 'Live Data',
                ),
                GButton(
                  icon: Icons.integration_instructions_outlined,
                  text: 'Instruction',
                ),
                GButton(
                  icon: Icons.info_outline_rounded,
                  text: 'Bats Info',
                ),
                GButton(
                  icon: Icons.landscape_outlined,
                  text: 'Survey',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      // Container(
      //   decoration: const BoxDecoration(color: Colors.white),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Divider(
      //         thickness: 1,
      //       ),
      //       PreferredSize(
      //           preferredSize: Size(double.infinity, 50),
      //           child: TabBar(
      //             controller: controller,
      //             unselectedLabelColor: CustomColors.unselectedColor,
      //             labelColor: CustomColors.selectedColor,
      //             labelStyle:
      //                 TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      //             unselectedLabelStyle:
      //                 TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      //             onTap: (index) {
      //               _onItemTapped(index);
      //             },
      //             tabs: [
      //               _individualTab('Data', 0),
      //               _individualTab('Instructions', 1),
      //               _individualTab('Bats', 2),
      //               _individualTab('Records', 3),
      //               _individualTab('Accuracy', 4),
      //             ],
      //           ))
      //     ],
      //   ),
      // ),
    );
  }

  Widget _individualTab(String title, int index) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Tab(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
