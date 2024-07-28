import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Obtain shared preferences.

  Future<void> saveJsonDetails(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value.toJson()));
  }

  saveDetails(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var json = prefs.getString(key);
    if(json != null){
      return jsonDecode(json!);
    }
    return null;
  }

  Future<dynamic> readValue(key) async{
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(key);
    return result;
  }

  void clearPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }