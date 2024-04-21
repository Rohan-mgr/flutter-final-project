import 'dart:convert';

import 'package:flutter_final_project/types/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // Store a string value
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Retrieve a string value
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Store a user object (assuming User has toJson() and fromJson())
  static Future<void> setUser(String key, MyUser user) async {
    await setString(key, jsonEncode(user.toJson()));
  }

  // Retrieve a user object
  static Future<MyUser?> getUser(String key) async {
    final encodedUser = await getString(key);
    if (encodedUser != null) {
      try {
        final userMap = jsonDecode(encodedUser) as Map<String, dynamic>;
        return MyUser.fromJson(userMap);
      } on FormatException catch (e) {
        print('Error decoding user data: $e');
        return null; // Return null on decoding error
      }
    }
    return null; // Return null if encodedUser is null
  }

  // remove a specific key
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
