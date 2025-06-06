import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../abstraction/user_repository.dart';

class SharedPrefsUserStorage implements IUserStorage {
  static const _userKey = 'user_data';

  @override
  Future<void> saveUser(Map<String, String> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(userData);
    await prefs.setString(_userKey, jsonData);
  }

  @override
  Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<void> updateUser(Map<String, String> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = await getUser();
    if (existingData == null) return;
    final newData = {...existingData, ...updatedData};
    final jsonData = jsonEncode(newData);
    await prefs.setString(_userKey, jsonData);
  }
}
