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
                  if (code.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 6-digit project code'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final joinedProject = {
                    'title': 'Project $code',
                    'description': 'Collaborating on Project $code.',
                    'due': 'Dec 25, 2026',
                    'team': 'Collaborator Team',
                    'status': 'ON TRACK',
                    'statusColor': const Color(0xFF13ECC8),
                    'statusBg': const Color(0x2613ECC8),
                    'progress': 0.1,
                    'progressText': '10%',
                    'tasks': '0 Tasks',
                    'deadline': 'Dec 25',
                    'iconBg': const Color(0xFFE2F7ED),
                    'iconColor': const Color(0xFF10B981),
                    'isBordered': false,
                    'taskList': <Map<String, dynamic>>[],
                  };

                  // Add to AppState list at the beginning
                  AppState.instance.projects.insert(0, joinedProject);

                  // Show success SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Joined Project $code successfully!'),
                      backgroundColor: const Color(0xFF006B59),
                    ),
                  );

                  // Pop and return the project
                  Navigator.pop(context, joinedProject);
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
