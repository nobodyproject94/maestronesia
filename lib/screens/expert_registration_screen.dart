import 'package:flutter/material.dart';
import '../theme.dart';

// =========================================================================
// EXPERTREGISTRATIONSCREEN MENANGANI ALUR PENDAFTARAN USER BIASA MENJADI SEORANG EXPERT (AHLI).
// MENGGUNAKAN FORMULIR MULTI-LANGKAH (2 LANGKAH) YANG BERISI KATEGORI KEAHLIAN, RIWAYAT PENGALAMAN, DAN BUKTI BERKAS PENDUKUNG.
// =========================================================================
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
  int _step = 1; // STATE PENANDA LANGKAH PENDAFTARAN AKTIF (LANGKAH 1 ATAU 2).
  String _category = 'academic'; // KATEGORI KEAHLIAN DEFAULT ('ACADEMIC' ATAU 'NON-ACADEMIC').
  final _skillController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _journalController = TextEditingController();
  bool _isLoading = false; // STATUS PEMUATAN UNTUK MENSIMULASIKAN PROSES SUBMIT FORMULIR.

  // =========================================================================
  // STATE MAP UNTUK MELACAK STATUS UPLOAD SIMULASI BERKAS PORTOFOLIO PENDUKUNG.
  // =========================================================================
  final Map<String, bool> _uploadedDocs = {
    'CV': false,
    'Portfolio': false,
    'Degree': false,
    'Journal': false,
    'Certificates': false,
  };

  // =========================================================================
  // FUNGSI UNTUK MENANGANI PENGIRIMAN DATA REGISTRASI DENGAN SIMULASI JEDA WAKTU 2 DETIK.
  // =========================================================================
  void _handleSubmit() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onRegistrationSuccess(); // MEMANGGIL CALLBACK SUKSES REGISTRASI.
      }
    });
  }

  @override
  void dispose() {
    _skillController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaestronesiaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // TRANSPARAN AGAR GRADASI LATAR BELAKANG TETAP TERLIHAT.
        body: SafeArea(
          child: Column(
            children: [
              // =========================================================================
              // HEADER APLIKASI (JUDUL LAYAR DAN PROGRESS LANGKAH PENDAFTARAN)
              // =========================================================================
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
                    // =========================================================================
                    // GARIS PENANDA PROGRESS LANGKAH AKTIF
                    // =========================================================================
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

              // =========================================================================
              // AREA KONTEN DINAMIS BERDASARKAN LANGKAH AKTIF (STEP 1 ATAU STEP 2)
              // =========================================================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300), // ANIMASI TRANSISI ANTAR LANGKAH SELAMA 300MS.
                    child: _step == 1 ? _buildStep1() : _buildStep2(),
                  ),
                ),
              ),

              // =========================================================================
              // BAGIAN NAVIGASI BAWAH (TOMBOL KEMBALI & TOMBOL LANJUT/KIRIM)
              // =========================================================================
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    // =========================================================================
                    // TOMBOL KEMBALI HANYA DITAMPILKAN DI LANGKAH KEDUA.
                    // =========================================================================
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
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
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
                                      _step++; // LANJUT KE LANGKAH KEDUA.
                                    });
                                  } else {
                                    _handleSubmit(); // KIRIM FORMULIR PENDAFTARAN.
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkModeNotifier.value ? AppColors.gold : AppColors.gold.withValues(alpha: 0.15),
                            foregroundColor: isDarkModeNotifier.value ? Colors.black : AppColors.gold,
                            side: BorderSide(color: AppColors.gold, width: isDarkModeNotifier.value ? 0 : 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: isDarkModeNotifier.value ? 0 : 8.0,
                            shadowColor: isDarkModeNotifier.value
                                ? Colors.transparent
                                : AppColors.gold.withValues(alpha: 0.35),
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

  // =========================================================================
  // MEMBUAT INDIKATOR DOT/GARIS PENUNJUK LANGKAH AKTIF FORMULIR.
  // =========================================================================
  Widget _buildStepDot(int stepNum) {
    final active = stepNum <= _step;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: active ? AppColors.gold : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // =========================================================================
  // MERENDER FORMULIR LANGKAH 1 (PILIH KATEGORI, MASUKKAN SKILL UTAMA, DAN LAMA PENGALAMAN).
  // =========================================================================
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
              color: AppColors.textSecondary.withValues(alpha: 0.3),
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
              color: AppColors.textSecondary.withValues(alpha: 0.3),
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

        // =========================================================================
        // INPUT FORMULIR LINKEDIN PROFILE (OPSIONAL)
        // =========================================================================
        Text(
          'LinkedIn Profile (Optional)',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _linkedinController,
          keyboardType: TextInputType.url,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'e.g. https://linkedin.com/in/username',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
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

        // =========================================================================
        // INPUT FORMULIR AKADEMIK JOURNAL (HANYA UNTUK ROLE ACADEMIC & OPSIONAL)
        // =========================================================================
        if (_category == 'academic') ...[
          const SizedBox(height: 24),
          Text(
            'Academic Journal (Optional)',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _journalController,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. Analysis of Thermal Efficiency',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
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
      ],
    );
  }

  // =========================================================================
  // MEMBUAT TOMBOL PEMILIHAN KATEGORI KEAHLIAN (AKADEMIK / NON-AKADEMIK).
  // =========================================================================
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
            color: active ? AppColors.gold : Colors.white.withValues(alpha: 0.05),
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

  // =========================================================================
  // MERENDER FORMULIR LANGKAH 2 (MENGUNGGAH DOKUMEN BUKTI SEPERTI CV, PORTOFOLIO, SERTIFIKAT, DLL).
  // =========================================================================
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
        if (isAcademic) ...[
          const SizedBox(height: 12),
          _buildDocRow(
            'Journal',
            'Academic Journal (Optional)',
            Icons.menu_book_outlined,
          ),
          const SizedBox(height: 12),
          _buildDocRow(
            'Degree',
            'Higher Degree (Optional)',
            Icons.school_outlined,
          ),
        ] else ...[
          const SizedBox(height: 12),
          _buildDocRow(
            'Certificates',
            'Professional Certificates (Optional)',
            Icons.verified_outlined,
          ),
        ],
      ],
    );
  }

  // =========================================================================
  // MEMBUAT ITEM UPLOAD DOKUMEN KUSTOM DENGAN STATUS UPLOAD (SIMULASI TAP TOGGLES).
  // =========================================================================
  Widget _buildDocRow(String key, String title, IconData icon) {
    final uploaded = _uploadedDocs[key] ?? false;
    return GestureDetector(
      onTap: () {
        setState(() {
          _uploadedDocs[key] = !uploaded; // SIMULASI PERGANTIAN STATUS UPLOAD KETIKA BARIS DIKLIK.
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: uploaded
                ? AppColors.gold.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.05),
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
            // =========================================================================
            // IKON PENANDA CENTANG JIKA BERKAS TELAH DI-UPLOAD (DISIMULASIKAN).
            // =========================================================================
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
