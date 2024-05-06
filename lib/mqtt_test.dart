// import 'dart:async';
// import 'dart:io';
// import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const server = 'io.adafruit.com';
const port = '1883';
const username = '# YOUR_ADAFRUIT_USERNAME';
const password = '# YOUR_ADAFRUIT_KEY';
var mqttClient = MqttServerClient(server, port);

// Future<int> main() async {
//   mqttClient.logging(on: true);
//   mqttClient.keepAlivePeriod = 60;
//   mqttClient.onDisconnected = onDisconnected;
//   mqttClient.onConnected = onConnected;
//   mqttClient.onSubscribed = onSubscribed;
//   mqttClient.pongCallback = pong;

//   final connMess = MqttConnectMessage()
//       .withClientIdentifier('dart_client')
//       .withWillTopic('willtopic')
//       .withWillMessage('My Will message')
//       .startClean()
//       .withWillQos(MqttQos.atLeastOnce);
//   print('Client connecting....');
//   mqttClient.connectionMessage = connMess;

//   try {
//     await mqttClient.connect(username, password);
//   } on NoConnectionException catch (e) {
//     print('Client exception: $e');
//     mqttClient.disconnect();
//   } on SocketException catch (e) {
//     print('Socket exception: $e');
//     mqttClient.disconnect();
//   }

//   if (mqttClient.connectionStatus!.state == MqttConnectionState.connected) {
//     print('Client connected');
//   } else {
//     print(
//         'Client connection failed - disconnecting, status is ${mqttClient.connectionStatus}');
//     mqttClient.disconnect();
//     exit(-1);
//   }

//   const subTopic = 'datnguyenvan/feeds/cambien1';
//   print('Subscribing to the $subTopic topic');
//   mqttClient.subscribe(subTopic, MqttQos.atMostOnce);
//   mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//     final recMess = c![0].payload as MqttPublishMessage;
//     final pt =
//         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//     print('Received message: topic is ${c[0].topic}, payload is $pt');
//   });

//   mqttClient.published!.listen((MqttPublishMessage message) {
//     print(
//         'Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
//   });

//   const pubTopic = 'datnguyenvan/feeds/cambien3';
//   final builder = MqttClientPayloadBuilder();
//   builder.addString("50");

//   print('Subscribing to the $pubTopic topic');
//   mqttClient.subscribe(pubTopic, MqttQos.exactlyOnce);

//   print('Publishing our topic');
//   mqttClient.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

//   print('Sleeping....');
//   await MqttUtilities.asyncSleep(80);

//   print('Unsubscribing');
//   mqttClient.unsubscribe(subTopic);
//   mqttClient.unsubscribe(pubTopic);

//   await MqttUtilities.asyncSleep(2);
//   print('Disconnecting');
//   mqttClient.disconnect();

//   return 0;
// }

// // The subscribed callback
// void onSubscribed(String topic) {
//   print('Subscription confirmed for topic $topic');
// }

// // The unsolicited disconnect callback
// void onDisconnected() {
//   print('OnDisconnected client callback - Client disconnection');
//   if (mqttClient.connectionStatus!.disconnectionOrigin ==
//       MqttDisconnectionOrigin.solicited) {
//     print('OnDisconnected callback is solicited, this is correct');
//   }
//   exit(-1);
// }

// // The successful connect callback
// void onConnected() {
//   print('OnConnected client callback - Client connection was sucessful');
// }

// // Pong callback
// void pong() {
//   print('Ping response client callback invoked');
// }
