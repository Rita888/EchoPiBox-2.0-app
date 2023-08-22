import 'dart:async';

import 'package:batsexplorer/models/sensor_item.dart';
import 'package:batsexplorer/screens/add_sensor_data.dart';
import 'package:batsexplorer/tiles/videos_tile.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:string_validator/string_validator.dart' as sV;
import 'package:video_player/video_player.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorData {
  final double humidity;
  final double lux;
  final double temperature;
  final String timestamp;

  SensorData(this.humidity, this.lux, this.temperature, this.timestamp);
}

class BatData {
  final String id;
  final String species_name;
  final double class_probability;
  final double soundevent_end_time;
  final double soundevent_probability;
  final double soundevent_start_time;

  BatData(
      this.id,
      this.species_name,
      this.class_probability,
      this.soundevent_end_time,
      this.soundevent_probability,
      this.soundevent_start_time);
}

class DataScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DataScreenState();
  }
}

class DataScreenState extends State<DataScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  static const double _defaultLat = 51.50;
  static const double _defaultLong = -0.127;

  late CameraPosition _defaultLocation =
      CameraPosition(target: LatLng(_defaultLat, _defaultLong), zoom: 13);
  final Set<Marker> _markers = {};

  // section 1
  double humidity = 0;
  double temperature = 0;
  double lux = 0;
  String timestamp = '';
  String timestampGPS = '';
  String timestampBAT = '';

  // section 2
  double latitude = 51.50;
  double longitude = -0.127;

  Map<String, dynamic> sensorData = {};
  String batName = '';
  double batAccuracy = 0;
  List<BatData> batData = [];
  List<SensorItem> _mqttSensors = <SensorItem>[];
  late VideoPlayerController controller;
  String broker = 'mqtt.cetools.org';
  int port = 1883;
  String clientIdentifier = 'mqtt-bats-explorer';
  // String clientIdentifier = '';

  mqtt.MqttClient? client;
  mqtt.MqttConnectionState? connectionState;

  // String _topic = "UCL/QEOP/bats/bat5";

  // String _topic = "student/CASA0014/plant";
  String _topic = "UCL/PSW/Garden/WST/dvp2";

  StreamSubscription? subscription;

  bool _sensorInList = false;

  //late ProgressHUD _progressHUD;
  bool _loading = true;

  int dissmissView = 0;

  late GoogleMapController _googleMapController;

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      client!.subscribe(topic, mqtt.MqttQos.exactlyOnce);
      subscription = client!.updates!.listen(_onMessage);
    }
  }

  List<String> srcs = [
    "assets/videos/video_1.mp4",
    "assets/videos/video_1.mp4",
  ];

  @override
  void initState() {
    super.initState();

    _populateSensorList();
    _startRealtimeListener();
  }

  @override
  void dispose() {
    dissmissView = 1;
    if (client!.connectionState == mqtt.MqttConnectionState.connected) {
      _disconnect();
    }

    super.dispose();
  }

  void _populateSensorList() {
    _connect();
  }

  void _startRealtimeListener() {
    // section 1 => Sensor Data
    ref.child('/Temperature').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as double;
        setState(() {
          temperature = value;
        });
      } else {
        print('No data available.');
      }
    });
    ref.child('/Humidity').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as double;
        setState(() {
          humidity = value;
        });
      } else {
        print('No data available.');
      }
    });
    ref.child('/Lux').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as double;
        setState(() {
          lux = value;
        });
      } else {
        print('No data available.');
      }
    });
    ref.child('/Timestamp').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as String;
        setState(() {
          timestamp = value;
        });
      } else {
        print('No data available.');
      }
    });

    // section 2 => GPS DATA
    ref.child('/Latitude').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as double;
        setState(() {
          latitude = value;

          _defaultLocation = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          );
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('defaultLocation'),
              position: LatLng(latitude, longitude),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
          _updateCameraPosition();
        });
      } else {
        print('No data available.');
      }
    });
    ref.child('/Longitude').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as double;
        setState(() {
          longitude = value;

          _defaultLocation = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          );
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('defaultLocation'),
              position: LatLng(latitude, longitude),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
          _updateCameraPosition();
        });
      } else {
        print('No data available.');
      }
    });
    ref.child('/TimestampGPS').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as String;
        setState(() {
          timestampGPS = value;
        });
      } else {
        print('No data available.');
      }
    });

    // section 3 => Bat DATA
    ref.child('/batData').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as List<dynamic>;
        setState(() {
          batData = value.map((dynamic item) {
            return BatData(
                item['id'] ?? '',
                item['species_name'] ?? '',
                item['class_probability'] ?? '',
                item['soundevent_end_time'] ?? '',
                item['soundevent_probability'] ?? '',
                item['soundevent_start_time'] ?? '');
          }).toList();
        });
      } else {
        print('No data available.');
      }
    });
    ref.child('/TimestampBat').onValue.listen((event) {
      if (event.snapshot.exists) {
        final value = event.snapshot.value as String;
        setState(() {
          timestampBAT = value;
        });
      } else {
        print('No data available.');
      }
    });
  }

  void _updateCameraPosition() {
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_defaultLocation));
  }

  ListTile _buildItemsForListView(BuildContext context, int i) {
    return ListTile(
      leading: new CircleAvatar(child: Text("$i")),
      title: new Text("Device Name"),
      subtitle: new Text("Last Message: " +
          new DateFormat("dd-MM-yyyy HH:mm:ss")
              .format(_mqttSensors[i].lastMessage!)),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: Color.fromRGBO(58, 66, 86, 1.0), size: 30.0),
      isThreeLine: true,
      onTap: () {
        // Navigator.pushNamed(context, MQTTDetail.routeName,
        //     arguments: _mqttSensors[i]);
      },
      onLongPress: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         'assets/images/logo_transparent_black.png',
                //         height: 90,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
                const Text(
                  'Sensor Data',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'As of $timestamp',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 180,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Temp.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Image.asset(
                            'assets/images/iconTemperature.png',
                            width: 50,
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                temperature.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '° C',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xfeb56291), Color(0xfe7c5e90)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black38,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 180,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Humid.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Image.asset(
                            'assets/images/iconHumidity.png',
                            width: 50,
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                humidity.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '% RH',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xfef78a55),
                            Color(0xfee36e79)
                          ], // Specify your gradient colors
                          begin: Alignment
                              .topLeft, // Optional: Define the starting point of the gradient
                          end: Alignment
                              .bottomRight, // Optional: Define the ending point of the gradient
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black38,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 180,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Light',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Image.asset(
                            'assets/images/iconLight.png',
                            width: 48,
                            height: 48,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                lux.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'lux',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xfe48567b),
                            Color(0xfe2e4859)
                          ], // Specify your gradient colors
                          begin: Alignment
                              .topLeft, // Optional: Define the starting point of the gradient
                          end: Alignment
                              .bottomRight, // Optional: Define the ending point of the gradient
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
                // const Text(
                //   'Updated on:',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.black87,
                //   ),
                // ),
                // Text(
                //   timestamp,
                //   style: const TextStyle(
                //     fontSize: 16,
                //     color: Colors.black87,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'GPS Data',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'As of $timestampGPS',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GoogleMap(
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    initialCameraPosition: _defaultLocation,
                    markers: _markers,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Bat\'s Classification Data',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'As of $timestampBAT',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 220,
                        width: MediaQuery.of(context).size.width - 40,
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Bat\'s species',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/iconBat.png',
                                  width: 40,
                                  height: 40,
                                ),
                                const Text(
                                  'Accuracy (%)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: ListView.builder(
                                  itemCount: batData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            batData[index].species_name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            ((batData[index]
                                                        .class_probability) *
                                                    100)
                                                .toStringAsFixed(0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                        // title: Text(batData[index].species_name),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xfef78a55), Color(0xfee36e79)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dismissProgressHUD() {
    setState(() {
      // if (_loading) {
      //   _progressHUD.state.dismiss();
      // } else {
      //   _progressHUD.state.show();
      // }

      _loading = !_loading;
    });
  }

  void _connect() async {
    client = MqttServerClient(broker, '');
    client!.port = port;

    client!.logging(on: false);
    client!.keepAlivePeriod = 30;

    client!.onDisconnected = _onDisconnected;

    dissmissView = 0;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);

    client!.connectionMessage = connMess;

    try {
      await client!.connect();
    } catch (e) {
      dismissProgressHUD();
      _disconnect();
    }

    /// Check if we are connected
    if (client!.connectionState == mqtt.MqttConnectionState.connected) {
      dismissProgressHUD();
      setState(() {
        connectionState = client!.connectionState;
      });
    } else {
      _disconnect();
    }

    // subscription = client!.updates!.listen(_onMessage);
    _subscribeToTopic(_topic);
    // subscription = client!.updates!.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage?>>? c) {
    //   final recMess = c![0].payload as mqtt.MqttPublishMessage;
    //   final pt =
    //   mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    //
    //   /// The above may seem a little convoluted for users only interested in the
    //   /// payload, some users however may be interested in the received publish message,
    //   /// lets not constrain ourselves yet until the package has been in the wild
    //   /// for a while.
    //   /// The payload is a byte buffer, this will be specific to the topic
    //   print(
    //       'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    //   print('');
    // });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    client!.published!.listen((mqtt.MqttPublishMessage message) {});
  }

  void _disconnect() {
    client!.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    if (dissmissView != 1) {
      setState(() {
        if (client != null) {
          connectionState = client!.connectionState;
        }
        client = null;
        if (subscription != null) {
          subscription!.cancel();
        }
        subscription = null;
      });
    } else {
      if (client != null) {
        connectionState = client!.connectionState;
      }

      client = null;
      if (subscription != null) {
        subscription!.cancel();
      }
      subscription = null;
    }

    if (dissmissView != 1) {
      dismissProgressHUD();
    }
  }

  void _onMessage(List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> event) {
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    SensorItem s = new SensorItem(event[0].topic);
    _sensorInList = false;

    Map? decodedJSON;

    try {
      if (!sV.isNumeric(message)) {
        //decodedJSON = jsonDecode(message);
      }
    } on Exception catch (e) {}

    if (decodedJSON != null) {
      String? host = decodedJSON['host'];
      String? ip = decodedJSON['ip'];
      String? mac = decodedJSON['mac'];

      s.ip = ip!;
      s.host = host!;
      s.macAddress = mac!;

      for (var i = 0; i < _mqttSensors.length; i++) {
        if (_mqttSensors[i].macAddress == s.macAddress) {
          _sensorInList = true;
          setState(() {
            // _mqttSensors[i].updateLastMessage();
            // _mqttSensors[i].updateLastMessageJSON(message);
          });
        }
      }

      setState(() {
        //Check if Sensor is in the list
        if (!_sensorInList) {
          // s.updateLastMessage();
          // s.updateLastMessageJSON(message);
          _mqttSensors.insert(0, s);
        }
        _sensorInList = false;
      });
    }
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
