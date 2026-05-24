import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_detail_task.dart';
import 'package:task_proof/project_detail_timeline.dart';
import 'package:task_proof/project_list.dart';
import 'package:task_proof/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const ProjectDetailOverviewScreen(project: {
        'title': 'Test Project',
        'deadline': 'TBD',
        'status': 'Testing',
        'progress': 0.0,
        'progressText': '0%',
        'team': 'Test Team'
      }),
    );
  }
}

class ProjectDetailOverviewScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailOverviewScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006B58)),
          onPressed: () { Navigator.pushReplacement(context, FadeRoute(page: const ProjectListScreen())); },
        ),
        title: const Text(
          'Task Proof',
          style: TextStyle(
            color: Color(0xFF006B58),
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF006B58)),
            onSelected: (value) {
              if (value == 'delete') {
                showDeleteProjectDialog(context, project);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete Project', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: CustomTabBar(project: project),
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ProjectCardHeader(project: project),
          const SizedBox(height: 16),
          const TeamCardSection(),
          const SizedBox(height: 16),
          ProgressCardSection(project: project),
          const SizedBox(height: 16),
          const JoinCodeCardSection(),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 1: TAB BAR ATAS ---
class CustomTabBar extends StatelessWidget {
  final Map<String, dynamic> project;

  const CustomTabBar({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _tabItem(context, 'Overview', isActive: true),
          _tabItem(context, 'Task', isActive: false),
          _tabItem(context, 'Timeline', isActive: false),
        ],
      ),
    );
  }

  Widget _tabItem(BuildContext context, String title, {required bool isActive}) {
    return GestureDetector(
      onTap: () {
        if (isActive) return;
        if (title == 'Task') {
          Navigator.pushReplacement(context, FadeRoute(page: ProjectDetailTaskScreen(project: project)));
        } else if (title == 'Timeline') {
          Navigator.pushReplacement(context, FadeRoute(page: ProjectDetailTimelineScreen(project: project)));
        } else if (title == 'Overview') {
          Navigator.pushReplacement(context, FadeRoute(page: ProjectDetailOverviewScreen(project: project)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: isActive
            ? const Border(
                bottom: BorderSide(color: Color(0xFF006B58), width: 2),
              )
            : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? const Color(0xFF006B58) : const Color(0xFF414947),
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      ),
    );
  }
}

//--- SUB-WIDGET 2: KARTU DETIL UTAMA ---
class ProjectCardHeader extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectCardHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F006B58),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCE8DF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Color(0xFF00201C),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline, color: Color(0xFF006B58)),
                onPressed: () {
                  showDeleteProjectDialog(context, project);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            project['title'] ?? 'Project Title',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project['description'] ?? 'Refreshing the UX for the Task Proof Android app. Focusing on performance improvements and modernizing the visual language to align with MD3 standards.',
            style: const TextStyle(
              color: Color(0xFF414947),
              height: 1.4,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          _tagBadge(Icons.calendar_today_outlined, 'Due ${project['deadline'] ?? ''}'),
          const SizedBox(height: 8),
          _tagBadge(Icons.flag_outlined, project['status'] ?? 'Active'),
        ],
      ),
    );
  }

  Widget _tagBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FBF7),
        border: Border.all(color: const Color(0xFFDEE4E2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF161D1B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF161D1B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

void showDeleteProjectDialog(BuildContext context, Map<String, dynamic> project) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5252)),
            SizedBox(width: 8),
            Text(
              'Delete Project',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF161D1B),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${project['title'] ?? 'this project'}"? This action cannot be undone and will permanently delete all tasks.',
          style: const TextStyle(color: Color(0xFF3F4946), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF3F4946))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              AppState.instance.projects.removeWhere(
                (p) => p['title'] == project['title'],
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF141B2B),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                  content: Row(
                    children: [
                      const Icon(Icons.delete, color: Color(0xFFFF8A8A)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Project "${project['title']}" deleted successfully.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              Navigator.pop(context, {
                'action': 'delete',
                'title': project['title'],
              });
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

//--- SUB-WIDGET 3: SECTION TEAM (AMBIL AVATAR AMAN) ---
class TeamCardSection extends StatefulWidget {
  const TeamCardSection({super.key});

  @override
  State<TeamCardSection> createState() => _TeamCardSectionState();
}

class _TeamCardSectionState extends State<TeamCardSection> {
  final List<Map<String, String>> _teamMembers = [
    {
      'name': 'Alex Johnson',
      'role': 'Product Designer',
      'avatar': 'https://i.pravatar.cc/100?img=1',
    },
    {
      'name': 'Ilham Ramadhan',
      'role': 'Mobile Developer',
      'avatar': 'https://i.pravatar.cc/100?img=2',
    },
    {
      'name': 'Sarah Smith',
      'role': 'QA Engineer',
      'avatar': 'https://i.pravatar.cc/100?img=3',
    },
  ];

  void _showManageTeamBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final nameController = TextEditingController();
        final roleController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 20.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Manage Team',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF161D1B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: _teamMembers.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Text(
                                'No team members yet.',
                                style: TextStyle(color: Color(0xFF64748B)),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _teamMembers.length,
                            itemBuilder: (context, index) {
                              final member = _teamMembers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(member['avatar'] ?? 'https://i.pravatar.cc/100?img=99'),
                                      backgroundColor: const Color(0xFFEDF6F1),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xFF161D1B),
                                            ),
                                          ),
                                          Text(
                                            member['role'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                      onPressed: () {
                                        setSheetState(() {
                                          _teamMembers.removeAt(index);
                                        });
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Add New Member',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF161D1B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. John Doe',
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: Color(0xFF006B58)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF13ECC8), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: roleController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Developer',
                      labelText: 'Role',
                      labelStyle: const TextStyle(color: Color(0xFF006B58)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF13ECC8), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final role = roleController.text.trim();
                      if (name.isEmpty || role.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      
                      final randomId = (_teamMembers.length + 1) * 3 % 70 + 1;
                      
                      setSheetState(() {
                        _teamMembers.add({
                          'name': name,
                          'role': role,
                          'avatar': 'https://i.pravatar.cc/100?img=$randomId',
                        });
                      });
                      setState(() {});
                      
                      nameController.clear();
                      roleController.clear();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name added to the team!'),
                          backgroundColor: const Color(0xFF006B58),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13ECC8),
                      foregroundColor: const Color(0xFF006655),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add Member', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F006B58),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ..._teamMembers.map((m) => _avatar(m['avatar'] ?? '')),
                  GestureDetector(
                    onTap: _showManageTeamBottomSheet,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3FBF7),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFBFC9C5)),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFF006B58),
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _showManageTeamBottomSheet,
                child: const Text(
                  'Manage Team',
                  style: TextStyle(
                    color: Color(0xFF006B58),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(url),
        backgroundColor: const Color(0xFFEDF6F1),
      ),
    );
  }
}

