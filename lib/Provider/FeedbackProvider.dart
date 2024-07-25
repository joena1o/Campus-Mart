import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Network/FeedbackClass/FeedbackClass.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/cupertino.dart';

class FeedbackProvider extends ChangeNotifier{

  FeedbackClass feedbackClass = FeedbackClass();

  bool uploadingFeedback = false;

  void uploadFeedback(token, data, ctx) async{
    uploadingFeedback = true;
    notifyListeners();
    try{
      SuccessMessageModel successMessageModel = await feedbackClass.uploadFeedback(token, data);
      showMessage(successMessageModel.message, ctx);
    }catch(e){
      print(e);
    }finally{
      uploadingFeedback = false;
    }
    notifyListeners();
  }

}