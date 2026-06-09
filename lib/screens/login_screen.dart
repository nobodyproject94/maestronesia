import 'package:flutter/material.dart';
import '../utils/preference_handler.dart';
import '../theme.dart';
import '../databases/database_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/interesting_logos.dart';

// =========================================================================
// LOGINSCREEN ADALAH STATEFULWIDGET YANG MENGELOLA ANTARMUKA DAN LOGIKA AUTENTIKASI (LOGIN)
// PENGGUNA SESUAI PERAN (ROLE) YANG DIPILIH: CLIENT ATAU EXPERT.
// =========================================================================
class LoginScreen extends StatefulWidget {
  final String role; // PERAN PENGGUNA (MISALNYA: 'CLIENT' ATAU 'EXPERT').
  final VoidCallback onBack; // CALLBACK KETIKA PENGGUNA MEMBATALKAN LOGIN DAN KEMBALI KE LAYAR SEBELUMNYA.
  final Function(String email, String name) onLoginSuccess; // CALLBACK SAAT LOGIN BERHASIL MEMVALIDASI AKUN.
  final VoidCallback onSignUpRedirect; // CALLBACK UNTUK MENGALIHKAN PENGGUNA KE LAYAR PENDAFTARAN (SIGNUP).

  const LoginScreen({
    super.key,
    required this.role,
    required this.onBack,
    required this.onLoginSuccess,
    required this.onSignUpRedirect,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // =========================================================================
  // GLOBALKEY DIGUNAKAN UNTUK MENGIDENTIFIKASI DAN MEMVALIDASI FORM INPUT SECARA UNIK.
  // =========================================================================
  final _formKey = GlobalKey<FormState>();
  // =========================================================================
  // KONTROLER UNTUK MEMBACA TEKS DARI INPUT EMAIL.
  // =========================================================================
  final _emailController = TextEditingController();
  // =========================================================================
  // KONTROLER UNTUK MEMBACA TEKS DARI INPUT PASSWORD.
  // =========================================================================
  final _passwordController = TextEditingController();
  // =========================================================================
  // STATE INDIKATOR UNTUK MELACAK PROSES LOADING SELAMA PROSES AUTENTIKASI BERLANGSUNG.
  // =========================================================================
  bool _isLoading = false;

  // =========================================================================
  // FUNGSI UNTUK MENANGANI AKSI PENEKANAN TOMBOL MASUK (LOGIN).
  // =========================================================================
  void _handleLogin() async {
    // =========================================================================
    // MEMERIKSA APAKAH SELURUH VALIDASI TEXTFORMFIELD DI DALAM FORM TELAH TERPENUHI.
    // =========================================================================
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // MENGUBAH STATE MENJADI LOADING.
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // =========================================================================
      // MELAKUKAN PENCARIAN KREDENSIAL PENGGUNA KE DATABASE SQLITE.
      // =========================================================================
      final user = await DatabaseHelper.instance.loginUser(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false; // MENGHENTIKAN STATUS LOADING SETELAH QUERY SELESAI.
        });

        if (user != null) {
          // =========================================================================
          // MEMASTIKAN PERAN (ROLE) AKUN YANG DITEMUKAN DI DATABASE COCOK DENGAN PERAN LAYAR LOGIN SAAT INI.
          // =========================================================================
          if (user['role'] == widget.role) {
            // =========================================================================
            // MENYIMPAN DATA SESI LOGIN SECARA LOKAL MENGGUNAKAN PREFERENCEHANDLER.
            // =========================================================================
            await PreferenceHandler.saveSession(
              email: user['email'],
              name: user['name'] ?? 'User',
              role: widget.role,
            );
            
            // =========================================================================
            // MEMICU CALLBACK SUKSES LOGIN UNTUK MEMPERBARUI STATE APLIKASI UTAMA.
            // =========================================================================
            widget.onLoginSuccess(user['email'], user['name'] ?? 'User');
          } else {
            // =========================================================================
            // MEMBERIKAN PESAN KESALAHAN JIKA AKUN TERDAFTAR DENGAN PERAN YANG BERBEDA.
            // =========================================================================
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  'This account is registered as a ${user['role']}.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
        } else {
          // =========================================================================
          // MEMBERIKAN PESAN KESALAHAN JIKA KOMBINASI EMAIL ATAU PASSWORD SALAH.
          // =========================================================================
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Invalid email or password.',
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // MAESTRONESIABACKGROUND MEMBUNGKUS SELURUH LAYAR DENGAN GRADIEN PREMIUM KHAS APLIKASI.
    // =========================================================================
    return MaestronesiaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent, // LATAR BELAKANG SCAFFOLD DIBUAT TRANSPARAN AGAR GRADIEN TERLIHAT.
        body: SafeArea(
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
                      // BOUNCINGSCROLLPHYSICS MEMBERIKAN EFEK MEMANTUL DAN MENCEGAH KEYBOARD MENUTUPI INPUT (OVERFLOW).
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
                            // JUDUL SAMBUTAN.
                            // =========================================================================
                            Text(
                              'Welcome Back',
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
                            // INFORMASI PERAN MASUK AKTIF.
                            // =========================================================================
                            Text(
                              'Log in as a ${widget.role} to continue.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 48),

                            // =========================================================================
                            // INPUT FORMULIR EMAIL.
                            // =========================================================================
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
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
                            // INPUT FORMULIR PASSWORD.
                            // =========================================================================
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true, // MENYEMBUNYIKAN KARAKTER TEKS PASSWORD.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
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
                            // TOMBOL SUBMIT / SIGN IN.
                            // =========================================================================
                            MaestronesiaButton(
                              onPressed: _isLoading ? null : _handleLogin,
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
                                          'Sign In',
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
                            // PEMBATAS DEKORATIF OR CONTINUE WITH.
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
                                    'OR CONTINUE WITH',
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
                            // SIMULASI TOMBOL LOGIN PIHAK KETIGA (GOOGLE & LINKEDIN).
                            // =========================================================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _handleLogin,
                                  child: const InterestingGoogleLogo(size: 28),
                                ),
                                const SizedBox(width: 24),
                                GestureDetector(
                                  onTap: _handleLogin,
                                  child: const InterestingLinkedInLogo(
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // =========================================================================
                // BAGIAN BAWAH: AJAKAN REGISTRASI JIKA BELUM PUNYA AKUN.
                // =========================================================================
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onSignUpRedirect,
                        child: const Text(
                          'Sign up',
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
