import 'dart:convert';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';

class Auth{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();
  String loginEndpoint ="${conn}/user/login";

  Future<UserModel> loginUser(data){
    UserModel userModel = UserModel();
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(loginEndpoint, headers: headers,  encoding: Encoding.getByName("utf-8"), body: data)
        .then((dynamic res) async{
          final response = res['data'];
          userModel = UserModel.fromJson(response);
          return userModel;
        }).catchError((err){
          errorHandler.handleError(err['body']);
        });
  }

}
