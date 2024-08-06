import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';

class SettingClass{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Map<String, String>?  headers;

  String changePasswordUrl = "$conn/user/change_password";

  Future<SuccessMessageModel> changePassword(data, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.put(changePasswordUrl, body:data, headers: headers)
        .then((dynamic value) async {
      return SuccessMessageModel.fromJson(value);
    }).catchError((err)=> errorHandler.handleError(err['body']));
  }


}