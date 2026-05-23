import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/add_progress.dart';
import 'package:task_proof/task_list.dart';

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
      home: const TaskDetailScreen(
        task: {
          'title': 'Test Task',
          'deadline': 'Oct 30',
          'status': 'In Progress'
        }
      ),
    );
  }
}

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final List<Map<String, dynamic>> _progressHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),
      //--- CUSTOM APP BAR ---
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006B58)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TaskListScreen()),
            );
          },
        ),
        title: const Text(
          'Task Proof',
          style: TextStyle(
            color: Color(0xFF006B58),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/100?img=33',
            ), // Foto profil kanan atas
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF006B58),
            ),
            onPressed: () {},
          ),
        ],
      ),

      //--- BODY CONTENT ---
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          TaskHeaderSection(task: widget.task),
          const SizedBox(height: 16),
          DescriptionCard(task: widget.task),
          SizedBox(height: 24),
          Text(
            'Progress History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          SizedBox(height: 16),
          ProgressTimelineSection(history: _progressHistory),
        ],
      ),

      //--- FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF13ECC8),
        foregroundColor: const Color(0xFF00382E),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProgressScreen()),
          );
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _progressHistory.insert(0, result);
            });
          }
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

//--- SUB-WIDGET 1: HEADER JUDUL & META DATA ---
class TaskHeaderSection extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskHeaderSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                task['title'] ?? 'Task Title',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161D1B),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x3313ECC8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF13ECC8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    task['status'] ?? 'To Do',
                    style: const TextStyle(
                      color: Color(0xFF00382E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.person_outline, size: 16, color: Color(0xFF3F4946)),
            const SizedBox(width: 4),
            const Text(
              'Assigned to: ',
              style: TextStyle(color: Color(0xFF3F4946), fontSize: 13),
            ),
            Text(
              task['assignee'] ?? 'Unassigned',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF161D1B),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 24),
            const Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: Color(0xFF3F4946),
            ),
            const SizedBox(width: 4),
            const Text(
              'Deadline: ',
              style: TextStyle(color: Color(0xFF3F4946), fontSize: 13),
            ),
            Text(
              task['deadline'] ?? 'No Deadline',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF161D1B),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//--- SUB-WIDGET 2: KARTU DESKRIPSI ---
class DescriptionCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const DescriptionCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDAE5E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task['description'] ?? 'No description provided for this task. Please add more details if needed.',
            style: const TextStyle(
              color: Color(0xFF3F4946),
              height: 1.45,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 3: TIMELINE HISTORY LIST ---
class ProgressTimelineSection extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const ProgressTimelineSection({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dynamic history
        ...history.map((item) => _buildTimelineItem(
          isActive: true,
          statusBadge: _statusBadge(
            'Under Review',
            const Color(0x3313ECC8),
            const Color(0xFF00382E),
          ),
          name: item['user'] ?? 'User',
          date: item['time'] ?? 'Just now',
          content: Text(
            item['notes'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF161D1B)),
          ),
          extraChild: (item['link'] != null && item['link'].toString().isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0x0A006B58),
                        ),
                        icon: const Icon(
                          Icons.link,
                          size: 16,
                          color: Color(0xFF006B58),
                        ),
                        label: const Text(
                          'Attachment Link',
                          style: TextStyle(color: Color(0xFF006B58), fontSize: 12),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              : null,
        )),

        // Card 1: Pending Review (Aktif)
        _buildTimelineItem(
          isActive: true,
          statusBadge: _statusBadge(
            'Pending Review',
            const Color(0x3313ECC8),
            const Color(0xFF00382E),
          ),
          name: 'Ilham',
          date: '12 Mei, 14:30',
          content: const Text(
            '“UI Login selesai, mohon di review untuk layout mobile-nya.”',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          extraChild: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0x0A006B58),
                  ),
                  icon: const Icon(
                    Icons.link,
                    size: 16,
                    color: Color(0xFF006B58),
                  ),
                  label: const Text(
                    'Figma Design Link',
                    style: TextStyle(color: Color(0xFF006B58), fontSize: 12),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          bottomButtons: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13ECC8),
                    foregroundColor: const Color(0xFF00382E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text(
                    'Approve',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF13ECC8),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 16,
                    color: Color(0xFF00382E),
                  ),
                  label: const Text(
                    'Reject',
                    style: TextStyle(
                      color: Color(0xFF00382E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        // Card 2: Rejected (History Lama)
        _buildTimelineItem(
          isActive: false,
          statusBadge: _statusBadge(
            'Rejected',
            const Color(0xFFDAE5E1),
            const Color(0xFF3F4946),
          ),
          name: 'Ilham',
          date: '10 Mei, 09:15',
          content: const Text(
            'Draft pertama untuk UI Login.',
            style: TextStyle(color: Color(0xFF3F4946), fontSize: 14),
          ),
          extraChild: Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FBF7),
              border: Border.all(color: const Color(0xFFBEC9C5)),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REASON FOR REJECTION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F4946),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Layout not responsive on smaller mobile screens (< 360px width).',
                  style: TextStyle(fontSize: 13, color: Color(0xFF3F4946)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper untuk membuat item bergaris waktu samping (Timeline)
  Widget _buildTimelineItem({
    required bool isActive,
    required Widget statusBadge,
    required String name,
    required String date,
    required Widget content,
    Widget? extraChild,
    Widget? bottomButtons,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Garis Alur/Timeline Pasif & Aktif kiri
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF13ECC8)
                        : const Color(0xFFBEC9C5),
                    width: 2,
                  ),
                ),
              ),
              Expanded(
                child: Container(width: 2, color: const Color(0xFFDAE5E1)),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Kolom isi Kotak Card kanan
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : const Color(0xFFEDF6F1).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDAE5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$name  •  $date',
                        style: const TextStyle(
                          color: Color(0xFF3F4946),
                          fontSize: 12,
                        ),
                      ),
                      statusBadge,
                    ],
                  ),
                  const SizedBox(height: 8),
                  content,
                  ?extraChild,
                  if (bottomButtons != null) ...[
                    const SizedBox(height: 16),
                    bottomButtons,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
