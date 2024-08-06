import 'package:campus_mart/Utils/save_prefs.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier{

  bool isDark = false;
  bool isTest = false;

  void switchTheme(val){
    isDark = val;
    saveBoolDetails('theme', val);
    notifyListeners();
  }

  void loadTheme(){
    readBool("theme").then((theme){
      if(theme==null || !theme){
        isDark = false;
      }else{
        isDark = true;
      }
      notifyListeners();
    });

  }


}