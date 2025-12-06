import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user_data';
  
  // Guardar token después del login
  static Future<void> saveUserData(String token, String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, userJson);
  }
  
  // Obtener token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  // Verificar si hay sesión
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  static saveToken(data) {}

  static clearToken() {}
}