import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/interesting_logos.dart';
import '../databases/database_helper.dart';

// =========================================================================
// SIGNUPSCREEN ADALAH STATEFULWIDGET YANG MEMPROSES PENDAFTARAN (REGISTRASI) AKUN PENGGUNA BARU
// BERDASARKAN PERAN (ROLE) YANG DIPILIH: CLIENT ATAU EXPERT.
// =========================================================================
class SignUpScreen extends StatefulWidget {
  final String role; // PERAN PENGGUNA ('CLIENT' ATAU 'EXPERT').
  final VoidCallback onBack; // CALLBACK UNTUK KEMBALI KE HALAMAN SEBELUMNYA.
  final Function(String email, String name) onSignUpSuccess; // CALLBACK KETIKA REGISTRASI BERHASIL DIVALIDASI.
  final VoidCallback onLoginRedirect; // CALLBACK UNTUK MENGALIHKAN PENGGUNA KE LAYAR LOGIN.

  const SignUpScreen({
    super.key,
    required this.role,
    required this.onBack,
    required this.onSignUpSuccess,
    required this.onLoginRedirect,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // =========================================================================
  // GLOBALKEY UNTUK VALIDASI STATUS SELURUH KOLOM INPUT DI DALAM FORM.
  // =========================================================================
  final _formKey = GlobalKey<FormState>();
  // =========================================================================
  // KONTROLER UNTUK MEMBACA INPUT TEKS NAMA LENGKAP.
  // =========================================================================
  final _nameController = TextEditingController();
  // =========================================================================
  // KONTROLER UNTUK MEMBACA INPUT TEKS ALAMAT EMAIL.
  // =========================================================================
  final _emailController = TextEditingController();
  // =========================================================================
  // KONTROLER UNTUK MEMBACA INPUT TEKS PASSWORD.
  // =========================================================================
  final _passwordController = TextEditingController();
  // =========================================================================
  // STATE PELACAK PROSES LOADING PENDAFTARAN ASINKRON.
  // =========================================================================
  bool _isLoading = false;

  // =========================================================================
  // FUNGSI UNTUK MENANGANI AKSI PENDAFTARAN AKUN BARU.
  // =========================================================================
  void _handleSignUp() async {
    // =========================================================================
    // MEMASTIKAN DATA INPUT DI SELURUH TEXTFORMFIELD LOLOS VALIDASI.
    // =========================================================================
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // MENGUBAH STATE KE LOADING.
      });

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // =========================================================================
      // MENYIMPAN DATA PENGGUNA BARU KE DATABASE SQLITE.
      // =========================================================================
      final result = await DatabaseHelper.instance.registerUser({
        'name': name,
        'email': email,
        'password': password,
        'role': widget.role,
      });

      if (mounted) {
        setState(() {
          _isLoading = false; // MEMATIKAN STATUS LOADING SETELAH PROSES SIMPAN SELESAI.
        });

        if (result != null) {
          // =========================================================================
          // MENYIMPAN INFORMASI SESI SECARA LOKAL JIKA PENDAFTARAN BERHASIL.
          // =========================================================================
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_email', email);
          await prefs.setString('session_name', name);
          await prefs.setString('session_role', widget.role);
          
          // =========================================================================
          // MEMICU CALLBACK SUKSES REGISTRASI UNTUK MEMPERBARUI STATE APLIKASI UTAMA.
          // =========================================================================
          widget.onSignUpSuccess(email, name);
        } else {
          // =========================================================================
          // MEMBERIKAN PERINGATAN SNACKBAR JIKA ALAMAT EMAIL SUDAH TERDAFTAR SEBELUMNYA.
          // =========================================================================
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                'Email already registered. Try logging in.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    // =========================================================================
    // MENGHAPUS KONTROLER DARI MEMORI UNTUK MENCEGAH KEBOCORAN RESOURCE.
    // =========================================================================
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // TRANSPARAN AGAR GRADIEN BACKGROUND DI BAWAHNYA TERLIHAT.
      body: MaestronesiaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================================
                // TOMBOL KEMBALI DI POJOK KIRI ATAS.
                // =========================================================================
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: IconButton(
                    onPressed: widget.onBack,
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textSecondary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.white.withOpacity(0.05)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      // =========================================================================
                      // BOUNCINGSCROLLPHYSICS UNTUK EFEK MEMANTUL ELASTIS KHAS IOS & MENCEGAH OVERFLOW SAAT KEYBOARD MUNCUL.
                      // =========================================================================
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // =========================================================================
                            // JUDUL PEMBUATAN AKUN.
                            // =========================================================================
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // =========================================================================
                            // RICHTEXT UNTUK MENYOROTI NAMA PERAN (ROLE) DENGAN WARNA EMAS.
                            // =========================================================================
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  const TextSpan(text: 'Sign up as a '),
                                  TextSpan(
                                    text: widget.role,
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: ' to get started.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),

                            // =========================================================================
                            // INPUT FORMULIR NAMA LENGKAP.
                            // =========================================================================
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: AppColors.textSecondary,
                                ),
                                hintText: 'FULL NAME',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.3),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // =========================================================================
                            // INPUT FORMULIR EMAIL (DILENGKAPI VALIDASI POLA REGEXP).
                            // =========================================================================
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: AppColors.textSecondary,
                                ),
                                hintText: 'EMAIL ADDRESS',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.3),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // =========================================================================
                            // INPUT FORMULIR PASSWORD (DILENGKAPI VALIDASI MINIMAL PANJANG KARAKTER).
                            // =========================================================================
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.shield_outlined,
                                  color: AppColors.textSecondary,
                                ),
                                hintText: 'PASSWORD',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.3),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // =========================================================================
                            // TOMBOL SUBMIT PEMBUATAN AKUN.
                            // =========================================================================
                            MaestronesiaButton(
                              onPressed: _isLoading ? null : _handleSignUp,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.gold,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.chevron_right, size: 20),
                                      ],
                                    ),
                            ),
                            const SizedBox(height: 32),

                            // =========================================================================
                            // PEMBATAS DEKORATIF PENDAFTARAN INSTAN.
                            // =========================================================================
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    'FAST TRACK REGISTRATION',
                                    style: TextStyle(
                                      color: AppColors.textSecondary.withOpacity(0.6),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // =========================================================================
                            // SIMULASI TOMBOL REGISTRASI PIHAK KETIGA (GOOGLE & LINKEDIN).
                            // =========================================================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _handleSignUp,
                                  child: const InterestingGoogleLogo(size: 28),
                                ),
                                const SizedBox(width: 24),
                                GestureDetector(
                                  onTap: _handleSignUp,
                                  child: const InterestingLinkedInLogo(
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // =========================================================================
                            // KUTIPAN MOTIVASI BELAJAR.
                            // =========================================================================
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                '"The beautiful thing about learning is that no one can take it away from you."',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // =========================================================================
                // BAGIAN BAWAH: AJAKAN MASUK (LOGIN) JIKA SUDAH MEMILIKI AKUN.
                // =========================================================================
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onLoginRedirect,
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
    );
  }
}
