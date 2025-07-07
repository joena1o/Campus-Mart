import 'dart:convert';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/model/success_message_model.dart';
import 'package:campus_mart/network/feedback_class/feedback_class.dart';
import 'package:flutter/cupertino.dart';

class FeedbackProvider extends ChangeNotifier {
  FeedbackClass feedbackClass = FeedbackClass();

  bool uploadingFeedback = false;

  void uploadFeedback(token, data, ctx) async {
    uploadingFeedback = true;
    notifyListeners();
    try {
      SuccessMessageModel? successMessageModel =
          await feedbackClass.uploadFeedback(token, data);
      showMessage(successMessageModel.message);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      uploadingFeedback = false;
    }
    notifyListeners();
  }
}
