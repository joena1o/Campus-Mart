import 'dart:async';
import 'dart:convert';
import 'package:campus_mart/Model/MessageModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:campus_mart/Network/NotificationServiceClass.dart';

class WebSocketProvider extends ChangeNotifier {
  IOWebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;
  List<dynamic> chats = [];


  // Constructor to establish the WebSocket connection
   initProvider(UserModel user) {
    _channel = IOWebSocketChannel.connect('ws://192.168.43.15:3000');
    _channel!.sink.add(jsonEncode({
      "type": "register",
      "userId": user.id
    }));

    _streamSubscription = _channel!.stream.listen((message) {
      chats?.add(message.toString());
      showLocalNotification("new Message", json.decode(message.toString())['message']);
      notifyListeners(); // Notify listeners when message received
    });
  }

  //List<Chat> message => myMessage;

  void sendMessage(Map<String, dynamic> chats) {
    if (chats.isNotEmpty) {
      _channel?.sink.add(chats);
    }
  }

  void showLocalNotification(title, body) {
       NotificationService.showNotification(
         id: 0,
         title: title,
         body: body,
       );
  }

  void clear(){
     chats = [];
     notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}



