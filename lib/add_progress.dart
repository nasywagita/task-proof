import 'package:flutter/material.dart';
import 'package:task_proof/shared_bottom_nav.dart';

class AddProgressScreen extends StatefulWidget {
  const AddProgressScreen({super.key});

  @override
  State<AddProgressScreen> createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitProgress() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'link': _linkController.text.trim(),
        'notes': _notesController.text.trim(),
        'time': 'Just now',
        'user': 'Me', // Dynamic name can be added later
      });
    }
  }

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
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=33'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF006B58)),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const SharedBottomNavBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Submit Progress',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161D1B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Provide the details of your completed work below to update the task status.',
                style: TextStyle(
                  color: Color(0xFF3F4946),
                  fontSize: 14,
                  height: 1.43,
                ),
              ),
              const SizedBox(height: 32),
              
              // Link Input
              const Text(
                'Proof Link (URL)',
                style: TextStyle(
                  color: Color(0xFF3F4946),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  filled: true,
                  fillColor: const Color(0xFFF3FBF7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFBFC9C5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFBFC9C5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF13ECC8)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              const Text(
                'Make sure the link can be accessed.',
                style: TextStyle(
                  color: Color(0xFF3F4946),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),

              // Notes Input
              const Text(
                'Progress Notes',
                style: TextStyle(
                  color: Color(0xFF3F4946),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe the work completed...',
                  filled: true,
                  fillColor: const Color(0xFFF3FBF7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFBFC9C5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFBFC9C5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF13ECC8)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe your progress';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13ECC8),
                  foregroundColor: const Color(0xFF00201A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submitProgress,
                child: const Text(
                  'Submit Progress',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
