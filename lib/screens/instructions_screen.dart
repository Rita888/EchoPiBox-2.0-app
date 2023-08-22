import 'dart:async';

import 'package:batsexplorer/models/sensor_item.dart';
import 'package:batsexplorer/tiles/videos_tile.dart';
import 'package:batsexplorer/utils/customcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:string_validator/string_validator.dart' as sV;
import 'package:video_player/video_player.dart';

class InstructionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InstructionsScreenState();
  }
}

class InstructionsScreenState extends State<InstructionsScreen> {
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

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ' + broker + ':\t ${topic.trim()}');
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
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
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
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: PdfViewer.openAsset('assets/files/instruction.pdf'),
          )
        ],
      ),
    )
        // home: Scaffold(
        //   body: Column(
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Image.asset(
        //               'assets/images/logo_transparent_black.png',
        //               height: 90,
        //             ),
        //           ],
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 20,
        //       ),
        //       Container(
        //         padding: const EdgeInsets.all(10),
        //         child: PdfViewer.openAsset('assets/files/instruction.pdf'),
        //       )
        //     ],
        //   ),
        // ),
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
