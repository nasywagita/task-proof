// app_state.dart
// Simple singleton to hold shared app data (user info, projects, tasks).

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  // Private constructor for singleton.
  AppState._();
  static final AppState instance = AppState._();

  // User information.
  String userName = '';
  String userEmail = '';
  String userRole = '';
  String userPassword = '';

  // Sample project and task data structures.
  final List<Map<String, dynamic>> projects = [
    {
      'title': 'Mobile App Redesign',
      'description': 'Refreshing the UX for the Task Proof Android app.',
      'due': 'Oct 30, 2026',
      'team': 'Design Team',
      'status': 'ON TRACK',
      'statusColor': const Color(0xFF13ECC8),
      'statusBg': const Color(0x1A13ECC8),
      'progress': 0.75,
      'progressText': '75%',
      'tasks': '4 Tasks',
      'deadline': 'Oct 30',
      'iconBg': const Color(0xFFDCE2F7),
      'iconColor': const Color(0xFF5E7FE5),
      'isBordered': false,
      'taskList': <Map<String, dynamic>>[
        {
          'title': 'UI Login Screen',
          'deadline': 'Oct 30, 2026',
          'status': 'In Progress',
          'assignee': 'Ilham',
          'description': 'Design and develop the User Interface for the Login screen, including input validation and Google/Apple SSO buttons.',
        },
        {
          'title': 'UI Registration Page',
          'deadline': 'Oct 28, 2026',
          'status': 'Pending Review',
          'assignee': 'Alex',
          'description': 'Create the registration form layout and user input fields. Review validation for passwords and email formats.',
        },
        {
          'title': 'Wireframing Homepage',
          'deadline': 'Sep 15, 2026',
          'status': 'Completed',
          'assignee': 'Sarah',
          'description': 'High-fidelity wireframes for the homepage detailing main dashboard layout, user profiles, and quick navigation links.',
        },
        {
          'title': 'User Persona Documentation',
          'deadline': 'Sep 10, 2026',
          'status': 'Completed',
          'assignee': 'Dewi',
          'description': 'Define target user personas based on research data to guide product layout design and UX flows.',
        },
      ],
    },
    {
      'title': 'Q4 Marketing Campaign',
      'description': 'Refreshing Q4 marketing strategy.',
      'due': 'Nov 15, 2026',
      'team': 'Marketing Dept',
      'status': 'PLANNING',
      'statusColor': const Color(0xFF3B82F6),
      'statusBg': const Color(0x1A3B82F6),
      'progress': 0.15,
      'progressText': '15%',
      'tasks': '0 Tasks',
      'deadline': 'Nov 15',
      'iconBg': const Color(0xFFFFEBEB),
      'iconColor': const Color(0xFFFF5252),
      'isBordered': true,
      'taskList': <Map<String, dynamic>>[],
    },
    {
      'title': 'Web Portal Development',
      'description': 'Building customer facing web portal.',
      'due': 'Dec 05, 2026',
      'team': 'Engineering Team',
      'status': 'ON TRACK',
      'statusColor': const Color(0xFF13ECC8),
      'statusBg': const Color(0x2613ECC8),
      'progress': 0.45,
      'progressText': '45%',
      'tasks': '2 Tasks',
      'deadline': 'Dec 05',
      'iconBg': const Color(0xFFE2F7ED),
      'iconColor': const Color(0xFF10B981),
      'isBordered': false,
      'taskList': <Map<String, dynamic>>[
        {
          'title': 'Setup API Endpoint',
          'deadline': 'Dec 01, 2026',
          'status': 'To Do',
          'assignee': 'Ilham',
          'description': 'Create robust REST API endpoints for user authentication, project details, and progress submissions.',
        },
        {
          'title': 'Push Notifications Setup',
          'deadline': 'Dec 15, 2026',
          'status': 'To Do',
          'assignee': 'Alex',
          'description': 'Integrate Firebase Cloud Messaging (FCM) to deliver real-time notifications for task updates and approvals.',
        },
      ],
    },
    {
      'title': 'Brand Identity Guidelines',
      'description': 'Refreshing brand manual and logo guidelines.',
      'due': 'May 15, 2026',
      'team': 'Design Team',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF10B981),
      'statusBg': const Color(0x1A10B981),
      'progress': 1.0,
      'progressText': '100%',
      'tasks': '0 Tasks',
      'deadline': 'May 15',
      'iconBg': const Color(0xFFF7EBE2),
      'iconColor': const Color(0xFFF59E0B),
      'isBordered': false,
      'taskList': <Map<String, dynamic>>[],
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

  void _initializeDynamicProjectDeadlines() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    if (projects.length >= 4) {
      // Project 0: Mobile App Redesign (ON TRACK, e.g. 5 days from now)
      final date1 = now.add(const Duration(days: 5));
      projects[0]['deadline'] = '${months[date1.month - 1]} ${date1.day}';
      projects[0]['due'] = '${months[date1.month - 1]} ${date1.day}, ${date1.year}';

      // Initialize deadlines for Project 0 tasks
      final p0Tasks = projects[0]['taskList'] as List<Map<String, dynamic>>;
      if (p0Tasks.length >= 4) {
        final dateT0 = now.add(const Duration(days: 5));
        p0Tasks[0]['deadline'] = '${months[dateT0.month - 1]} ${dateT0.day}, ${dateT0.year}';

        final dateT1 = now.add(const Duration(days: 3));
        p0Tasks[1]['deadline'] = '${months[dateT1.month - 1]} ${dateT1.day}, ${dateT1.year}';

        final dateT2 = now.subtract(const Duration(days: 10));
        p0Tasks[2]['deadline'] = '${months[dateT2.month - 1]} ${dateT2.day}, ${dateT2.year}';

        final dateT3 = now.subtract(const Duration(days: 15));
        p0Tasks[3]['deadline'] = '${months[dateT3.month - 1]} ${dateT3.day}, ${dateT3.year}';
      }

      // Project 1: Q4 Marketing Campaign (PLANNING, e.g. 15 days from now)
      final date2 = now.add(const Duration(days: 15));
      projects[1]['deadline'] = '${months[date2.month - 1]} ${date2.day}';
      projects[1]['due'] = '${months[date2.month - 1]} ${date2.day}, ${date2.year}';

      // Project 2: Web Portal Development (ON TRACK, e.g. 20 days from now)
      final date3 = now.add(const Duration(days: 20));
      projects[2]['deadline'] = '${months[date3.month - 1]} ${date3.day}';
      projects[2]['due'] = '${months[date3.month - 1]} ${date3.day}, ${date3.year}';

      // Initialize deadlines for Project 2 tasks
      final p2Tasks = projects[2]['taskList'] as List<Map<String, dynamic>>;
      if (p2Tasks.length >= 2) {
        final dateT4 = now.add(const Duration(days: 20));
        p2Tasks[0]['deadline'] = '${months[dateT4.month - 1]} ${dateT4.day}, ${dateT4.year}';

        final dateT5 = now.add(const Duration(days: 35));
        p2Tasks[1]['deadline'] = '${months[dateT5.month - 1]} ${dateT5.day}, ${dateT5.year}';
      }

      // Project 3: Brand Identity Guidelines (COMPLETED, e.g. 10 days ago)
      final date4 = now.subtract(const Duration(days: 10));
      projects[3]['deadline'] = '${months[date4.month - 1]} ${date4.day}';
      projects[3]['due'] = '${months[date4.month - 1]} ${date4.day}, ${date4.year}';
    }
  }

  // Load user name and registration status on startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? 'User';
    userEmail = prefs.getString('userEmail') ?? 'user@company.com';
    userRole = prefs.getString('userRole') ?? 'Project Creator';
    userPassword = prefs.getString('userPassword') ?? '';

    // Initialize dynamic deadlines for default projects
    _initializeDynamicProjectDeadlines();
  }
}
