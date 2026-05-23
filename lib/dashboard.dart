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
  final int _currentIndex = 0;

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${AppState.instance.userName}!',
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
                          style: TextStyle(
                            color: Color(0xFF4B4356),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE2E8F0),
                        shape: OvalBorder(),
                        image: DecorationImage(
                          image: NetworkImage('https://i.pravatar.cc/100?img=33'),
                          fit: BoxFit.cover,
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
                        children: const [
                          Text(
                            'TOTAL PROJECTS',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '5',
                            style: TextStyle(
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
                          const Text(
                            'Oct 30',
                            style: TextStyle(
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
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProjectScreen()));
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
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinProjectScreen()));
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

                // Mobile App Redesign Card
                _buildProjectCard(
                  title: 'Mobile App Redesign',
                  team: 'Design Team',
                  status: 'ON TRACK',
                  statusColor: const Color(0xFF13ECC8),
                  statusBg: const Color(0x1A13ECC8),
                  progress: 0.75,
                  progressText: '75%',
                  tasks: '12 Tasks',
                  deadline: 'Oct 30',
                  iconBg: const Color(0xFFDCE2F7),
                  iconColor: const Color(0xFF5E7FE5),
                  isBordered: false,
                ),
                const SizedBox(height: 16),

                // Q4 Marketing Campaign Card
                _buildProjectCard(
                  title: 'Q4 Marketing Campaign',
                  team: 'Marketing Dept',
                  status: 'PLANNING',
                  statusColor: const Color(0xFF3B82F6),
                  statusBg: const Color(0x1A3B82F6),
                  progress: 0.15,
                  progressText: '15%',
                  tasks: '24 Tasks',
                  deadline: 'Nov 15',
                  iconBg: const Color(0xFFFFEBEB),
                  iconColor: const Color(0xFFFF5252),
                  isBordered: true,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String team,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required double progress,
    required String progressText,
    required String tasks,
    required String deadline,
    required Color iconBg,
    required Color iconColor,
    required bool isBordered,
  }) {
    return GestureDetector(
      onTap: () {
        final Map<String, dynamic> projectData = {
          'title': title,
          'team': team,
          'status': status,
          'statusColor': statusColor,
          'statusBg': statusBg,
          'progress': progress,
          'progressText': progressText,
          'tasks': tasks,
          'deadline': deadline,
        };
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailOverviewScreen(project: projectData)));
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
