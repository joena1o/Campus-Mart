import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier{

  bool isDark = false;

  void switchTheme(val){
    isDark = val;
    notifyListeners();
  }


}