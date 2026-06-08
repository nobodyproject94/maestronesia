import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class ExpertRegistrationScreen extends StatefulWidget {
  const ExpertRegistrationScreen({super.key});

  @override
  State<ExpertRegistrationScreen> createState() => _ExpertRegistrationScreenState();
}

class _ExpertRegistrationScreenState extends State<ExpertRegistrationScreen> {
  // --- STATE VARIABLES (Sesuai Logika App.tsx) ---
  int currentStep = 1; // Mengontrol Step 1 atau Step 2
  String expertCategory = 'academic'; // 'academic' atau 'non-academic'
  bool isLoading = false;

  // Track upload status of documents
  final Map<String, bool> uploadedDocs = {
    'Curriculum Vitae': false,
    'Portfolio Project': false,
    'Official Academic Degree': false,
    'Journal Publication': false,
  };

  // --- CONTROLLERS FOR FORM ---
  final _formKey = GlobalKey<FormState>();
  final _skillCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _linkedinCtrl = TextEditingController();

  @override
  void dispose() {
    _skillCtrl.dispose();
    _experienceCtrl.dispose();
    _bioCtrl.dispose();
    _linkedinCtrl.dispose();
    super.dispose();
  }

  // --- SIMULASI SUBMIT (Sesuai Fungsi handleSubmit di App.tsx) ---
  void _submitData() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => isLoading = false);
        Navigator.pushNamedAndRemoveUntil(context, '/expert_dashboard', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaestronesiaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Kunci Warna Latar Utama
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER SECTION ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expert Registration",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Step $currentStep of 2",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Progress Indicator Garis Emas
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 32,
                          height: 4,
                          decoration: BoxDecoration(
                            color: currentStep == 2
                                ? AppColors.gold
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- BODY SECTION (Kondisi Step 1 & 2 Diletakkan di Sini) ---
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: currentStep == 1 ? _buildStepOne() : _buildStepTwo(),
                  ),
                ),

                // --- FOOTER ACTIONS SECTION ---
                _buildFooterActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // WIDGET STEP 1: Professional Profile
  // =========================================================================
  Widget _buildStepOne() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Professional Profile",
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Tell us about your professional expertise and years of practice.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 24),

          // Selector Kategori (Academic / Non-Academic)
          Text(
            "Expertise Category",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildCategoryButton("Academic", 'academic')),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCategoryButton("Non-Academic", 'non-academic'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Input Main Skill
          _buildTextField(
            controller: _skillCtrl,
            label: "Main Skill",
            hint: expertCategory == 'academic'
                ? "e.g. Informatics, Thermodynamics"
                : "e.g. Graphic Design, Public Speaking",
          ),
          const SizedBox(height: 16),

          // Input Years of Experience
          _buildTextField(
            controller: _experienceCtrl,
            label: "Years of Experience",
            hint: "e.g. 5",
            isNumber: true,
          ),
          const SizedBox(height: 16),

          // Input Bio
          _buildTextField(
            controller: _bioCtrl,
            label: "Bio / Tagline",
            hint: "A brief description for your profile...",
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // WIDGET STEP 2: Proven Documents
  // =========================================================================
  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Proven Documents",
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Please upload your CV, Portfolio, ${expertCategory == 'academic' ? 'Journal, and Academic Degree.' : 'and Certificates.'}",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 24),

        _buildLinkedInField(),
        const SizedBox(height: 24),

        // List Upload item
        _buildUploadCard("Curriculum Vitae", Icons.file_copy),
        _buildUploadCard("Portfolio Project", Icons.grid_view),
        _buildUploadCard("Official Academic Degree", Icons.workspace_premium),
        if (expertCategory == 'academic')
          _buildUploadCard("Journal Publication", Icons.menu_book),

        const SizedBox(height: 20),
        // Shield Warning Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.gpp_good, color: AppColors.gold, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Maestronesia independently verifies all documents for transparency. This typically takes 24-48 hours.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkedInField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "LinkedIn or Portfolio Link (Optional)",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _linkedinCtrl,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: "e.g. https://linkedin.com/in/username",
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.3)),
            filled: true,
            fillColor: AppColors.surface,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gold, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // HELPER COMPONENT WIDGETS (Untuk Rebalance Theme & Kerapihan Kode)
  // =========================================================================
  Widget _buildCategoryButton(String label, String value) {
    final isSelected = expertCategory == value;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? AppColors.gold.withOpacity(0.15)
            : Colors.white.withOpacity(0.02),
        side: BorderSide(
          color: isSelected ? AppColors.gold : Colors.white.withOpacity(0.08),
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        setState(() => expertCategory = value);
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.gold : AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.3)),
            filled: true,
            fillColor: AppColors.surface,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gold, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          validator: (val) => val!.isEmpty ? "Field ini wajib diisi" : null,
        ),
      ],
    );
  }

  Widget _buildUploadCard(String title, IconData icon) {
    final isUploaded = uploadedDocs[title] ?? false;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          uploadedDocs[title] = !isUploaded;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isUploaded
              ? Border.all(color: AppColors.gold, width: 2)
              : Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.gold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isUploaded ? "UPLOADED" : "TAP TO UPLOAD",
                          style: TextStyle(
                            color: isUploaded
                                ? AppColors.gold
                                : AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              isUploaded ? Icons.check_circle : Icons.add,
              color: isUploaded ? AppColors.gold : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.textSecondary,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                side: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                if (currentStep > 1) {
                  setState(() => currentStep = 1);
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "BACK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold.withOpacity(0.15),
                foregroundColor: AppColors.gold,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                side: const BorderSide(
                  color: AppColors.gold,
                  width: 2.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      if (currentStep == 1) {
                        if (_formKey.currentState!.validate()) {
                          setState(() => currentStep = 2);
                        }
                      } else {
                        _submitData();
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.gold,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      currentStep == 1 ? "NEXT STEP" : "SUBMIT FOR REVIEW",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
