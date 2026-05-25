import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/add_progress.dart';
import 'package:task_proof/task_list.dart';
import 'package:task_proof/app_state.dart';

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
  void initState() {
    super.initState();
    _initHistory();
  }

  void _initHistory() {
    final title = widget.task['title'] ?? 'Task';
    final assignee = widget.task['assignee'] ?? widget.task['member'] ?? 'Ilham';
    final status = widget.task['status'] ?? 'To Do';

    _progressHistory.clear();

    if (widget.task['progressHistory'] != null) {
      final List<dynamic> savedHistory = widget.task['progressHistory'];
      for (var item in savedHistory) {
        if (item is Map) {
          _progressHistory.add(Map<String, dynamic>.from(item));
        }
      }
      return;
    }

    final List<Map<String, dynamic>> initialHistory = [];
    if (status == 'Pending Review') {
      initialHistory.addAll([
        {
          'id': '1',
          'user': assignee,
          'time': '12 Mei, 14:30',
          'notes': '“UI $title selesai, mohon di review untuk layout mobile-nya.”',
          'link': 'https://www.figma.com/file/TaskProofPreview',
          'linkText': 'Figma Design Link',
          'status': 'Pending Review',
          'canApproveReject': true,
        },
        {
          'id': '2',
          'user': assignee,
          'time': '10 Mei, 09:15',
          'notes': 'Draft pertama untuk UI $title.',
          'link': 'https://www.figma.com/file/TaskProofDraft',
          'linkText': 'Figma Draft Link',
          'status': 'Rejected',
          'rejectionReason': 'Layout not responsive on smaller mobile screens (< 360px width).',
          'canApproveReject': false,
        }
      ]);
    } else if (status == 'Completed') {
      initialHistory.addAll([
        {
          'id': '1',
          'user': assignee,
          'time': '12 Mei, 16:00',
          'notes': '“UI $title selesai, semua revisi responsive layout mobile sudah diimplementasi.”',
          'link': 'https://www.figma.com/file/TaskProofFinal',
          'linkText': 'Figma Design Link',
          'status': 'Approved',
          'canApproveReject': false,
        },
        {
          'id': '2',
          'user': assignee,
          'time': '10 Mei, 09:15',
          'notes': 'Draft pertama untuk UI $title.',
          'link': 'https://www.figma.com/file/TaskProofDraft',
          'linkText': 'Figma Draft Link',
          'status': 'Rejected',
          'rejectionReason': 'Layout not responsive on smaller mobile screens (< 360px width).',
          'canApproveReject': false,
        }
      ]);
    } else if (status == 'In Progress') {
      initialHistory.addAll([
        {
          'id': '1',
          'user': assignee,
          'time': '10 Mei, 09:15',
          'notes': 'Memulai pengerjaan $title, sedang mengumpulkan aset design dan menentukan layout grid.',
          'status': 'Under Review',
          'canApproveReject': false,
        }
      ]);
    } else {
      initialHistory.addAll([
        {
          'id': '1',
          'user': assignee,
          'time': 'Just now',
          'notes': 'Task assigned to $assignee. Ready to start.',
          'status': 'To Do',
          'canApproveReject': false,
        }
      ]);
    }

    widget.task['progressHistory'] = initialHistory;
    _progressHistory.addAll(initialHistory);
  }

  void _handleApprove(Map<String, dynamic> item) {
    setState(() {
      item['status'] = 'Approved';
      item['canApproveReject'] = false;
      widget.task['status'] = 'Completed';

      if (widget.task['progressHistory'] != null) {
        final List<dynamic> savedHistory = widget.task['progressHistory'];
        for (var h in savedHistory) {
          if (h is Map && h['id'] == item['id']) {
            h['status'] = 'Approved';
            h['canApproveReject'] = false;
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF006B58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Color(0xFF13ECC8)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Task approved successfully! Status updated to Completed.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleReject(Map<String, dynamic> item) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reject Progress',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please specify the reason for rejecting this progress:',
                style: TextStyle(color: Color(0xFF3F4946), fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Layout not responsive, incomplete validation...',
                  hintStyle: const TextStyle(color: Color(0xFF7C7388)),
                  filled: true,
                  fillColor: const Color(0xFFF3FBF7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFBFC9C5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF13ECC8)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF3F4946))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final reason = controller.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a rejection reason')),
                  );
                  return;
                }
                Navigator.pop(context);
                 setState(() {
                  item['status'] = 'Rejected';
                  item['rejectionReason'] = reason;
                  item['canApproveReject'] = false;
                  widget.task['status'] = 'To Do';

                  if (widget.task['progressHistory'] != null) {
                    final List<dynamic> savedHistory = widget.task['progressHistory'];
                    for (var h in savedHistory) {
                      if (h is Map && h['id'] == item['id']) {
                        h['status'] = 'Rejected';
                        h['rejectionReason'] = reason;
                        h['canApproveReject'] = false;
                      }
                    }
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF141B2B),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    content: Row(
                      children: const [
                        Icon(Icons.cancel_outlined, color: Color(0xFFFF8A8A)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Progress rejected. Task status returned to To Do.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _handleOpenLink(String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.open_in_new, color: Color(0xFF006B58)),
              SizedBox(width: 8),
              Text(
                'Opening Attachment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161D1B),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Simulating opening the external link:',
                style: TextStyle(color: Color(0xFF3F4946), fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FBF7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFDAE5E1)),
                ),
                child: Text(
                  url,
                  style: const TextStyle(
                    color: Color(0xFF006B58),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFF3F4946))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13ECC8),
                foregroundColor: const Color(0xFF00382E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF006B58),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    content: Text('Navigating to $url...'),
                  ),
                );
              },
              child: const Text('Open URL'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = AppState.instance.projects.firstWhere(
      (p) {
        final taskList = p['taskList'] as List<dynamic>? ?? [];
        return taskList.any((t) => t['title'] == widget.task['title']);
      },
      orElse: () => <String, dynamic>{},
    );
    final userRole = ((project['creatorEmail'] ?? '').toString().toLowerCase().trim() == AppState.instance.userEmail.toLowerCase().trim()) ? 'creator' : 'anggota';

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
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x3313ECC8),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(0.5),
              decoration: const BoxDecoration(
                color: Color(0xFF13ECC8),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFEDF6F1),
                child: Icon(
                  Icons.person_rounded,
                  size: 16,
                  color: Color(0xFF006B58),
                ),
              ),
            ),
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
          const SizedBox(height: 24),
          const Text(
            'Progress History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 16),
          ProgressTimelineSection(
            history: _progressHistory,
            onApprove: _handleApprove,
            onReject: _handleReject,
            onOpenLink: _handleOpenLink,
            userRole: userRole,
          ),
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
              final newLog = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'user': AppState.instance.userName.isNotEmpty ? AppState.instance.userName : (widget.task['assignee'] ?? widget.task['member'] ?? 'Ilham'),
                'time': 'Just now',
                'notes': result['notes'] ?? '',
                'link': result['link'] ?? '',
                'linkText': (result['link'] != null && result['link'].toString().isNotEmpty) ? 'Attachment Link' : '',
                'status': 'Pending Review',
                'canApproveReject': true,
              };
              _progressHistory.insert(0, newLog);
              if (widget.task['progressHistory'] == null) {
                widget.task['progressHistory'] = [];
              }
              (widget.task['progressHistory'] as List).insert(0, newLog);
              widget.task['status'] = 'Pending Review';
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
              task['assignee'] ?? task['member'] ?? 'Unassigned',
              style: const TextStyle(
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
            task['description'] ?? task['desc'] ?? 'No description provided for this task. Please add more details if needed.',
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
  final Function(Map<String, dynamic>) onApprove;
  final Function(Map<String, dynamic>) onReject;
  final Function(String) onOpenLink;
  final String userRole;

  const ProgressTimelineSection({
    super.key,
    required this.history,
    required this.onApprove,
    required this.onReject,
    required this.onOpenLink,
    this.userRole = 'creator',
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'No progress logs yet. Add your first progress submission!',
            style: TextStyle(
              color: Color(0xFF3F4946),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
      );
    }

    return Column(
      children: history.map((item) {
        final status = item['status'] ?? 'Under Review';
        final isPending = status == 'Pending Review';
        final isRejected = status == 'Rejected';
        final isApproved = status == 'Approved';

        Color bg;
        Color text;
        if (isApproved) {
          bg = const Color(0xFFCCE8DF);
          text = const Color(0xFF006B58);
        } else if (isRejected) {
          bg = const Color(0xFFFFEBEB);
          text = const Color(0xFFFF5252);
        } else if (isPending) {
          bg = const Color(0x3313ECC8);
          text = const Color(0xFF00382E);
        } else {
          bg = const Color(0xFFDEE4E2);
          text = const Color(0xFF414947);
        }

        final showButtons = item['canApproveReject'] == true && isPending && userRole == 'creator';

        return _buildTimelineItem(
          isActive: isPending || isApproved,
          statusBadge: _statusBadge(status, bg, text),
          name: item['user'] ?? 'User',
          date: item['time'] ?? 'Just now',
          content: Text(
            item['notes'] ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isRejected ? const Color(0xFF3F4946) : const Color(0xFF161D1B),
            ),
          ),
          extraChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item['link'] != null && item['link'].toString().isNotEmpty)
                Padding(
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
                        label: Text(
                          item['linkText'] ?? 'Attachment Link',
                          style: const TextStyle(color: Color(0xFF006B58), fontSize: 12),
                        ),
                        onPressed: () => onOpenLink(item['link']),
                      ),
                    ],
                  ),
                ),
              if (isRejected && item['rejectionReason'] != null && item['rejectionReason'].toString().isNotEmpty)
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REASON FOR REJECTION',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F4946),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['rejectionReason'],
                        style: const TextStyle(fontSize: 13, color: Color(0xFF3F4946)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          bottomButtons: showButtons
              ? Row(
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
                        onPressed: () => onApprove(item),
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
                        onPressed: () => onReject(item),
                      ),
                    ),
                  ],
                )
              : null,
        );
      }).toList(),
    );
  }

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
                  if (extraChild != null) extraChild,
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
