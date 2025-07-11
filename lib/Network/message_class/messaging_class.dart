import 'dart:convert';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/model/message_model.dart';

class MessageClass {
  final NetworkHelper _networkHelper = NetworkHelper();

  static Map<String, String>? headers;

  String messageEndpoint = "$conn/message";

  Future<Chat?> addMessage(data, token) async {
    Chat? chat;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await _networkHelper.post(
        messageEndpoint,
        headers: headers,
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      Map<String, dynamic> response = json.decode(result.body);
      chat = Chat.fromJson(response);
      return chat;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MessageModel>?> getMessages(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result =
          await _networkHelper.get("$messageEndpoint/$data", headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      Map<String, dynamic> response = json.decode(result.body);
      return response['data']
          .map<MessageModel>((json) => MessageModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setAsRead(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      await _networkHelper.get("$messageEndpoint/read/$data",
          headers: headers, body: data);
    } catch (e) {
      rethrow;
    }
  }
}