//--- SUB-WIDGET 4: SECTION PROGRESS (LINGKARAN PERSENTASE) ---
class ProgressCardSection extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProgressCardSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F006B58),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: project['progress'] as double? ?? 0.0,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFFE8EFEC),
                    color: const Color(0xFF006B58),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  project['progressText'] ?? '0%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF161D1B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '12 Completed',
                style: TextStyle(
                  color: Color(0xFF414947),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '4 Remaining',
                style: TextStyle(
                  color: Color(0xFF414947),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 5: JOIN CODE BANNER ---
class JoinCodeCardSection extends StatelessWidget {
  const JoinCodeCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF004D40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Join Code',
            style: TextStyle(
              color: Color(0xFF3CFFDF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Share this code with new members to grant them access.',
            style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TP-9821',
                  style: TextStyle(
                    color: Color(0xFF3CFFDF),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 6: NAVBAR BAWAH RESPONSIF ---
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFE8EFEC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14006B58),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.grid_view, 'Dashboard'),
          _navItem(Icons.folder, 'Projects', isActive: true),
          _navItem(Icons.task_alt, 'Tasks'),
          _navItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF006B58) : const Color(0xFF414947),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF006B58) : const Color(0xFF414947),
          ),
        ),
      ],
    );
  }
}
