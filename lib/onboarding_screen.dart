import 'package:flutter/material.dart';
import 'package:task_proof/login.dart';
import 'package:task_proof/register.dart';

void main() {
  runApp(const TaskProofApp());
}

class TaskProofApp extends StatelessWidget {
  const TaskProofApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8), // Background abu-abu sangat muda sesuai mockup
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- HEADER BAR (Title & Skip) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer penyeimbang tombol skip di kanan
                  const Text(
                    'Task Proof Group',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(flex: 2),

              // --- ILUSTRASI KOTAK KOLABORASI (CARD) ---
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x3313ECC8), // Soft toska atas
                      Color(0x0C13ECC8), // Transparan toska bawah
                    ],
                  ),
                ),
                child: Center(
                  child: CustomCollaborationIcon(), // Menggambar icon user group kustom di bawah
                ),
              ),

              const Spacer(flex: 2),

              // --- TEKS UTAMA (JUDUL & DESKRIPSI) ---
              const Text(
                'Collaboration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                key: ValueKey('desc'),
                child: Text(
                  'Work seamlessly with your team in real-time. Share tasks and monitor progress together.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // --- INDIKATOR HALAMAN (PAGE INDICATOR) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13ECC8),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // --- BUTTON & FOOTER TEXT ---
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13ECC8),
                  foregroundColor: const Color(0xFF0F172A),
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Color(0xFF13ECC8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET UNTUK MENGGAMBAR ICON COLLABORATION SEPERTI DI FIGMA ---
class CustomCollaborationIcon extends StatelessWidget {
  const CustomCollaborationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // User Bagian Belakang (Bayangan Kanan)
          Positioned(
            right: 15,
            top: 15,
            child: Opacity(
              opacity: 0.6,
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E5BC),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 52,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E5BC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // User Bagian Depan (Utama)
          Positioned(
            left: 15,
            bottom: 10,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5BC),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2F9F5), width: 3),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 64,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5BC),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border.all(color: const Color(0xFFE2F9F5), width: 3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


