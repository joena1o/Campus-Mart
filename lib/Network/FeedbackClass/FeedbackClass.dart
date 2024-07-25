import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';

class FeedbackClass{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Map<String, String>?  headers;
  String feedback = "$conn/feedback";

  Future uploadFeedback(token, data){
    print(data);
    SuccessMessageModel? successMessageModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(feedback, body: data, headers: headers).then((value){
      print(value);
      successMessageModel = SuccessMessageModel.fromJson(value);
      return successMessageModel;
    }).catchError((err){
      print(err);
      errorHandler.handleError(err['body']);
    });
  }

}