import 'package:flutter/material.dart';
import 'package:task_proof/create_project.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/app_state.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JoinProjectScreen(),
    ),
  );
}

class JoinProjectScreen extends StatefulWidget {
  const JoinProjectScreen({super.key});

  @override
  State<JoinProjectScreen> createState() => _JoinProjectScreenState();
}

class _JoinProjectScreenState extends State<JoinProjectScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),

      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF151D1B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Project',
          style: TextStyle(
            color: Color(0xFF151D1B),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // TOGGLE
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF6F1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x4CB9CAC4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B4A45),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE5E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Join',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF151D1B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter Project Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF151D1B),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LABEL
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Project Code',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B4A45),
                ),
              ),
            ),

            const SizedBox(height: 8),

             // INPUT
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: Color(0xFF6A7B75),
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: 'E.G. 123456',
                hintStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Color(0xFF6A7B75),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // DESC
            const Text(
              'Enter the unique 6-digit code shared by your project administrator to join the team.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF3B4A45),
              ),
            ),

            const SizedBox(height: 40),

            // QR CIRCLE
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F0EB),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF3FBF7), width: 4),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 36,
                color: Color(0xFF6A7B75),
              ),
            ),

            const Spacer(),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final code = _codeController.text.trim();
                  if (code.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a project code'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Find if project already exists in global AppState
                  Map<String, dynamic>? existingProject;
                  
                  // Debug logging to help identify any issues in the terminal
                  print("--- DEBUG JOIN ---");
                  print("Master projects count: ${AppState.instance.projects.length}");
                  for (var p in AppState.instance.projects) {
                    print("Available Project: '${p['title']}' | Join Code: '${p['joinCode']}' | Creator: '${p['creatorEmail']}'");
                  }
                  print("User input code to match: '$code'");
                  
                  for (var project in AppState.instance.projects) {
                    // Normalize both codes by stripping spaces, dashes, and 'TP'
                    final normalizedJoin = (project['joinCode'] ?? '').toString().toUpperCase().replaceAll(' ', '').replaceAll('-', '').replaceAll('TP', '');
                    final normalizedSearch = code.toUpperCase().replaceAll(' ', '').replaceAll('-', '').replaceAll('TP', '');
                    
                    print("Comparing project joinCode '$normalizedJoin' with searchCode '$normalizedSearch'");
                    
                    if (normalizedJoin.isNotEmpty && normalizedSearch.isNotEmpty && 
                        (normalizedJoin == normalizedSearch || 
                         normalizedJoin.contains(normalizedSearch) || 
                         normalizedSearch.contains(normalizedJoin))) {
                      existingProject = project;
                      print("MATCH FOUND! Project: '${project['title']}'");
                      break;
                    }
                  }

                  if (existingProject != null) {
                    // Add user to joinedUsers list in existing project
                    existingProject['joinedUsers'] ??= <String>[];
                    final joinedList = List<String>.from(existingProject['joinedUsers']);
                    if (!joinedList.contains(AppState.instance.userEmail)) {
                      joinedList.add(AppState.instance.userEmail);
                      existingProject['joinedUsers'] = joinedList;
                    }

                    if (existingProject['teamMembers'] == null) {
                      existingProject['teamMembers'] = <Map<String, String>>[];
                    }
                    final teamList = List<Map<String, String>>.from(existingProject['teamMembers']);
                    final alreadyMember = teamList.any((m) => m['name'] == AppState.instance.userName);
                    if (!alreadyMember) {
                      teamList.add({
                        'name': AppState.instance.userName,
                        'role': 'Anggota',
                        'avatar': 'https://i.pravatar.cc/100?img=5',
                      });
                      existingProject['teamMembers'] = teamList;

                      // Add to auditLog
                      if (existingProject['auditLog'] == null) {
                        existingProject['auditLog'] = <Map<String, dynamic>>[];
                      }
                      final auditList = List<Map<String, dynamic>>.from(existingProject['auditLog']);
                      auditList.insert(0, {
                        'title': AppState.instance.userName,
                        'action': 'joined the project',
                        'time': 'Just now',
                        'dotColor': const Color(0xFF10B981),
                      });
                      existingProject['auditLog'] = auditList;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Joined Project "${existingProject['title']}" successfully!'),
                        backgroundColor: const Color(0xFF006B59),
                      ),
                    );
                    Navigator.pop(context, existingProject);
                  } else {
                    // Create fallback project with role 'anggota'
                    final normalizedCode = code.startsWith('TP-') ? code : 'TP-$code';
                    final joinedProject = {
                      'title': 'Project $code',
                      'description': 'Collaborating on Project $code.',
                      'due': 'Dec 25, 2026',
                      'team': 'Collaborator Team',
                      'status': 'ON TRACK',
                      'statusColor': const Color(0xFF13ECC8),
                      'statusBg': const Color(0x2613ECC8),
                      'progress': 0.0,
                      'progressText': '0%',
                      'tasks': '0 Tasks',
                      'deadline': 'Dec 25',
                      'iconBg': const Color(0xFFE2F7ED),
                      'iconColor': const Color(0xFF10B981),
                      'isBordered': false,
                      'taskList': <Map<String, dynamic>>[],
                      'joinCode': normalizedCode,
                      'creatorEmail': 'creator_demo@company.com',
                      'joinedUsers': <String>[AppState.instance.userEmail],
                      'teamMembers': <Map<String, String>>[
                        {
                          'name': AppState.instance.userName,
                          'role': 'Anggota',
                          'avatar': 'https://i.pravatar.cc/100?img=5',
                        }
                      ],
                      'auditLog': <Map<String, dynamic>>[
                        {
                          'title': AppState.instance.userName,
                          'action': 'joined the project',
                          'time': 'Just now',
                          'dotColor': const Color(0xFF10B981),
                        }
                      ],
                    };

                    // Add to AppState list at the beginning
                    AppState.instance.projects.insert(0, joinedProject);

                    // Show success SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Joined Project $code successfully!'),
                        backgroundColor: const Color(0xFF006B58),
                      ),
                    );

                    // Pop and return the project
                    Navigator.pop(context, joinedProject);
                  }
                },
                icon: const Icon(Icons.login, color: Color(0xFF006655)),
                label: const Text(
                  'Join Project',
                  style: TextStyle(
                    color: Color(0xFF006655),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13ECC8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
    );
  }
}
