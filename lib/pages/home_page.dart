import 'package:btl_iot/mqtt_test.dart';
import 'package:btl_iot/util/device_box.dart';
import 'package:btl_iot/util/infor_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // infor value
  double _temp = 20;
  double _humid = 50;

  // mqtt infor
  String tempTopic = 'datnguyenvan/feeds/cambien1';
  String humidTopic = 'datnguyenvan/feeds/cambien3';

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect(mqttClient));
  }

  void _connect(MqttServerClient client) async {
    mqttClient.logging(on: true);
    mqttClient.keepAlivePeriod = 60;
    mqttClient.onDisconnected = onDisconnected;
    mqttClient.onConnected = onConnected;
    mqttClient.onSubscribed = onSubscribed;
    mqttClient.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('dart_client')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Client connecting....');
    mqttClient.connectionMessage = connMess;

    try {
      await mqttClient.connect(username, password);
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      mqttClient.disconnect();
    } on SocketException catch (e) {
      print('Socket exception: $e');
      mqttClient.disconnect();
    }

    /// Check if we are connected
    if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print(
          'Client connection failed - disconnecting, status is ${mqttClient.connectionStatus}');
      mqttClient.disconnect();
      exit(-1);
    }

    mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message: topic is ${c[0].topic}, payload is $pt');
      if (c[0].topic == tempTopic) {
        setState(() {
          _temp = double.parse(pt);
          if (_temp > 35) {
            powerSwitchChanged(true, 1);
          }
        });
      } else if (c[0].topic == humidTopic) {
        setState(() {
          _humid = double.parse(pt);
        });
      }
    });

    mqttClient.published!.listen((MqttPublishMessage message) {
      print(
          'Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    print('Subscribing to the $tempTopic topic');
    mqttClient.subscribe(tempTopic, MqttQos.atMostOnce);
    print('Subscribing to the $humidTopic topic');
    mqttClient.subscribe(humidTopic, MqttQos.atMostOnce);
  }

  // The subscribed callback
  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  // The unsolicited disconnect callback
  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (mqttClient.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
  }

  // The successful connect callback
  void onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
  }

  // Pong callback
  void pong() {
    print('Ping response client callback invoked');
  }

  final user = FirebaseAuth.instance.currentUser!;

  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // sign user out method
  void signUserOut() async {
    FirebaseAuth.instance.signOut();

    print('Unsubscribing Topics');
    mqttClient.unsubscribe(tempTopic);
    mqttClient.unsubscribe(humidTopic);

    await MqttUtilities.asyncSleep(2);
    print('Disconnecting');
    mqttClient.disconnect();
  }

  // devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath, powerStatus ]
    ["Smart Light", "lib/icons/light-bulb.png", true],
    ["Smart AC", "lib/icons/air-conditioner.png", true],
  ];

  // infor
  List myRoomInfor = [
    // [ inforName, iconPath ]
    ["Temperature", "lib/icons/temperature.png"],
    ["Humidity", "lib/icons/humidity.png"],
  ];

  // switch power button
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
    String temp = "";
    final builder = MqttClientPayloadBuilder();
    if (value == true) {
      temp = "1";
      builder.addString(temp);
    } else if (value == false) {
      temp = "0";
      builder.addString(temp);
    }
    if (index == 0) {
      mqttClient.publishMessage(
          'datnguyenvan/feeds/nutnhan1', MqttQos.exactlyOnce, builder.payload!);
    } else if (index == 1) {
      mqttClient.publishMessage(
          'datnguyenvan/feeds/nutnhan2', MqttQos.exactlyOnce, builder.payload!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // custom app bar
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu icon
                    Image.asset(
                      'lib/icons/menu.png',
                      height: 45,
                      color: Colors.grey[800],
                    ),

                    // account icon
                    Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey[800],
                    ),

                    // Logout icon
                    IconButton(
                      onPressed: signUserOut,
                      icon: const Icon(Icons.logout),
                      color: Colors.grey[800],
                      iconSize: 40,
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // welcome home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Home,",
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      user.email!,
                      style: const TextStyle(fontSize: 35),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 1,
                ),
              ),

              // devices + infor + grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Smart Room",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeviceBox(
                      deviceName: mySmartDevices[0][0],
                      iconPath: mySmartDevices[0][1],
                      powerOn: mySmartDevices[0][2],
                      onChanged: (value) => powerSwitchChanged(value, 0),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    DeviceBox(
                      deviceName: mySmartDevices[1][0],
                      iconPath: mySmartDevices[1][1],
                      powerOn: mySmartDevices[1][2],
                      onChanged: (value) => powerSwitchChanged(value, 1),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InforBox(
                      inforName: myRoomInfor[0][0],
                      iconPath: myRoomInfor[0][1],
                      inforValue: "$_temp \u00B0",
                      percent: _temp / 60,
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                    InforBox(
                      inforName: myRoomInfor[1][0],
                      iconPath: myRoomInfor[1][1],
                      inforValue: "$_humid %",
                      percent: _humid / 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
