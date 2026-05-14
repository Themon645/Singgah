import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:singgah/core/utils/profile_picture_storage.dart';
import 'package:singgah/features/auth/domain/entities/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

final authInitializationProvider = FutureProvider<bool>((ref) async {
  final authNotifier = ref.watch(authProvider.notifier);
  await authNotifier.ensureInitialized();
  return true;
});

class AuthNotifier extends StateNotifier<User?> {
  final _storage = const FlutterSecureStorage();
  final String _userKey = 'logged_in_user';
  late Box<User> _userBox;
  late Future<void> _initFuture;

  AuthNotifier() : super(null) {
    _initFuture = _init();
  }

  Future<void> ensureInitialized() async {
    await _initFuture;
  }

  Future<void> _init() async {
    try {
      _userBox = Hive.box<User>('users_box');
      await _loadUser();
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  Future<void> _loadUser() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson != null) {
        state = User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
      await _storage.delete(key: _userKey);
      state = null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    await ensureInitialized();

    final existingUser = _userBox.values.any((u) => u.email == email);
    if (existingUser) return false;

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    await _userBox.put(newUser.email, newUser);
    state = newUser;
    await _saveUser(newUser);
    return true;
  }

  Future<String?> login(String email, String password) async {
    await ensureInitialized();

    final user = _userBox.get(email);

    if (user == null) {
      return "Email belum terdaftar. Silakan buat akun baru.";
    }

    if (user.password != password) {
      return "Password salah. Silakan coba lagi.";
    }

    state = user;
    await _saveUser(user);
    return null;
  }

  Future<void> updateProfile({String? name, String? profilePicturePath}) async {
    if (state == null) return;

    String? finalImagePath = profilePicturePath;

    try {
      finalImagePath = await saveProfilePicturePath(profilePicturePath);
    } catch (e) {
      debugPrint('Error saving profile picture: $e');
    }

    final updatedUser = User(
      id: state!.id,
      name: name ?? state!.name,
      email: state!.email,
      password: state!.password,
      profilePicture: finalImagePath ?? state!.profilePicture,
    );

    state = updatedUser;
    await _userBox.put(updatedUser.email, updatedUser);
    await _saveUser(updatedUser);
  }

  Future<void> _saveUser(User user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    state = null;
    await _storage.delete(key: _userKey);
  }

  bool get isAuthenticated => state != null;
}
