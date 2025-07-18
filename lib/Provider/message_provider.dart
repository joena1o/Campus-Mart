import 'dart:async';
import 'dart:convert';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/model/message_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/network/message_class/messaging_class.dart';
import 'package:campus_mart/network/notification_service_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class MessageProvider extends ChangeNotifier {
  IOWebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;

  MessageClass messageClass = MessageClass();

  bool loadingMessages = false;
  bool sendingMessages = false;

  List<MessageModel>? messageModel;
  List<Chat> chats = [];

  bool userIsOnline = false;

  final ScrollController scrollController = ScrollController();
  TextEditingController messageText = TextEditingController();

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  Future addMessage(data, token) async {
    sendingMessages = true;
    notifyListeners();
    try {
      Chat? chatModel = await messageClass.addMessage(data, token);
      if (chatModel != null) {
        singleChat(chatModel);
      }
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      messageText.text = "";
      sendingMessages = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }
    notifyListeners();
  }

  void loadChats(List<Chat> userChats) {
    chats = userChats;
  }

  void singleChat(Chat value) {
    chats.add(value);
    notifyListeners();
  }

  Future getMessages(data, token) async {
    loadingMessages = true;
    try {
      messageModel = await messageClass.getMessages(data, token);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      loadingMessages = false;
    }
    notifyListeners();
  }

  Future getMessagesBackground(data, token) async {
    try {
      messageModel = await messageClass.getMessages(data, token);
    } catch (e) {
      if(kDebugMode){
      showMessageError(jsonDecode(e.toString())['message']);
      }
    }
    notifyListeners();
  }

  Future setAsRead(data, token) async {
    loadingMessages = true;
    try {
      await messageClass.setAsRead(data, token);
    } catch (e) {
      // print(e);
    } finally {
      loadingMessages = false;
    }
    notifyListeners();
  }

  // Constructor to establish the WebSocket connection
  initProvider(UserModel user) {
    _channel =
        IOWebSocketChannel.connect('ws://campus-mart-server.onrender.com');
    _channel!.sink.add(jsonEncode({"type": "register", "userId": user.id}));

    _streamSubscription = _channel!.stream.listen((message) {
      final newResponse = json.decode(message.toString());
      if (newResponse['type'] == 'status_response') {
        userIsOnline = newResponse['isOnline'];
      } else {
        Chat newChatMessage = Chat.fromJson(newResponse);
        chats.add(newChatMessage);
        showLocalNotification(
            "new Message", json.decode(message.toString())['message']);
      }
      notifyListeners();
    });
  }

  void checkUserStatus(userId) {
    // Check the status of another user
    _channel!.sink.add(jsonEncode({"type": "check_status", "userId": userId}));
  }

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

  void makeAsReadLocally() {
    for (var chat in chats) {
      chat.seen = true;
    }
  }

  void disconnectWebSocket() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _channel?.sink.close();
    disconnectWebSocket();
    super.dispose();
  }
}
