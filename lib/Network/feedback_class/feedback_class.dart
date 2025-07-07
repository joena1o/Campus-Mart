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
      final request = await networkHelper.post(feedback, body: data, headers: headers);
      successMessageModel = SuccessMessageModel.fromJson(request);
      return successMessageModel;
    }catch(e){
      rethrow;
    }
  }

}