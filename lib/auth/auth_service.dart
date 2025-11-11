import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _emailKey = 'user_email';
  static const _passwordKey = 'user_password'; // Tidak aman, hanya untuk demo
  static const _loggedInKey = 'is_logged_in';

  // Mendaftarkan pengguna baru
  static Future<bool> registerUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Di aplikasi nyata, Anda mungkin ingin memeriksa apakah email sudah ada
    // di database server, bukan hanya di SharedPreferences.
    // Untuk demo ini, kita asumsikan hanya ada satu pengguna.
    
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setBool(_loggedInKey, true); // <-- TAMBAHAN: Langsung set status login
    return true;
  }

  // Login pengguna
  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_emailKey);
    final storedPassword = prefs.getString(_passwordKey);

    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool(_loggedInKey, true); // Set status login
      return true;
    }
    return false;
  }

  // Logout pengguna
  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    // Anda mungkin juga ingin menghapus email dan password saat logout
    // await prefs.remove(_emailKey);
    // await prefs.remove(_passwordKey);
  }

  // Cek status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
}
