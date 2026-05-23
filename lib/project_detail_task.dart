import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_detail_overview.dart';
import 'package:task_proof/project_detail_timeline.dart';
import 'package:task_proof/task_detail.dart';
import 'package:task_proof/add_task.dart';

void main() {
  runApp(const ProjectDetailTaskScreen());
}

class ProjectDetailTaskScreen extends StatefulWidget {
  const ProjectDetailTaskScreen({super.key});

  @override
  State<ProjectDetailTaskScreen> createState() => _ProjectDetailTaskScreenState();
}

class _ProjectDetailTaskScreenState extends State<ProjectDetailTaskScreen> {
  // Daftar tugas proyek lokal dinamis
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'UI Login Screen',
      'deadline': 'Oct 30, 2026',
      'status': 'In Progress',
    },
    {
      'title': 'UI Registration Page',
      'deadline': 'Oct 28, 2026',
      'status': 'Pending Review',
    },
    {
      'title': 'Wireframing Homepage',
      'deadline': 'Sep 15, 2026',
      'status': 'Completed',
    },
    {
      'title': 'User Persona Documentation',
      'deadline': 'Sep 10, 2026',
      'status': 'Completed',
    },
  ];

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
            IconButton(
              icon: const Icon(Icons.more_vert, color: Color(0xFF006B58)),
              onPressed: () {},
            ),
          ],
          bottom: const TaskDetailTabBar(),
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
                _tasks.insert(0, {
                  'title': result['title'] ?? 'New Task',
                  'deadline': result['deadline'] ?? 'No Deadline',
                  'status': 'To Do',
                });
              });
            }
          },
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const ProjectCardHeader(),
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
                  title: task['title'] ?? '',
                  deadline: task['deadline'] ?? '',
                  status: task['status'] ?? 'To Do',
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat Kartu Task
  Widget _buildTaskCard(
    BuildContext context, {
    required String title,
    required String deadline,
    required String status,
  }) {
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TaskDetailScreen()),
        );
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
  const TaskDetailTabBar({super.key});

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
          Navigator.pushReplacement(context, FadeRoute(page: const ProjectDetailTaskScreen()));
        } else if (title == 'Timeline') {
          Navigator.pushReplacement(context, FadeRoute(page: const ProjectDetailTimelineScreen()));
        } else if (title == 'Overview') {
          Navigator.pushReplacement(context, FadeRoute(page: const ProjectDetailOverviewScreen()));
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