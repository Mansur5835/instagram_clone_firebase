import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<bool> saveId(String id) async {
    final _pref = await SharedPreferences.getInstance();

    bool isSaved = await _pref.setString("id", id);

    return isSaved;
  }

  static Future<String?> getId() async {
    final _pref = await SharedPreferences.getInstance();

    String? _id = _pref.getString("id");
    if (_id != null) {
      return _id;
    }

    return null;
  }

  static saveToken(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
