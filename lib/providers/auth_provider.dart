import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../services/storage.dart';

final authProvider = StateNotifierProvider<AuthNotifier, Member?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<Member?> {
  final StorageService _storage = StorageService();

  AuthNotifier() : super(null) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await _storage.getSetting('currentUserId', defaultValue: '');
    if (userId.isNotEmpty) {
      state = _storage.getMember(userId);
    }
  }

  Future<void> login(String email, String password) async {
    // For demo purposes, we'll create or load a user
    // In a real app, this would validate against a backend

    // Try to find existing user by email
    final existingUser = _storage.getAllMembers().firstWhere(
      (m) => m.email == email,
      orElse: () => Member(id: '', name: '', email: ''),
    );

    if (existingUser.id.isNotEmpty) {
      state = existingUser;
      await _storage.setSetting('currentUserId', existingUser.id);
    } else {
      // Create new user (demo mode)
      final newUser = Member(
        id: _generateId(),
        name: email.split('@')[0],
        email: email,
      );
      await _storage.saveMember(newUser);
      state = newUser;
      await _storage.setSetting('currentUserId', newUser.id);
    }
  }

  Future<void> updateProfile(String name, {String? email, String? avatarUrl}) async {
    if (state == null) return;

    state = Member(
      id: state!.id,
      name: name,
      email: email ?? state!.email,
      avatarUrl: avatarUrl ?? state!.avatarUrl,
      joinedAt: state!.joinedAt,
    );

    await _storage.saveMember(state!);
  }

  Future<void> logout() async {
    state = null;
    await _storage.setSetting('currentUserId', '');
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + UniqueKey().toString();
  }
}

// Current user provider for easy access
final currentUserProvider = Provider<Member?>((ref) {
  return ref.watch(authProvider);
});
