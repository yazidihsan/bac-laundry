import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefKey {
//   static const String accessToken = 'ACCESS_TOKEN';
//   static const String username = 'EMAIL';
//   static const String nama = 'EMAIL';
//   static const String level = 'EMAIL';
// }

class SharedPref {
  String? accessToken;
  Future<void> setAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    return accessToken;
  }

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<void> clearName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
  }

  Future<void> setLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('level', level);
  }

  Future<String?> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('level');
  }

  Future<void> clearLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('level');
  }
}
