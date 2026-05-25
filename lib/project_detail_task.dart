import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_detail_overview.dart';
import 'package:task_proof/project_detail_timeline.dart' show ProjectDetailTimelineScreen;
import 'package:task_proof/task_detail.dart';
import 'package:task_proof/add_task.dart';

void main() {
  runApp(MaterialApp(
    home: const ProjectDetailTaskScreen(project: {
      'title': 'Test Project',
      'deadline': 'TBD',
      'status': 'Testing',
      'progress': 0.0,
      'progressText': '0%',
      'team': 'Test Team'
    }),
  ));
}

class ProjectDetailTaskScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailTaskScreen({super.key, required this.project});

  @override
  State<ProjectDetailTaskScreen> createState() => _ProjectDetailTaskScreenState();
}

class _ProjectDetailTaskScreenState extends State<ProjectDetailTaskScreen> {
  // Daftar tugas proyek dari global state
  List<Map<String, dynamic>> get _tasks {
    if (widget.project['taskList'] == null) {
      widget.project['taskList'] = <Map<String, dynamic>>[];
    }
    return List<Map<String, dynamic>>.from(widget.project['taskList']);
  }

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
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFF006B58)),
              onSelected: (value) {
                if (value == 'delete') {
                  showDeleteProjectDialog(context, widget.project);
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
          bottom: TaskDetailTabBar(project: widget.project),
        ),
        bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF13ECC8),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black),
          onPressed: () async {
            // Navigasi ke AddTaskScreen dan menunggu data yang di-pop kembali
            final result = await Navigator.push(
              context,
              SlideFadeRoute(page: const AddTaskScreen()),
            );
            
            // Jika ada data tugas baru yang ditambahkan, masukkan ke list tugas dinamis
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                if (widget.project['taskList'] == null) {
                  widget.project['taskList'] = <Map<String, dynamic>>[];
                }
                final List<Map<String, dynamic>> taskList = List<Map<String, dynamic>>.from(widget.project['taskList']);
                taskList.insert(0, {
                  'title': result['title'] ?? 'New Task',
                  'deadline': result['deadline'] ?? 'No Deadline',
                  'status': 'To Do',
                  'description': result['desc'] ?? result['description'] ?? 'No description provided.',
                  'assignee': result['member'] ?? result['assignee'] ?? 'Unassigned',
                });
                widget.project['taskList'] = taskList;
                
                // Update project task count dynamically
                final int count = taskList.length;
                widget.project['tasks'] = '$count Task${count == 1 ? "" : "s"}';
              });
            }
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ProjectCardHeader(project: widget.project),
            const SizedBox(height: 24),
            
            // Task List Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF161D1B),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                
                // Render list tugas secara dinamis dari state _tasks
                ..._tasks.map((task) => _buildTaskCard(
                  context,
                  task,
                )),
              ],
            ),
          ],
        ),
      );
  }

  // Helper untuk membuat Kartu Task
  Widget _buildTaskCard(
    BuildContext context,
    Map<String, dynamic> task,
  ) {
    final title = task['title'] ?? '';
    final deadline = task['deadline'] ?? '';
    final status = task['status'] ?? 'To Do';

    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case 'Completed':
        statusColor = const Color(0xFF006B58);
        statusBgColor = const Color(0xFFCCE8DF);
        break;
      case 'In Progress':
        statusColor = const Color(0xFF004D40);
        statusBgColor = const Color(0xFFBCF0E5);
        break;
      case 'Pending Review':
        statusColor = const Color(0xFF8D6E63);
        statusBgColor = const Color(0xFFEFEBE9);
        break;
      default:
        statusColor = const Color(0xFF414947);
        statusBgColor = const Color(0xFFDEE4E2);
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFBCF0E5)),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0A006B58),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF161D1B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Color(0xFF707975),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Due: $deadline',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF707975),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> project;

  const TaskDetailTabBar({super.key, required this.project});

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
          _tabItem(context, 'Task', isActive: true),
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