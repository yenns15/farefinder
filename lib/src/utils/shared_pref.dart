import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref{

    void save (String key, String value ) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, jsonEncode(value));
    }

Future<dynamic> read(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(key);
  if (jsonString != null) {
    return json.decode(jsonString);
  }
  return null;
}


Future<bool> contains (String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future<bool> remove(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(key);

}

}



 