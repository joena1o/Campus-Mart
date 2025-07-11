import 'dart:convert';

import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/model/success_message_model.dart';

class SettingClass{
  
  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Map<String, String>?  headers;

  String changePasswordUrl = "$conn/user/change_password";

  Future<SuccessMessageModel?> changePassword(data, token) async{
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try{
      final result = await networkHelper.put(changePasswordUrl, body:data, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return SuccessMessageModel.fromJson(json.decode(result.body));
    }catch(e){
      rethrow;
    }
  }


}