import 'package:flutter/material.dart';
import 'package:task_proof/login.dart';
import 'package:task_proof/dashboard.dart';
import 'package:task_proof/app_state.dart';

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(
          0xFF141B2B,
        ), // Background luar gelap sesuai gambar preview
      ),
      home: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // State untuk melacak role yang dipilih (true = Creator, false = Member)
  bool isCreatorSelected = true;
  bool isAgreed = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Container(
                width: 390,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Garis hijau toska di bagian paling atas card
                    Container(
                      height: 5,
                      width: double.infinity,
                      color: const Color(0xFF13ECC8),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- HEADER (Back Button & Title) ---
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF0F172A),
                                ),
                                onPressed: () {},
                              ),
                              const Expanded(
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 48,
                              ), // Penyeimbang posisi title di tengah
                            ],
                          ),
                          const SizedBox(height: 24),

                          // --- MAIN TITLE & SUBTITLE ---
                          const Center(
                            child: Text(
                              'Join Task Proof\nGroup',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              'Modern task management for high-\nperformance teams',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // --- INPUT FIELD: FULL NAME ---
                          _buildInputLabel('Full Name'),
                          _buildTextField(
                            hint: 'John Doe',
                            icon: Icons.person_outline,
                            controller: _nameController,
                          ),
                          const SizedBox(height: 16),

                          // --- INPUT FIELD: EMAIL ---
                          _buildInputLabel('Email Address'),
                          _buildTextField(
                            hint: 'name@company.com',
                            icon: Icons.mail_outline,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 16),

                          // --- INPUT FIELD: PASSWORD ---
                          _buildInputLabel('Password'),
                          _buildTextField(
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 20),

                          // --- ROLE SELECTION (CREATOR & MEMBER) ---
                          _buildInputLabel('Select Your Role'),
                          Row(
                            children: [
                              // Tombol Role: Creator
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => isCreatorSelected = true),
                                  child: _buildRoleCard(
                                    label: 'Creator',
                                    icon: Icons.edit_note_rounded,
                                    isSelected: isCreatorSelected,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Tombol Role: Member
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => isCreatorSelected = false),
                                  child: _buildRoleCard(
                                    label: 'Member',
                                    icon: Icons.groups_outlined,
                                    isSelected: !isCreatorSelected,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- PRIVACY POLICY CHECKBOX ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isAgreed,
                                activeColor: const Color(0xFF13ECC8),
                                onChanged: (val) =>
                                    setState(() => isAgreed = val ?? false),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF475569),
                                      fontFamily: 'Inter',
                                    ),
                                    children: [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                          color: Color(0xFF13ECC8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Color(0xFF13ECC8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // --- BUTTON: REGISTER ---
                          ElevatedButton(
                            onPressed: () async {
                              final name = _nameController.text.trim();
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;

                              if (name.isEmpty || email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              await AppState.instance.setUserName(name);
                              await AppState.instance.setUserEmail(email);
                              await AppState.instance.setUserRole(isCreatorSelected ? 'Project Creator' : 'Project Member');
                              
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF13ECC8),
                              foregroundColor: const Color(0xFF0F172A),
                              minimumSize: const Size(double.infinity, 52),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- DIVIDER OR CONTINUE WITH ---
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade200),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF94A3B8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.grey.shade200),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // --- GOOGLE SIGN IN BUTTON ---
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.network(
                              'https://developers.google.com/identity/images/g-logo.png',
                              height: 20,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.g_mobiledata,
                                  size: 24,
                                  color: Colors.red,
                                );
                              },
                            ),
                            label: const Text('Continue with Google'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF334155),
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              elevation: 0,
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // --- FOOTER SIGN IN ---
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF475569),
                                    fontFamily: 'Inter',
                                  ),
                                  children: [
                                    TextSpan(text: 'Already have an account? '),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper membuat Label Input
  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  // Helper membuat Text Field Input
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF13ECC8), width: 1.5),
        ),
      ),
    );
  }

  // Helper membuat Seleksi Role Card kustom
  Widget _buildRoleCard({
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0x0C13ECC8) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF13ECC8) : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF13ECC8)
                : const Color(0xFF64748B),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
