import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/task_detail.dart';
import 'package:task_proof/app_state.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedFilter = 'All';


  List<Map<String, dynamic>> get _groupedFilteredProjects {
    final List<Map<String, dynamic>> grouped = [];
    final email = AppState.instance.userEmail.toLowerCase().trim();
    for (var project in AppState.instance.projects) {
      final creator = (project['creatorEmail'] ?? '').toString().toLowerCase().trim();
      final joined = project['joinedUsers'] as List<dynamic>? ?? [];
      final hasAccess = creator == email || joined.any((u) => u.toString().toLowerCase().trim() == email);
      
      if (!hasAccess) continue;

      final projectName = project['title'] as String;
      final taskList = project['taskList'];
      final List<Map<String, dynamic>> projectTasks = [];
      
      if (taskList != null && taskList is List) {
        for (var task in taskList) {
          if (task is Map) {
            final Map<String, dynamic> taskMap = Map<String, dynamic>.from(task);
            final status = taskMap['status'].toString().toUpperCase();
            
            bool matchesFilter = false;
            if (selectedFilter == 'All') {
              matchesFilter = true;
            } else if (selectedFilter == 'To Do' && status == 'TO DO') {
              matchesFilter = true;
            } else if (selectedFilter == 'In Progress' && status == 'IN PROGRESS') {
              matchesFilter = true;
            } else if (selectedFilter == 'Pending Review' && status == 'PENDING REVIEW') {
              matchesFilter = true;
            } else if (selectedFilter == 'Completed' && status == 'COMPLETED') {
              matchesFilter = true;
            }
            
            if (matchesFilter) {
              projectTasks.add(taskMap);
            }
          }
        }
      }
      
      if (projectTasks.isNotEmpty) {
        grouped.add({
          'projectName': projectName,
          'tasks': projectTasks,
        });
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedList = _groupedFilteredProjects;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tasks',
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
                  _buildFilterChip('To Do'),
                  const SizedBox(width: 8),
                  _buildFilterChip('In Progress'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending Review'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),

          // Tasks Grouped List
          Expanded(
            child: groupedList.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks found in this category',
                      style: TextStyle(
                        color: Color(0xFF4B4356),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: groupedList.length,
                    itemBuilder: (context, index) {
                      final group = groupedList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildGroupedProjectCard(
                          project: group['projectName'],
                          tasks: List<Map<String, dynamic>>.from(group['tasks']),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 2),
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

  Widget _buildGroupedProjectCard({
    required String project,
    required List<Map<String, dynamic>> tasks,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDEE4E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.folder, color: Color(0xFF13ECC8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    project,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF151D1B),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F7ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length} Tasks',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFDEE4E2)),
          
          // Tasks List
          ...tasks.asMap().entries.map((entry) {
            final int idx = entry.key;
            final Map<String, dynamic> task = entry.value;
            final isLast = idx == tasks.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF151D1B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Color(0xFF7C7388),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    task['deadline'],
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: Color(0xFF7C7388),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF7C7388),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast) const Divider(height: 1, color: Color(0xFFF3FBF7)),
              ],
            );
          }),
        ],
      ),
    );
  }
}
