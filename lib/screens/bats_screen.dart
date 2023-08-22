import 'dart:async';

import 'package:batsexplorer/models/info_item.dart';
import 'package:batsexplorer/models/sensor_item.dart';
import 'package:batsexplorer/screens/info_screen.dart';
import 'package:batsexplorer/tiles/videos_tile.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:string_validator/string_validator.dart' as sV;
import 'package:video_player/video_player.dart';

class BatsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BatsScreenState();
  }
}

class BatsScreenState extends State<BatsScreen> {
  List<SensorItem> _mqttSensors = <SensorItem>[];
  List<InfoItem> batsInfo = <InfoItem>[];
  late VideoPlayerController controller;
  String broker = 'mqtt.cetools.org';
  int port = 1883;
  String clientIdentifier = 'mqtt-bats-explorer';
  // String clientIdentifier = '';

  int _currentIndex = 0;

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

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ' + broker + ':\t ${topic.trim()}');
      client!.subscribe(topic, mqtt.MqttQos.exactlyOnce);
      subscription = client!.updates!.listen(_onMessage);
    }
  }

  List<String> srcs = [
    "assets/videos/video_1.mp4",
    "assets/videos/video_2.mp4",
  ];

  @override
  void initState() {
    super.initState();
    infoList();
    _populateSensorList();
  }

  void infoList() {
    batsInfo.add(InfoItem(
        "Alcathoe bat", "assets/images/alcathoe_bat.jpg", "Myotis alcathoe"));
    batsInfo.add(InfoItem("Barbastelle", "assets/images/barbastelle_bat.jpg",
        "Barbastella barbastellus"));
    batsInfo.add(InfoItem("Bechstein’s bat", "assets/images/bechsteins_bat.jpg",
        "Myotis bechsteinii "));
    batsInfo.add(InfoItem(
        "Brandt’s bat", "assets/images/brandts_bat.jpg", "Myotis brantii"));
    batsInfo.add(InfoItem("Brown long-eared bat",
        "assets/images/brown_long_eared_bat.jpg", "Plecotus auratus"));
    batsInfo.add(InfoItem(
        "Common pipistrelle",
        "assets/images/common_pipistrelle_bat.jpg",
        "Pipistrellus pipistrellus"));
    batsInfo.add(InfoItem("Daubenton’s bat", "assets/images/daubentons_bat.jpg",
        "Myotis daubentonii"));
    batsInfo.add(InfoItem(
        "Greater horseshoe bat",
        "assets/images/greater_horseshoe_bat.jpg",
        "Rhinolophus ferrumequinum"));
    batsInfo.add(InfoItem("Grey long-eared bat",
        "assets/images/grey_long_eared_bat.jpg", "Plecotus austriacus"));
    batsInfo.add(InfoItem("Leisler’s bat", "assets/images/leislers_bat.jpg",
        "Nyctalus leisleri"));
    batsInfo.add(InfoItem("Lesser horseshoe bat",
        "assets/images/lesser_horseshoe_bat.jpg", "Rhinolophus hipposideros"));

    batsInfo.add(InfoItem(
        "Nathusius’ pipistrelle",
        "assets/images/nathusius_pipistrelle_bat.jpg",
        "Pipistrellus nathusii"));
    batsInfo.add(InfoItem("Natterer’s bat", "assets/images/natterers_bat.jpg",
        "Myotis nattereri"));
    batsInfo.add(InfoItem(
        "Noctule", "assets/images/noctule_bat.jpg", "Nyctalus noctule"));
    batsInfo.add(InfoItem(
        "Serotine", "assets/images/serotine_bat.jpg", "Eptesicus serotinus"));
    batsInfo.add(InfoItem("Soprano pipistrelle",
        "assets/images/soprano_pipistrelle_bat.jpg", "Pipistrellus pygmaeus"));
    batsInfo.add(InfoItem("Whiskered bat", "assets/images/whiskered_bat.jpg",
        "Myotis mystacinus"));
    batsInfo.add(InfoItem("Greater mouse-eared bat",
        "assets/images/greater_mouse_eared_bat.jpg", "Myotis myotis"));
  }

  @override
  void dispose() {
    print("MQTT Server View is Closed");
    dissmissView = 1;
    if (client!.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Disconnecting from MQTT Server: ' + broker);
      _disconnect();
    }

    super.dispose();
  }

  void _populateSensorList() {
    _connect();
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
      onLongPress: () {
        print(
          Text("Long Pressed"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: 3000,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo_transparent_black.png',
                              height: 90,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TabButton(
                          title: 'Info',
                          index: 0,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                        ),
                        TabButton(
                          title: 'Video',
                          index: 1,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(
                    top: 180, right: 10, left: 10, bottom: 0),
                child: Expanded(
                  child: _currentIndex == 0
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 0,
                            left: 0,
                            right: 0,
                          ),
                          child: MasonryGridView.builder(
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: batsInfo.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child:
                                        Image.asset(batsInfo[index].img ?? ''),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(25, 72, 86, 123),
                                            Color.fromARGB(30, 46, 72, 89)
                                          ], // Specify your gradient colors
                                          begin: Alignment
                                              .topLeft, // Optional: Define the starting point of the gradient
                                          end: Alignment
                                              .bottomRight, // Optional: Define the ending point of the gradient
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            batsInfo[index].name ?? '',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            batsInfo[index].scientificName ?? '',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: ListView.builder(
                            itemCount: srcs.length,
                            itemBuilder: (context, index) =>
                                VideosTile(srcs[index]),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                ),
              ),
            ],
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

    print('[MQTT client] MQTT client connecting....');

    client!.connectionMessage = connMess;

    try {
      await client!.connect();
    } catch (e) {
      print(e);
      dismissProgressHUD();
      _disconnect();
    }

    /// Check if we are connected
    if (client!.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Connected to ' + broker);
      dismissProgressHUD();
      setState(() {
        connectionState = client!.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client!.connectionStatus}');

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
    client!.published!.listen((mqtt.MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });
  }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client!.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');

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

    print('[MQTT client] MQTT client disconnected');

    if (dissmissView != 1) {
      dismissProgressHUD();
      print("Disconnected from MQTT Server");
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
    } on Exception catch (e) {
      print('SJG: Message: $message');
      print(e.toString());
    }

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

class TabButton extends StatelessWidget {
  final String title;
  final int index;
  final int currentIndex;
  final VoidCallback onPressed;

  const TabButton({
    required this.title,
    required this.index,
    required this.currentIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 20,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: index == currentIndex
                  ? const Color(0xfee36e79)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              color: index == currentIndex
                  ? const Color(0xfee36e79)
                  : Colors.black38,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        )),
      ),
    );
  }
}

class InfoTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: 4, // Change this based on your data
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://via.placeholder.com/100',
                width: 80,
                height: 80,
              ),
              SizedBox(height: 10),
              Text('Item $index'),
            ],
          ),
        );
      },
    );
  }
}
