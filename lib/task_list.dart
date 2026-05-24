import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF151D1B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Task Detail',
          style: TextStyle(
            color: Color(0xFF151D1B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task['title'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF151D1B),
              ),
            ),

            const SizedBox(height: 16),

            _infoTile(
              icon: Icons.folder,
              label: 'Project',
              value: task['project'] ?? '-',
            ),

            const SizedBox(height: 12),

            _infoTile(
              icon: Icons.calendar_today,
              label: 'Deadline',
              value: task['deadline'] ?? '-',
            ),

            const SizedBox(height: 12),

            _infoTile(
              icon: Icons.flag,
              label: 'Status',
              value: task['status'] ?? '-',
            ),

            const SizedBox(height: 12),

            _infoTile(
              icon: Icons.person,
              label: 'Assignee',
              value: task['assignee'] ?? '-',
            ),

            const SizedBox(height: 24),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF151D1B),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                border: Border.all(color: const Color(0xFFDEE4E2)),
              ),

              child: Text(
                task['description'] ?? 'No description',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B4356),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF13ECC8)),

        const SizedBox(width: 10),

        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF151D1B),
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(value, style: const TextStyle(color: Color(0xFF4B4356))),
        ),
      ],
    );
  }
}
