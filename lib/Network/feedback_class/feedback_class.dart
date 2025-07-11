import 'dart:convert';

import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/model/success_message_model.dart';

class FeedbackClass{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Map<String, String>?  headers;
  String feedback = "$conn/feedback";

  Future<SuccessMessageModel?> uploadFeedback(token, data) async{
    SuccessMessageModel? successMessageModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try{
      final result = await networkHelper.post(feedback, body: data, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      successMessageModel = SuccessMessageModel.fromJson(json.decode(result.body));
      return successMessageModel;
    }catch(e){
      rethrow;
    }
  }

}