import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Obtain shared preferences.

  saveJsonDetails(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value.toJson()));
  }

  saveDetails(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var json = prefs.getString(key);
    if(json != null){
      return jsonDecode(json!);
    }
    return null;
  }

   readValue(key) async{
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(key);
    return result;
  }

  clearPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }