import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';
import 'package:task_proof/app_state.dart';

void main() {
  runApp(const MaterialApp(home: AddTaskScreen()));
}

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006B58)),
          onPressed: () {
            Navigator.pop(context);
          },
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
        centerTitle: false,
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 2),
      body: const AddTaskPageNeonTech(),
    );
  }
}

class AddTaskPageNeonTech extends StatefulWidget {
  const AddTaskPageNeonTech({super.key});

  @override
  State<AddTaskPageNeonTech> createState() => _AddTaskPageNeonTechState();
}

class _AddTaskPageNeonTechState extends State<AddTaskPageNeonTech> {
  // Controller untuk menangkap input teks dari user
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String? _selectedMember;
  DateTime? _selectedDate;

  // Daftar sampel anggota tim untuk dropdown input
  final List<String> _teamMembers = ['Ilham', 'Alex', 'Sarah', 'Dewi'];

  // Fungsi untuk menampilkan kalender pemilih tanggal (Deadline)
  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Format tanggal menjadi format yang sesuai dengan data proyek (cth: "Oct 30, 2026")
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  // Menampilkan SnackBar warning berestetika premium jika input belum lengkap
  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF141B2B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF8A8A)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menampilkan SnackBar kesuksesan dengan perpaduan warna tosca premium khas aplikasi
  void _showSuccessSnackBar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF006B58),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF13ECC8)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Task "$title" created successfully!',
                style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          right: 16,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul & Sub-judul halaman
            const Text(
              'Create New Task',
              style: TextStyle(
                color: Color(0xFF141B2B),
                fontSize: 28,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.29,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fill out the details below to assign a new task.',
              style: TextStyle(
                color: Color(0xFF4B4356),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),

            // FIELD 1: JUDUL TUGAS (Task Title)
            _buildFieldLabel('Task Title'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(
                color: Color(0xFF141B2B),
                fontSize: 16,
              ),
              decoration: _buildInputDecoration(
                'e.g. Update user authentication',
              ),
            ),
            const SizedBox(height: 24),

            // FIELD 2: DESKRIPSI TUGAS (Description)
            _buildFieldLabel('Description'),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines:
                  4, // Membuat input box menjadi lebih tinggi/multi-line
              style: const TextStyle(
                color: Color(0xFF141B2B),
                fontSize: 16,
              ),
              decoration: _buildInputDecoration(
                'Provide clear instructions and context...',
              ),
            ),
            const SizedBox(height: 24),

            // FIELD 3: DELEGASI ANGGOTA (Assign Member)
            _buildFieldLabel('Assign Member'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF7C7388)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMember,
                  hint: const Text(
                    'Select a team member',
                    style: TextStyle(color: Color(0xFF7C7388)),
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF7C7388),
                  ),
                  items: _teamMembers.map((String member) {
                    return DropdownMenuItem<String>(
                      value: member,
                      child: Text(
                        member,
                        style: const TextStyle(color: Color(0xFF141B2B)),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMember = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // FIELD 4: BATAS WAKTU (Deadline Picker)
            _buildFieldLabel('Deadline'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDeadline(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF7C7388)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'mm / dd / yyyy'
                          : '${_selectedDate!.month.toString().padLeft(2, '0')} / ${_selectedDate!.day.toString().padLeft(2, '0')} / ${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                            ? const Color(0xFF7C7388)
                            : const Color(0xFF141B2B),
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Color(0xFF7C7388),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // BUTTON UTAMA: TOMBOL SUBMIT (Create Task)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final desc = _descController.text.trim();

                  if (title.isEmpty) {
                    _showWarningSnackBar('Please enter a task title');
                    return;
                  }
                  if (_selectedMember == null) {
                    _showWarningSnackBar('Please assign a team member');
                    return;
                  }
                  if (_selectedDate == null) {
                    _showWarningSnackBar('Please pick a deadline date');
                    return;
                  }

                  // Build task data and add to global state
                  final taskData = {
                    'title': title,
                    'desc': desc,
                    'member': _selectedMember,
                    'deadline': _formatDate(_selectedDate!),
                  };
                  AppState.instance.tasks.add(taskData);

                  _showSuccessSnackBar(title);
                  Navigator.pop(context, taskData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13ECC8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: const Color(0x3313ECC8),
                ),
                child: const Text(
                  'Create Task',
                  style: TextStyle(
                    color: Color(0xFF141B2B),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat label di atas input field
  Widget _buildFieldLabel(String labelText) {
    return Text(
      labelText,
      style: const TextStyle(
        color: Color(0xFF141B2B),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
      ),
    );
  }

  // Helper untuk mendekorasi gaya kotak input (TextField Decoration)
  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF7C7388), fontSize: 16),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C7388), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF13ECC8), width: 2),
      ),
    );
  }
}
