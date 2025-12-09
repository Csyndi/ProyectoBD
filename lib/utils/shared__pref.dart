import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';
  static const String _userRolKey = 'userRol'; // Agregar esta constante

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // CORREGIDO: Usar la constante _userRolKey
  static Future<void> saveUserRol(String rol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRolKey, rol);
  }

  static Future<String?> getUserRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRolKey);
  }

  static Future<void> clearUserRol() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userRolKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  static Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
  }

  static Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  // Método útil para verificar si está logueado
  static Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}