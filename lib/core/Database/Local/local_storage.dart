import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Configure secure storage with options
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Auth token keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresInKey = 'token_expires_in';
  static const String _refreshExpiresInKey = 'refresh_expires_in';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _twoFactorAuthKey = 'two_factor_auth_enabled';
  static const String _rememberMeKey = 'remember_me_enabled';

  // Secure storage methods for tokens
  static Future<void> setSecureData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      print('✅ Stored secure data for key: $key');
    } catch (e) {
      print('❌ Error storing secure data for key $key: $e');
    }
  }

  static Future<void> setTwoFactorAuth(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_twoFactorAuthKey, enabled);
      print('2FA setting saved: $enabled');
    } catch (e) {
      print('Error saving 2FA setting: $e');
    }
  }

  static Future<bool?> getTwoFactorAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool(_twoFactorAuthKey);
      print('Retrieved 2FA setting: $result');
      return result;
    } catch (e) {
      print('Error retrieving 2FA setting: $e');
      return null;
    }
  }

  // Remember Me Settings
  static Future<void> setRememberMe(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, enabled);
      print('Remember Me setting saved: $enabled');
    } catch (e) {
      print('Error saving Remember Me setting: $e');
    }
  }

  static Future<bool?> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = prefs.getBool(_rememberMeKey);
      print('Retrieved Remember Me setting: $result');
      return result;
    } catch (e) {
      print('Error retrieving Remember Me setting: $e');
      return null;
    }
  }

  // Clear all security settings
  static Future<void> clearSecuritySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_twoFactorAuthKey);
      await prefs.remove(_rememberMeKey);
      print('Security settings cleared');
    } catch (e) {
      print('Error clearing security settings: $e');
    }
  }

  // Method to sync settings with server (call this after login)
  static Future<void> syncSecuritySettings({
    required bool twoFactorAuth,
    required bool rememberMe,
  }) async {
    await setTwoFactorAuth(twoFactorAuth);
    await setRememberMe(rememberMe);
  }

  static Future<String?> getSecureData(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      print(
        '📖 Retrieved secure data for key: $key ${value != null ? "(found)" : "(not found)"}',
      );
      return value;
    } catch (e) {
      print('❌ Error retrieving secure data for key $key: $e');
      return null;
    }
  }

  static Future<void> removeSecureData(String key) async {
    try {
      await _secureStorage.delete(key: key);
      print('🗑️ Removed secure data for key: $key');
    } catch (e) {
      print('❌ Error removing secure data for key $key: $e');
    }
  }

  static Future<void> clearAllSecureData() async {
    try {
      await _secureStorage.deleteAll();
      print('🧹 Cleared all secure data');
    } catch (e) {
      print('❌ Error clearing all secure data: $e');
    }
  }

  // Auth-specific methods
  static Future<void> storeAuthTokens({
    required String accessToken,
    required String refreshToken,
    required String expiresIn,
    required String refreshExpiresIn,
  }) async {
    print('=== STORING AUTH TOKENS ===');
    await setSecureData(_accessTokenKey, accessToken);
    await setSecureData(_refreshTokenKey, refreshToken);
    await setSecureData(_tokenExpiresInKey, expiresIn);
    await setSecureData(_refreshExpiresInKey, refreshExpiresIn);
    print('✅ All auth tokens stored successfully');
  }

  static Future<String?> getAccessToken() async {
    return await getSecureData(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await getSecureData(_refreshTokenKey);
  }

  static Future<String?> getTokenExpiresIn() async {
    return await getSecureData(_tokenExpiresInKey);
  }

  static Future<String?> getRefreshExpiresIn() async {
    return await getSecureData(_refreshExpiresInKey);
  }

  static Future<void> clearAuthTokens() async {
    print('=== CLEARING AUTH TOKENS ===');
    await removeSecureData(_accessTokenKey);
    await removeSecureData(_refreshTokenKey);
    await removeSecureData(_tokenExpiresInKey);
    await removeSecureData(_refreshExpiresInKey);
    await removeSecureData(_userIdKey);
    await removeSecureData(_userEmailKey);
    print('✅ All auth tokens cleared');
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    final isAuth = token != null && token.isNotEmpty;
    print(
      '🔐 Authentication status: ${isAuth ? "Authenticated" : "Not authenticated"}',
    );
    return isAuth;
  }

  // Store user info
  static Future<void> storeUserInfo({
    required String userId,
    required String email,
  }) async {
    await setSecureData(_userIdKey, userId);
    await setSecureData(_userEmailKey, email);
  }

  static Future<String?> getUserId() async {
    return await getSecureData(_userIdKey);
  }

  static Future<String?> getUserEmail() async {
    return await getSecureData(_userEmailKey);
  }

  // Get all stored keys (for debugging)
  static Future<Map<String, String?>> getAllAuthData() async {
    return {
      'access_token': await getAccessToken(),
      'refresh_token': await getRefreshToken(),
      'token_expires_in': await getTokenExpiresIn(),
      'refresh_expires_in': await getRefreshExpiresIn(),
      'user_id': await getUserId(),
      'user_email': await getUserEmail(),
    };
  }
}