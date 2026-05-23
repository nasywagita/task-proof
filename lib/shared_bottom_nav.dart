import 'package:flutter/material.dart';
import 'package:task_proof/dashboard.dart';
import 'package:task_proof/project_list.dart';
import 'package:task_proof/task_list.dart';
import 'package:task_proof/profile.dart';

class SharedBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const SharedBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF13ECC8),
        unselectedItemColor: const Color(0xFFCDC2DA),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontFamily: 'Inter', fontWeight: FontWeight.w600),
        elevation: 0,
        onTap: (index) {
          if (index == currentIndex) return;
          
          if (index == 0) {
            Navigator.pushReplacement(context, FadeRoute(page: const DashboardScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, FadeRoute(page: const ProjectListScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, FadeRoute(page: const TaskListScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, FadeRoute(page: const ProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Icon(Icons.dashboard_rounded, size: 24),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Icon(Icons.folder_rounded, size: 24),
            ),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Icon(Icons.check_circle_outline, size: 24),
            ),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Icon(Icons.person_outline, size: 24),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// RUTE TRANSISI CUSTOM 1: FADE (Perpindahan Tab / Pergantian Halaman Sejajar)
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 120), // Kecepatan tinggi (120ms) agar terasa sangat instan & snappy
          reverseTransitionDuration: const Duration(milliseconds: 100),
        );
}

// RUTE TRANSISI CUSTOM 2: SLIDE + FADE (Navigasi ke Halaman Detil / Form)
class SlideFadeRoute extends PageRouteBuilder {
  final Widget page;
  SlideFadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.02); // Pergeseran vertikal ultra-mikro (2% tinggi layar) agar animasi meluncur cepat
            const end = Offset.zero;
            const curve = Curves.decelerate; // Kurva cepat di awal dan melambat halus di akhir

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 180), // Durasi dipersingkat menjadi 180ms agar terasa ultra-responsif
          reverseTransitionDuration: const Duration(milliseconds: 150),
        );
}
