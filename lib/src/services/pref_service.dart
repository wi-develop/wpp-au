import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future<bool> deleteValue(String key) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    var sonuc = await _pref.remove(key);
    return sonuc;
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    Future<bool> sonuc = _pref.setString(key, value);
    return sonuc;
  }

  Future<bool> setInt(String key, int value) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    Future<bool> sonuc = _pref.setInt(key, value);
    return sonuc;
  }

  Future<bool> setBool(String key, bool value) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    Future<bool> sonuc = _pref.setBool(key, value);
    return sonuc;
  }

  Future<String?> getString(String key) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    String? sonuc = _pref.getString(key);
    return sonuc;
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    int? sonuc = _pref.getInt(key);
    return sonuc;
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    bool? sonuc = _pref.getBool(key);
    return sonuc;
  }
}
