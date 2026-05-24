import 'package:flutter/material.dart';
import 'package:task_proof/join_project.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF006B59),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006B59),
          primary: const Color(0xFF006B59),
        ),
      ),
      // Scaffold harus berada di dalam Navigator konteks MaterialApp yang valid
      home: const CreateProjectScreen(),
    );
  }
}

class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),
      appBar: AppBar(
        title: const Text(
          'Project',
          style: TextStyle(
            color: Color(0xFF151D1B),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        centerTitle: true,
      ),
      body: const CreateJoinProjectBody(),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
    );
  }
}

class CreateJoinProjectBody extends StatefulWidget {
  const CreateJoinProjectBody({super.key});

  @override
  State<CreateJoinProjectBody> createState() => _CreateJoinProjectBodyState();
}

class _CreateJoinProjectBodyState extends State<CreateJoinProjectBody> {
  bool isCreateTab = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3FBF7),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          //--- TOGGLE TABS ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF6F1),
              border: Border.all(color: const Color(0x4CB9CAC4)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isCreateTab = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isCreateTab
                            ? const Color(0xFFDCE5E0)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Create',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const JoinProjectScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isCreateTab
                            ? const Color(0xFFDCE5E0)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Join',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          //--- FORM INPUT ---
          const Text(
            'Project Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF151D1B),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Project Name',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B4A45),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'e.g. Mobile App Redesign',
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Description',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B4A45),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _descController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe the goals and scope...',
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Deadline',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B4A45),
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'mm / dd / yyyy',
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: Color(0xFF3B4A45),
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB9CAC4)),
              ),
            ),
            onTap: () async {
              // Pemanggilan DatePicker yang aman dengan safety check null
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _dateController.text =
                      "${pickedDate.month.toString().padLeft(2, '0')} / ${pickedDate.day.toString().padLeft(2, '0')} / ${pickedDate.year}";
                });
              }
            },
          ),
          const SizedBox(height: 24),

          //--- INFO BOX ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE1EAE6),
              border: Border.all(color: const Color(0xFF006B59), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF006B59)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF151D1B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'A unique 6-digit join code will be generated upon creation. As the creator, you will be automatically assigned as the Project Administrator.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF3B4A45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          //--- SUBMIT BUTTON ---
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13ECC8),
              foregroundColor: const Color(0xFF006655),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () {
              final name = _nameController.text.trim();
              final description = _descController.text.trim();
              final deadlineText = _dateController.text.isNotEmpty ? _dateController.text : 'TBD';

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a project name'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Format the deadline display text (e.g. converting "10 / 30 / 2026" to "Oct 30")
              String displayDeadline = 'TBD';
              if (_dateController.text.isNotEmpty) {
                try {
                  final parts = _dateController.text.split(' / ');
                  if (parts.length == 3) {
                    final month = int.parse(parts[0]);
                    final day = int.parse(parts[1]);
                    const months = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                    ];
                    if (month >= 1 && month <= 12) {
                      displayDeadline = '${months[month - 1]} $day';
                    }
                  }
                } catch (_) {
                  displayDeadline = deadlineText;
                }
              }

              final newProject = {
                'title': name,
                'description': description,
                'due': deadlineText,
                'team': 'Creator Team',
                'status': 'PLANNING',
                'statusColor': const Color(0xFF3B82F6),
                'statusBg': const Color(0x1A3B82F6),
                'progress': 0.0,
                'progressText': '0%',
                'tasks': '0 Tasks',
                'deadline': displayDeadline,
                'iconBg': const Color(0xFFFFEBEB),
                'iconColor': const Color(0xFFFF5252),
                'isBordered': true,
              };

              // Add to AppState list
              AppState.instance.projects.add(newProject);

              // Show success SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Project "$name" created successfully!'),
                  backgroundColor: const Color(0xFF006B59),
                ),
              );

              // Pop and return the project
              Navigator.pop(context, newProject);
            },
            child: const Text(
              'Create Project',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}


