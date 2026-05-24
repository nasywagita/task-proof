import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/join_project.dart';
import 'package:task_proof/project_detail_overview.dart';
import 'package:task_proof/create_project.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  String selectedFilter = 'All';

  // Dummy Project Data based on the app state
  final List<Map<String, dynamic>> _allProjects = [
    {
      'title': 'Mobile App Redesign',
      'team': 'Design Team',
      'status': 'ON TRACK',
      'statusColor': const Color(0xFF13ECC8),
      'statusBg': const Color(0x2613ECC8),
      'progress': 0.75,
      'progressText': '75%',
      'tasks': '12 Tasks',
      'deadline': 'Oct 30',
      'iconBg': const Color(0xFFDCE2F7),
      'iconColor': const Color(0xFF5E7FE5),
    },
    {
      'title': 'Q4 Marketing Campaign',
      'team': 'Marketing Dept',
      'status': 'PLANNING',
      'statusColor': const Color(0xFF3B82F6),
      'statusBg': const Color(0x1A3B82F6),
      'progress': 0.15,
      'progressText': '15%',
      'tasks': '24 Tasks',
      'deadline': 'Nov 15',
      'iconBg': const Color(0xFFFFEBEB),
      'iconColor': const Color(0xFFFF5252),
    },
    {
      'title': 'Web Portal Development',
      'team': 'Engineering Team',
      'status': 'ON TRACK',
      'statusColor': const Color(0xFF13ECC8),
      'statusBg': const Color(0x2613ECC8),
      'progress': 0.45,
      'progressText': '45%',
      'tasks': '18 Tasks',
      'deadline': 'Dec 05',
      'iconBg': const Color(0xFFE2F7ED),
      'iconColor': const Color(0xFF10B981),
    },
    {
      'title': 'Brand Identity Guidelines',
      'team': 'Design Team',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF10B981),
      'statusBg': const Color(0x1A10B981),
      'progress': 1.0,
      'progressText': '100%',
      'tasks': '8 Tasks',
      'deadline': 'May 15',
      'iconBg': const Color(0xFFF7EBE2),
      'iconColor': const Color(0xFFF59E0B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeDynamicProjectDeadlines();
  }

  void _initializeDynamicProjectDeadlines() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    if (_allProjects.length >= 4) {
      // Project 1 (ON TRACK, e.g. 5 days from now)
      final date1 = now.add(const Duration(days: 5));
      _allProjects[0]['deadline'] = '${months[date1.month - 1]} ${date1.day}';

      // Project 2 (PLANNING, e.g. 15 days from now)
      final date2 = now.add(const Duration(days: 15));
      _allProjects[1]['deadline'] = '${months[date2.month - 1]} ${date2.day}';

      // Project 3 (ON TRACK, e.g. 20 days from now)
      final date3 = now.add(const Duration(days: 20));
      _allProjects[2]['deadline'] = '${months[date3.month - 1]} ${date3.day}';

      // Project 4 (COMPLETED, e.g. 10 days ago)
      final date4 = now.subtract(const Duration(days: 10));
      _allProjects[3]['deadline'] = '${months[date4.month - 1]} ${date4.day}';
    }
  }

  List<Map<String, dynamic>> get _filteredProjects {
    if (selectedFilter == 'All') {
      return _allProjects;
    }
    return _allProjects.where((p) {
      final status = p['status'].toString().toUpperCase();
      if (selectedFilter == 'On Track') return status == 'ON TRACK';
      if (selectedFilter == 'Planning') return status == 'PLANNING';
      if (selectedFilter == 'Completed') return status == 'COMPLETED';
      return true;
    }).toList();
  }

  void _showProjectActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag handle
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
                  'Project Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF151D1B),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose whether you want to start a new project or collaborate on an existing one.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B4356),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 24),
                
                // Create Project Option
                InkWell(
                  onTap: () async {
                    Navigator.pop(context); // Close bottom sheet
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _allProjects.insert(0, result);
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x1F000000)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0x1A13ECC8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(
                            Icons.create_new_folder_rounded,
                            color: Color(0xFF006B59),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Create New Project',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF151D1B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Start from scratch, invite members & assign tasks.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Join Project Option
                InkWell(
                  onTap: () async {
                    Navigator.pop(context); // Close bottom sheet
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JoinProjectScreen()),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _allProjects.insert(0, result);
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x1F000000)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0x1A3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Icon(
                            Icons.group_add_rounded,
                            color: Color(0xFF1D4ED8),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Join Existing Project',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF151D1B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enter a 6-digit code to join a team project.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredProjects;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7), // Matching consistent project background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Projects',
          style: TextStyle(
            color: Color(0xFF151D1B),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('On Track'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Planning'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),

          // Projects List
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'No projects found in this category',
                      style: TextStyle(
                        color: Color(0xFF4B4356),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final project = filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildProjectCard(
                          project: project,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProjectActionsBottomSheet(context),
        backgroundColor: const Color(0xFF13ECC8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 28,
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF13ECC8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF13ECC8) : const Color(0xFFDEE4E2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF4B4356),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required Map<String, dynamic> project,
  }) {
    final title = project['title'] as String;
    final team = project['team'] as String;
    final status = project['status'] as String;
    final statusColor = project['statusColor'] as Color;
    final statusBg = project['statusBg'] as Color;
    final progress = project['progress'] as double;
    final progressText = project['progressText'] as String;
    final tasks = project['tasks'] as String;
    final deadline = project['deadline'] as String;
    final iconBg = project['iconBg'] as Color;
    final iconColor = project['iconColor'] as Color;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailOverviewScreen(project: project),
          ),
        );
        if (result != null && result is Map<String, dynamic> && result['action'] == 'delete') {
          setState(() {
            _allProjects.removeWhere((p) => p['title'] == result['title']);
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: iconBg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Center(
                          child: Icon(Icons.folder_rounded, color: iconColor, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF141B2B),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              team,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF4B4356),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: ShapeDecoration(
                    color: statusBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    color: Color(0xFF4B4356),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  progressText,
                  style: const TextStyle(
                    color: Color(0xFF141B2B),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              width: double.infinity,
              decoration: ShapeDecoration(
                color: const Color(0xFFF3EDF8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: statusColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Color(0xFF90869C), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      tasks,
                      style: const TextStyle(
                        color: Color(0xFF90869C),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Color(0xFF90869C), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      deadline,
                      style: const TextStyle(
                        color: Color(0xFF90869C),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
