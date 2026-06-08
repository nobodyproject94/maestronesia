import 'package:flutter/material.dart';
import '../theme.dart';

class ExpertRegistrationScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onRegistrationSuccess;

  const ExpertRegistrationScreen({
    super.key,
    required this.onBack,
    required this.onRegistrationSuccess,
  });

  @override
  State<ExpertRegistrationScreen> createState() =>
      _ExpertRegistrationScreenState();
}

class _ExpertRegistrationScreenState extends State<ExpertRegistrationScreen> {
  int _step = 1;
  String _category = 'academic'; // 'academic' or 'non-academic'
  final _skillController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = false;

  final Map<String, bool> _uploadedDocs = {
    'CV': false,
    'Portfolio': false,
    'Degree': false,
    'Journal': false,
  };

  void _handleSubmit() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onRegistrationSuccess();
      }
    });
  }

  @override
  void dispose() {
    _skillController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN UTAMA: Dibungkus MaestronesiaBackground agar gradasi biru muncul di Light Mode
    return MaestronesiaBackground(
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Dibuat transparan agar gradasi kelihatan
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expert Registration',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Step $_step of 2',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildStepDot(1),
                        const SizedBox(width: 8),
                        _buildStepDot(2),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _step == 1 ? _buildStep1() : _buildStep2(),
                  ),
                ),
              ),

              // Footer Navigation
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    if (_step > 1) ...[
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _step--;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child:
                                Text(
                                    'BACK',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_step < 2) {
                                    setState(() {
                                      _step++;
                                    });
                                  } else {
                                    _handleSubmit();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.12),
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.gold,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'NEXT STEP',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.chevron_right, size: 16),
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
    );
  }

  Widget _buildStepDot(int stepNum) {
    final active = stepNum <= _step;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: active ? AppColors.gold : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Professional Profile',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tell us about your professional expertise and years of practice.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 32),

        Text(
          'Expertise Category',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryButton('academic', 'Academic')),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryButton('non-academic', 'Non-Academic'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Text(
          'Main Skill',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _skillController,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: _category == 'academic'
                ? 'e.g. Informatics, Thermodynamics'
                : 'e.g. Graphic Design, Mechanics',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Years of Experience',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'e.g. 5',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String catValue, String label) {
    final active = _category == catValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _category = catValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: active ? AppColors.secondary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.gold : Colors.white.withOpacity(0.05),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppColors.gold : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    final isAcademic = _category == 'academic';
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Proven Documents',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isAcademic
              ? 'Please upload your CV, Portfolio, Journal, and Degree.'
              : 'Please upload your CV, Portfolio, and Certificates.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 32),
        _buildDocRow('CV', 'Curriculum Vitae', Icons.description_outlined),
        const SizedBox(height: 12),
        _buildDocRow(
          'Portfolio',
          'Portfolio Project',
          Icons.grid_view_outlined,
        ),
      ],
    );
  }

  Widget _buildDocRow(String key, String title, IconData icon) {
    final uploaded = _uploadedDocs[key] ?? false;
    return GestureDetector(
      onTap: () {
        setState(() {
          _uploadedDocs[key] = !uploaded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: uploaded
                ? AppColors.gold.withOpacity(0.3)
                : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.gold, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              uploaded ? Icons.check_circle : Icons.add,
              color: uploaded ? AppColors.gold : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
