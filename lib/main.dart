import 'package:flutter/material.dart';
import 'package:task_proof/onboarding_screen.dart';

import 'package:task_proof/app_state.dart';
import 'package:task_proof/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  runApp(const TaskProofApp());
}

class TaskProofApp extends StatelessWidget {
  const TaskProofApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF3FAFA), // Warna background lembut sesuai gambar
        body: const SplashScreenNeonTech(),
      ),
    );
  }
}


class SplashScreenNeonTech extends StatefulWidget {
  const SplashScreenNeonTech({super.key});

  @override
  State<SplashScreenNeonTech> createState() => _SplashScreenNeonTechState();
}

class _SplashScreenNeonTechState extends State<SplashScreenNeonTech> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final isRegistered = prefs.getBool('isRegistered') ?? false;

        if (isRegistered) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- BACKGROUND GRADIENT / GLOW EFFECTS ---
          // Efek neon cyan di bagian atas
          Positioned(
            top: -100,
            left: -50,
            right: -50,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF13ECC8).withValues(alpha: 0.25),
                    const Color(0xFF13ECC8).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          
          // Efek blur lembut di bagian tengah/bawah
          Positioned(
            bottom: 100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFDCE2F7).withValues(alpha: 0.4),
                    const Color(0xFFDCE2F7).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // --- CONTENT UTAMA (LOGO + TEKS + LOADING) ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo Area dengan Efek Glow Neon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF13ECC8).withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Bentuk dasar 'T' berwarna Toska/Cyan
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            // Garis Horizontal Atas T
                            Positioned(
                              top: 10,
                              left: 5,
                              child: Container(
                                width: 50,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E5BC),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            // Garis Vertikal Tiang T
                            Positioned(
                              top: 10,
                              left: 23,
                              child: Container(
                                width: 14,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E5BC),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            // Aksen Putih/Semi-transparan berbentuk lingkaran kecil di kanan bawah logo
                            Positioned(
                              bottom: 15,
                              right: 8,
                              child: Container(
                                width: 16,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),

              // 2. Teks Nama Aplikasi
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Inter', // Pastikan font ini ada di pubspec.yaml jika ingin identik
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Task ',
                      style: TextStyle(color: Color(0xFF141B2B)),
                    ),
                    TextSpan(
                      text: 'Proof',
                      style: TextStyle(color: Color(0xFF3A4454)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Tiga Titik Indikator (Three Dots Loading)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDot(),
                  const SizedBox(width: 8),
                  _buildDot(),
                  const SizedBox(width: 8),
                  _buildDot(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk membuat titik indicator
  Widget _buildDot() {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Color(0xFF00E5BC),
        shape: BoxShape.circle,
      ),
    );
  }
}


