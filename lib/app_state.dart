// app_state.dart
// Simple singleton to hold shared app data (user info, projects, tasks).

import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  // Private constructor for singleton.
  AppState._();
  static final AppState instance = AppState._();

  // User information.
  String userName = '';

  // Sample project and task data structures.
  final List<Map<String, dynamic>> projects = [
    {
      'title': 'Mobile App Redesign',
      'description': 'Refreshing the UX for the Task Proof Android app.',
      'due': 'Oct 30, 2023',
    },
    {
      'title': 'Backend API Integration',
      'description': 'Integrate new REST endpoints.',
      'due': 'Nov 15, 2023',
    },
  ];

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Update user authentication',
      'member': 'Ilham',
      'deadline': 'Oct 30, 2026',
    },
    {
      'title': 'Design new logo',
      'member': 'Alex',
      'deadline': 'Nov 05, 2026',
    },
  ];

  // Helper to update user name and save it.
  Future<void> setUserName(String name) async {
    userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setBool('isRegistered', true);
  }

  // Load user name and registration status on startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? 'User';
  }
}
