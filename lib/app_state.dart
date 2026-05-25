// app_state.dart
// Simple singleton to hold shared app data (user info, projects, tasks).

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  // Private constructor for singleton.
  AppState._() {
    // Pre-populate with default users for easy multi-account testing
    users.addAll([
      {
        'name': 'Creator Demo',
        'email': 'creator@company.com',
        'password': 'password123',
        'role': 'Project Creator',
      },
      {
        'name': 'Member Demo',
        'email': 'member@company.com',
        'password': 'password123',
        'role': 'Project Member',
      }
    ]);
  }
  static final AppState instance = AppState._();

  // Currently logged in user information.
  String userName = '';
  String userEmail = '';
  String userRole = '';
  String userPassword = '';

  // Registered users master list.
  final List<Map<String, String>> users = [];

  // App data lists.
  final List<Map<String, dynamic>> projects = [];
  final List<Map<String, dynamic>> tasks = [];

  // Helper to update user name and save it.
  Future<void> setUserName(String name) async {
    userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setBool('isRegistered', true);
  }

  // Helper to update user email and save it.
  Future<void> setUserEmail(String email) async {
    userEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  // Helper to update user role and save it.
  Future<void> setUserRole(String role) async {
    userRole = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  // Helper to update user password and save it.
  Future<void> setUserPassword(String password) async {
    userPassword = password;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPassword', password);
  }

  // Load user name and registration status on startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? 'Creator Demo';
    userEmail = prefs.getString('userEmail') ?? 'creator@company.com';
    userRole = prefs.getString('userRole') ?? 'Project Creator';
    userPassword = prefs.getString('userPassword') ?? 'password123';
  }
}
