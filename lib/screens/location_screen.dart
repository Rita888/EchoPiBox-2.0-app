import 'dart:async';
import 'dart:ui';

import 'package:batsexplorer/models/location_item.dart';
import 'package:batsexplorer/utils/appstate.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:batsexplorer/utils/utils.dart';
import 'package:batsexplorer/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen();

  @override
  State<StatefulWidget> createState() {
    return _LocationScreenState();
  }
}

class _LocationScreenState extends State<LocationScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  TextEditingController? _locationAddressController;

  String locationAddress = "";
  LatLng? _lastMapPosition;
  LocationData? lastLoc;
  bool currLoc = false;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        debugPrint('appLifeCycleState resumed');
        _initMapStyle();
        break;
      case AppLifecycleState.paused:
        debugPrint('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        break;
    }
  }

  Future<void> _initMapStyle() async {
    await _mapController!.setMapStyle("[]");
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastMapPosition = position.target;
      // getLocationAddress(position.target).then((value) {
      //   _locationAddressController.text=value;
      // });
    });
  }

  Future<void> onCameraIdle() async {
    setState(() {
//      locationAddress=getLocationAddress(_lastMapPosition);
//     if(!currLoc) {
      if (_lastMapPosition != null) {
        getLocationAddress(_lastMapPosition!).then((value) {
          _locationAddressController!.text = value;
        });
      }

      // }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationAddressController = TextEditingController(text: "");
//    _locationAddressController.addListener(onCameraIdle);
    if (AppState.currentLocationLatitude != null &&
        AppState.currentLocationLongitude != null) {
      setState(() {
        getLocationAddress(LatLng(AppState.currentLocationLatitude,
                AppState.currentLocationLongitude))
            .then((value) {
          _locationAddressController!.text = value;
        });
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // other dispose methods
    _locationAddressController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        body: Center(
            child: Stack(children: <Widget>[
          TopBar("", "Set Location", "assets/images/back-arrow.png", "", () {
            returnBack();
          }, () {}, isActionButton: false),
          Positioned(
              top: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        onTap: (latLng) {
                          setState(() {
                            getLocationAddress(latLng).then((address) {
                              _locationAddressController!.text = address;
                              animateCamera(latLng);
                            });
                          });
                        },
                        onMapCreated: _onMapCreated,
                        onCameraMove: _onCameraMove,
                        onCameraIdle: onCameraIdle,
                        initialCameraPosition: CameraPosition(
                          target: gotoCurrent(),
                          zoom: 16.0,
                        ),
                      ),
                      locAddressBox(),
                      Center(
                        child: Image.asset(
                          "assets/images/marker_target.png",
                          width: 50,
                          height: 50,
                        ),
                        // Icon(Icons.person_pin_circle, color: CustomColors.primaryColor,
                        //   size: 50,),
                      ),
                      saveLocationButton(),
                      currentLocationButton()
                    ],
                  ))),
        ])));
  }

  void returnBack() {
    Navigator.pop(context, null);
  }

  Widget locAddressBox() {
    return Container(
        padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
        width: double.infinity,
        child: SizedBox(
            height: 75,
            width: double.infinity,
            child: TextField(
              controller: _locationAddressController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              maxLines: 2,
              style: const TextStyle(
                  color: CustomColors.blackLightColor, fontSize: 15.0),
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
                hintText: "",
                hintStyle: TextStyle(
                    color: CustomColors.blackLightColor, fontSize: 15.0),
//                                errorText: Authenticator.validateEmail(emailCtrl.text),

                contentPadding: EdgeInsets.fromLTRB(25.0, 25.0, 0.0, 0.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black87, width: 0.0),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black87, width: 0.0),
                ),
              ),
            )));
  }

  Widget saveLocationButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding:
                const EdgeInsets.only(bottom: 30.0, right: 20.0, left: 20.0),
            width: 250,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: StreamBuilder(
                builder: (context, snapshot) => TextButton(
                  style: ButtonStyle(
                    //splash color
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(0.2)),
                    // // text color
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => Colors.white,
                    ),
                    // background color
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => CustomColors.selectedColor,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Set Location",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    setNewLocation();
                  },
                ),
              ),
            )));
  }

  Widget currentLocationButton() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(bottom: 100.0, right: 10),
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                _currentLocation();
              }, // handle your image tap here
              child: Image.asset(
                "assets/images/icon_my_location.png",
                fit: BoxFit.scaleDown, // this is the solution for border
                width: 60.0,
                height: 60.0,
              ),
            )));
  }

  Future<void> _currentLocation() async {
    currLoc = true;
    animateCamera(LatLng(
        AppState.currentLocationLatitude, AppState.currentLocationLongitude));

    setState(() {
      getLocationAddress(LatLng(AppState.currentLocationLatitude,
              AppState.currentLocationLongitude))
          .then((value) {
        _locationAddressController!.text = value;
      });
      currLoc = false;
    });
  }

  void animateCamera(LatLng loc) {
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: loc,
        zoom: 16.0,
      ),
    ));
  }

  void setNewLocation() {
    if (_locationAddressController!.text.isNotEmpty) {
      final LocationItem locationSelection = LocationItem(
          _locationAddressController!.text,
          LatLng(_lastMapPosition!.latitude, _lastMapPosition!.longitude));
      Navigator.pop(context, locationSelection);
    } else {
      Utils.showSnackBar(
          context, "Location address is empty, select location again");
    }
  }

  LatLng gotoCurrent() {
    return LatLng(
        AppState.currentLocationLatitude, AppState.currentLocationLongitude);
  }

  Future<String> getLocationAddress(LatLng currentLocation) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    final first = placemarks.first;
    debugPrint(
        ' ${first.locality}, ${first.administrativeArea},${first.subLocality}, ${first.subAdministrativeArea} ,${first.thoroughfare}, ${first.subThoroughfare}');
    // return locationAddress='${first.street}, ${first.locality}, ${first.country}';
    String name = first.name!;
    String subLocality = first.subLocality!;
    String locality = first.locality!;
    String administrativeArea = first.administrativeArea!;
    String postalCode = first.postalCode!;
    String country = first.country!;
    return locationAddress =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
  }
}
