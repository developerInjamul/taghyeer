import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/failures.dart';
import '../datasources/remote/remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final RemoteDataSource _remote;

  AuthRepository(this._remote);

  Future<UserModel> login(String username, String password) async {
    final user = await _remote.login(username, password);
    await _cacheUser(user);
    return user;
  }

  Future<void> _cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUser, user.toJsonString());
  }

  Future<UserModel?> getCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(AppConstants.keyUser);
      if (jsonStr == null) return null;
      return UserModel.fromJsonString(jsonStr);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyUser);
    await prefs.remove(AppConstants.keyToken);
  }

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyTheme) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyTheme, isDark);
  }
}
