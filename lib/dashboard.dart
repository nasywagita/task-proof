import 'package:flutter/material.dart';
import 'package:task_proof/create_project.dart';
import 'package:task_proof/join_project.dart';
import 'package:task_proof/project_detail_overview.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_list.dart';
import 'package:task_proof/app_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> get _dashboardProjects => AppState.instance.projects;

  String _getNextDeadline() {
    if (_dashboardProjects.isEmpty) {
      final now = DateTime.now();
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[now.month - 1]} ${now.day}';
    }

    DateTime? earliest;
    String earliestStr = '';

    final now = DateTime.now();
    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12
    };

    for (var project in _dashboardProjects) {
      final deadline = project['deadline']?.toString() ?? '';
      if (deadline.isEmpty || deadline.toLowerCase() == 'tbd') continue;

      final parts = deadline.trim().split(' ');
      if (parts.length == 2) {
        final monthStr = parts[0].toLowerCase();
        final dayStr = parts[1];

        if (months.containsKey(monthStr)) {
          final month = months[monthStr]!;
          final day = int.tryParse(dayStr);
          if (day != null) {
            final year = now.year;
            var projectDate = DateTime(year, month, day);
            if (projectDate.isBefore(DateTime(now.year, now.month, now.day))) {
              projectDate = DateTime(year + 1, month, day);
            }

            if (earliest == null || projectDate.isBefore(earliest)) {
              earliest = projectDate;
              earliestStr = deadline;
            }
          }
        }
      }
    }

    if (earliestStr.isNotEmpty) {
      return earliestStr;
    }

    final nowTime = DateTime.now();
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${monthNames[nowTime.month - 1]} ${nowTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${AppState.instance.userName}!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.50,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Ready to crush your goals today?',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF4B4356),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3313ECC8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Color(0xFF13ECC8),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFEDF6F1),
                          child: Icon(
                            Icons.person_rounded,
                            size: 24,
                            color: Color(0xFF006B58),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Stats Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x1413ECC8),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                          const Text(
                            'TOTAL PROJECTS',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_dashboardProjects.length}',
                            style: const TextStyle(
                              color: Color(0xFF13ECC8),
                              fontSize: 48,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFEBEB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'URGENT',
                              style: TextStyle(
                                color: Color(0xFFFF5252),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'NEXT DEADLINE',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getNextDeadline(),
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
                          );
                          if (result != null) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF13ECC8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3313ECC8),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Create Project',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const JoinProjectScreen()),
                          );
                          if (result != null) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: ShapeDecoration(
                            color: const Color(0x3313ECC8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Join Project',
                              style: TextStyle(
                                color: Color(0xFF0FBD9E),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Active Projects Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Projects',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProjectListScreen()));
                      },
                      child: const Text(
                        'VIEW ALL',
                        style: TextStyle(
                          color: Color(0xFF13ECC8),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Render dashboard projects dynamically
                ..._dashboardProjects.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildProjectCard(p),
                )),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
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
    final isBordered = project['isBordered'] ?? false;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProjectDetailOverviewScreen(project: project)),
        );
        if (result != null && result is Map<String, dynamic> && result['action'] == 'delete') {
          setState(() {
            _dashboardProjects.removeWhere((p) => p['title'] == result['title']);
          });
        } else {
          setState(() {});
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: isBordered ? const Color(0xFFF9F9FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: isBordered ? const BorderSide(width: 1, color: Color(0x4CCDC2DA)) : BorderSide.none,
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: isBordered
              ? []
              : const [
                  BoxShadow(
                    color: Color(0x1413ECC8),
                    blurRadius: 20,
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
                          child: Icon(Icons.folder, color: iconColor, size: 20),
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
                                fontWeight: FontWeight.w600,
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
