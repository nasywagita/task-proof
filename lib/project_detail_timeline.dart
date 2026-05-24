import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_detail_overview.dart';
import 'package:task_proof/project_detail_task.dart';

void main() {
  runApp(const MaterialApp(home: ProjectDetailTimelineScreen(project: {
    'title': 'Test Project',
    'deadline': 'TBD',
    'status': 'Testing',
    'progress': 0.0,
    'progressText': '0%',
    'team': 'Test Team'
  })));
}

class ProjectDetailTimelineScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailTimelineScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color(0xFFF3FBF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3FBF7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF006B58)),
            onPressed: () {
              Navigator.pop(context);
            },
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
          bottom: TimelineDetailTabBar(project: project),
        ),
        bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ProjectCardHeader(project: project),
            const SizedBox(height: 24),

            // Timeline Card / Activity Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1413ECC8),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 7,
                    top: 8,
                    bottom: 8,
                    child: Container(
                      width: 2,
                      color: const Color(0xFFBCF0E5),
                    ),
                  ),
                  Column(
                    children: [
                      _buildTimelineItem(
                        title: 'Ilham',
                        action: 'uploaded progress',
                        time: 'Just now',
                        dotColor: const Color(0xFF13ECC8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECF4EF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0x4CBCF0E5)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF13ECC8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Homepage_V2_Final.fig',
                                      style: TextStyle(
                                        color: Color(0xFF161D1B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Figma Design File • 4.2 MB',
                                      style: TextStyle(
                                        color: Color(0xFF414946),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTimelineItem(
                        title: 'Alex',
                        action: 'created UI Components',
                        time: '2 hours ago',
                        dotColor: const Color(0xFFE1E9E5),
                        hasBorderDot: true,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildBadge('Buttons'),
                            _buildBadge('Cards'),
                            _buildBadge('Navigation'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTimelineItem(
                        title: 'Sarah',
                        action: 'joined the project',
                        time: 'Yesterday at 4:30 PM',
                        dotColor: const Color(0xFFE1E9E5),
                        isLast: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String action,
    required String time,
    required Color dotColor,
    bool hasBorderDot = false,
    bool isLast = false,
    Widget? child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: hasBorderDot ? Border.all(color: const Color(0xFF13ECC8), width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: isLast ? 4 : 3,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Color(0xFF161D1B), fontSize: 14, fontFamily: 'Inter'),
                  children: [
                    TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: action, style: const TextStyle(color: Color(0xFF414946))),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: Color(0xFF707975), fontSize: 11),
              ),
              if (child != null) ...[const SizedBox(height: 8), child],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EFE9),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0x7FBCF0E5)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF161D1B), fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class TimelineDetailTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> project;

  const TimelineDetailTabBar({super.key, required this.project});

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _tabItem(context, 'Overview', isActive: false),
          _tabItem(context, 'Task', isActive: false),
          _tabItem(context, 'Timeline', isActive: true),
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
                  bottom: BorderSide(color: Color(0xFF006B5A), width: 2),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF006B5A) : const Color(0xFF414947),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
