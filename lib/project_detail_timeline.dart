import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_detail_overview.dart';
import 'package:task_proof/project_detail_task.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProjectDetailTimelineScreen(
        project: {
          'title': 'Test Project',
          'deadline': 'TBD',
          'status': 'Testing',
          'progress': 0.0,
          'progressText': '0%',
          'team': 'Test Team',
        },
      ),
    ),
  );
}

class ProjectDetailTimelineScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailTimelineScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        actions: [],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              _tab(context, 'Overview'),
              _tab(context, 'Task'),
              _tab(context, 'Timeline', active: true),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProjectCardHeader(project: project),

          const SizedBox(height: 24),

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

                  child: Container(width: 2, color: const Color(0xFFBCF0E5)),
                ),

                Column(
                  children: (project['auditLog'] as List<dynamic>? ?? []).map((log) {
                    final isLast = log == (project['auditLog'] as List).last;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0),
                      child: _buildTimelineItem(
                        title: log['title'] ?? 'Unknown',
                        action: log['action'] ?? '',
                        time: log['time'] ?? '',
                        dotColor: log['dotColor'] ?? const Color(0xFF13ECC8),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTimelineItem({
    required String title,
    required String action,
    required String time,
    required Color dotColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 16,
          height: 16,

          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF161D1B),
                    fontSize: 14,
                  ),

                  children: [
                    TextSpan(
                      text: '$title ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    TextSpan(
                      text: action,
                      style: const TextStyle(color: Color(0xFF414946)),
                    ),
                  ],
                ),
              ),

              Text(
                time,
                style: const TextStyle(color: Color(0xFF707975), fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tab(BuildContext context, String title, {bool active = false}) {
    return GestureDetector(
      onTap: () {
        if (title == 'Overview') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectDetailOverviewScreen(project: project),
            ),
          );
        }

        if (title == 'Task') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectDetailTaskScreen(project: project),
            ),
          );
        }
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.only(bottom: 8),

        decoration: active
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF006B58), width: 2),
                ),
              )
            : null,

        child: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF006B58) : const Color(0xFF414947),

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

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
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project['title'] ?? 'Project',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Text('Deadline: ${project['deadline']}'),

          Text('Status: ${project['status']}'),
        ],
      ),
    );
  }
}

void showDeleteProjectDialog(
  BuildContext context,
  Map<String, dynamic> project,
) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Delete Project'),

        content: Text('Delete "${project['title']}"?'),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
