import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/project_detail_task.dart';
import 'package:task_proof/project_detail_timeline.dart';
import 'package:task_proof/project_list.dart';

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
      home: const ProjectDetailOverviewScreen(project: {
        'title': 'Test Project',
        'deadline': 'TBD',
        'status': 'Testing',
        'progress': 0.0,
        'progressText': '0%',
        'team': 'Test Team'
      }),
    );
  }
}

class ProjectDetailOverviewScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailOverviewScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006B58)),
          onPressed: () { Navigator.pushReplacement(context, FadeRoute(page: const ProjectListScreen())); },
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: CustomTabBar(project: project),
        ),
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ProjectCardHeader(project: project),
          const SizedBox(height: 16),
          const TeamCardSection(),
          const SizedBox(height: 16),
          ProgressCardSection(project: project),
          const SizedBox(height: 16),
          const JoinCodeCardSection(),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 1: TAB BAR ATAS ---
class CustomTabBar extends StatelessWidget {
  final Map<String, dynamic> project;

  const CustomTabBar({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _tabItem(context, 'Overview', isActive: true),
          _tabItem(context, 'Task', isActive: false),
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

//--- SUB-WIDGET 2: KARTU DETIL UTAMA ---
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F006B58),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCE8DF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Color(0xFF00201C),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.delete_outline, color: Color(0xFF006B58)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            project['title'] ?? 'Project Title',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project['description'] ?? 'Refreshing the UX for the Task Proof Android app. Focusing on performance improvements and modernizing the visual language to align with MD3 standards.',
            style: const TextStyle(
              color: Color(0xFF414947),
              height: 1.4,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          _tagBadge(Icons.calendar_today_outlined, 'Due ${project['deadline'] ?? ''}'),
          const SizedBox(height: 8),
          _tagBadge(Icons.flag_outlined, project['status'] ?? 'Active'),
        ],
      ),
    );
  }

  Widget _tagBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FBF7),
        border: Border.all(color: const Color(0xFFDEE4E2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF161D1B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF161D1B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 3: SECTION TEAM (AMBIL AVATAR AMAN) ---
class TeamCardSection extends StatelessWidget {
  const TeamCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F006B58),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menggunakan row bertumpuk untuk list avatar tanpa bikin overflow
              Row(
                children: [
                  _avatar('https://i.pravatar.cc/100?img=1'),
                  _avatar('https://i.pravatar.cc/100?img=2'),
                  _avatar('https://i.pravatar.cc/100?img=3'),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3FBF7),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFBFC9C5)),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: Color(0xFF006B58),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Manage Team',
                  style: TextStyle(
                    color: Color(0xFF006B58),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(url)),
    );
  }
}

//--- SUB-WIDGET 4: SECTION PROGRESS (LINGKARAN PERSENTASE) ---
class ProgressCardSection extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProgressCardSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F006B58),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF161D1B),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: project['progress'] as double? ?? 0.0,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFFE8EFEC),
                    color: const Color(0xFF006B58),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  project['progressText'] ?? '0%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF161D1B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '12 Completed',
                style: TextStyle(
                  color: Color(0xFF414947),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '4 Remaining',
                style: TextStyle(
                  color: Color(0xFF414947),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 5: JOIN CODE BANNER ---
class JoinCodeCardSection extends StatelessWidget {
  const JoinCodeCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF004D40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Join Code',
            style: TextStyle(
              color: Color(0xFF3CFFDF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Share this code with new members to grant them access.',
            style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TP-9821',
                  style: TextStyle(
                    color: Color(0xFF3CFFDF),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//--- SUB-WIDGET 6: NAVBAR BAWAH RESPONSIF ---
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFE8EFEC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14006B58),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.grid_view, 'Dashboard'),
          _navItem(Icons.folder, 'Projects', isActive: true),
          _navItem(Icons.task_alt, 'Tasks'),
          _navItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF006B58) : const Color(0xFF414947),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF006B58) : const Color(0xFF414947),
          ),
        ),
      ],
    );
  }
}
