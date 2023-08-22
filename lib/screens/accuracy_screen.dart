import 'dart:async';

import 'package:batsexplorer/models/sensor_item.dart';
import 'package:batsexplorer/tiles/videos_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:string_validator/string_validator.dart' as sV;
import 'package:video_player/video_player.dart';

class AccuracyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccuracyScreenState();
  }
}

class AccuracyScreenState extends State<AccuracyScreen> {
  List<SensorItem> _mqttSensors = <SensorItem>[];
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
    _populateSensorList();
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
                          title: 'Survey',
                          index: 0,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                        ),
                        TabButton(
                          title: 'Site A',
                          index: 1,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                        ),
                        TabButton(
                          title: 'Site B',
                          index: 2,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2;
                            });
                          },
                        ),
                        TabButton(
                          title: 'Site C',
                          index: 3,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 3;
                            });
                          },
                        ),
                        TabButton(
                          title: 'Site D',
                          index: 4,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 4;
                            });
                          },
                        ),
                        TabButton(
                          title: 'Site E',
                          index: 5,
                          currentIndex: _currentIndex,
                          onPressed: () {
                            setState(() {
                              _currentIndex = 5;
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
                child: SingleChildScrollView(
                  child: _currentIndex == 0
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 0,
                            left: 0,
                            right: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/siteMap.png',
                                width: MediaQuery.of(context).size.width,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Image.asset(
                                'assets/images/site.jpeg',
                                width: MediaQuery.of(context).size.width,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      : _currentIndex == 1
                          ? Container(
                              padding: const EdgeInsets.only(
                                top: 0,
                                left: 0,
                                right: 0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Cotswold',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    'assets/images/site_a.png',
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Image.asset(
                                    'assets/images/site_a_3.jpeg',
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Image.asset(
                                    'assets/images/site_a_4.jpeg',
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            )
                          : _currentIndex == 2
                              ? Container(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'South Wales',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/site_b.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Image.asset(
                                        'assets/images/site_b_2.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Image.asset(
                                        'assets/images/site_b_3.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Image.asset(
                                        'assets/images/site_b_5.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                )
                              : _currentIndex == 3
                                  ? Container(
                                      padding: const EdgeInsets.only(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Windsor',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Image.asset(
                                            'assets/images/site_c_1.png',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Image.asset(
                                            'assets/images/site_c_2-min.png',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Image.asset(
                                            'assets/images/site_c_3-min.png',
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    )
                                  : _currentIndex == 4
                                      ? Container(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Highgate',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Image.asset(
                                                'assets/images/site_d.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Image.asset(
                                                'assets/images/site_d_1.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Sussex',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Image.asset(
                                                'assets/images/site_e.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Image.asset(
                                                'assets/images/site_e_1.png',
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],
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
        width: (MediaQuery.of(context).size.width / 6) - 20,
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
              fontWeight: FontWeight.w400,
              fontSize: 13),
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
