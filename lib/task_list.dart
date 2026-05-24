import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/task_detail.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedFilter = 'All';

  // Dummy Task Data from overall projects
  final List<Map<String, dynamic>> _allTasks = [
    {
      'title': 'UI Login Screen',
      'project': 'Mobile App Redesign',
      'deadline': 'Oct 30, 2026',
      'status': 'In Progress',
      'assignee': 'Ilham',
      'description': 'Design and develop the User Interface for the Login screen, including input validation and Google/Apple SSO buttons.',
    },
    {
      'title': 'UI Registration Page',
      'project': 'Mobile App Redesign',
      'deadline': 'Oct 28, 2026',
      'status': 'Pending Review',
      'assignee': 'Alex',
      'description': 'Create the registration form layout and user input fields. Review validation for passwords and email formats.',
    },
    {
      'title': 'Wireframing Homepage',
      'project': 'Mobile App Redesign',
      'deadline': 'Sep 15, 2026',
      'status': 'Completed',
      'assignee': 'Sarah',
      'description': 'High-fidelity wireframes for the homepage detailing main dashboard layout, user profiles, and quick navigation links.',
    },
    {
      'title': 'User Persona Documentation',
      'project': 'Mobile App Redesign',
      'deadline': 'Sep 10, 2026',
      'status': 'Completed',
      'assignee': 'Dewi',
      'description': 'Define target user personas based on research data to guide product layout design and UX flows.',
    },
    {
      'title': 'Setup API Endpoint',
      'project': 'Web Portal Development',
      'deadline': 'Dec 01, 2026',
      'status': 'To Do',
      'assignee': 'Ilham',
      'description': 'Create robust REST API endpoints for user authentication, project details, and progress submissions.',
    },
    {
      'title': 'Push Notifications Setup',
      'project': 'Web Portal Development',
      'deadline': 'Dec 15, 2026',
      'status': 'To Do',
      'assignee': 'Alex',
      'description': 'Integrate Firebase Cloud Messaging (FCM) to deliver real-time notifications for task updates and approvals.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeDynamicTaskDeadlines();
  }

  void _initializeDynamicTaskDeadlines() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    if (_allTasks.length >= 6) {
      // Task 0: In Progress (e.g. 5 days from now)
      final date0 = now.add(const Duration(days: 5));
      _allTasks[0]['deadline'] = '${months[date0.month - 1]} ${date0.day}, ${date0.year}';

      // Task 1: Pending Review (e.g. 3 days from now)
      final date1 = now.add(const Duration(days: 3));
      _allTasks[1]['deadline'] = '${months[date1.month - 1]} ${date1.day}, ${date1.year}';

      // Task 2: Completed (e.g. 10 days ago)
      final date2 = now.subtract(const Duration(days: 10));
      _allTasks[2]['deadline'] = '${months[date2.month - 1]} ${date2.day}, ${date2.year}';

      // Task 3: Completed (e.g. 15 days ago)
      final date3 = now.subtract(const Duration(days: 15));
      _allTasks[3]['deadline'] = '${months[date3.month - 1]} ${date3.day}, ${date3.year}';

      // Task 4: To Do (e.g. 20 days from now)
      final date4 = now.add(const Duration(days: 20));
      _allTasks[4]['deadline'] = '${months[date4.month - 1]} ${date4.day}, ${date4.year}';

      // Task 5: To Do (e.g. 35 days from now)
      final date5 = now.add(const Duration(days: 35));
      _allTasks[5]['deadline'] = '${months[date5.month - 1]} ${date5.day}, ${date5.year}';
    }
  }

  List<Map<String, dynamic>> get _filteredTasks {
    if (selectedFilter == 'All') {
      return _allTasks;
    }
    return _allTasks.where((t) {
      final status = t['status'].toString().toUpperCase();
      if (selectedFilter == 'To Do') return status == 'TO DO';
      if (selectedFilter == 'In Progress') return status == 'IN PROGRESS';
      if (selectedFilter == 'Pending Review') return status == 'PENDING REVIEW';
      if (selectedFilter == 'Completed') return status == 'COMPLETED';
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _groupedFilteredProjects {
    final List<Map<String, dynamic>> tasks = _filteredTasks;
    final Map<String, List<Map<String, dynamic>>> groups = {};
    
    for (var task in tasks) {
      final projectName = task['project'] as String;
      if (!groups.containsKey(projectName)) {
        groups[projectName] = [];
      }
      groups[projectName]!.add(task);
    }
    
    return groups.entries.map((e) => {
      'projectName': e.key,
      'tasks': e.value,
    }).toList();
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );
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
