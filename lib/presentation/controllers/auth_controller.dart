import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/failures.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController(this._repository);

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDarkMode = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initTheme();
    _checkSession();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _initTheme() async {
    final dark = await _repository.isDarkMode();
    isDarkMode.value = dark;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _checkSession() async {
    final cached = await _repository.getCachedUser();
    if (cached != null) {
      user.value = cached;
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter username and password.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final loggedUser = await _repository.login(username, password);
      user.value = loggedUser;
      Get.offAllNamed(AppRoutes.home);
    } on AuthFailure catch (e) {
      errorMessage.value = e.message;
    } on NetworkFailure catch (e) {
      errorMessage.value = e.message;
    } on TimeoutFailure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    user.value = null;
    usernameController.clear();
    passwordController.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    await _repository.setDarkMode(isDarkMode.value);
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
