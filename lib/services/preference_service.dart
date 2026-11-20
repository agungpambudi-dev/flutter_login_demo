import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _accessTokenKey = 'access_token';

  // Simpan access token
  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _accessTokenKey,
      accessToken,
    );
  }

  // Ambil access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_accessTokenKey);
  }

  // Hapus access token
  Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_accessTokenKey);
  }
}