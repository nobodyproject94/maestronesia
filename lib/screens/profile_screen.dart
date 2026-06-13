import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../widgets/main_layout.dart';
import '../widgets/custom_button.dart';
import '../databases/preference_handler.dart';

// =========================================================================
// PROFILESCREEN ADALAH STATEFULWIDGET (WIDGET YANG BISA BERUBAH DATA/TAMPILANNYA).
// Halaman ini bertugas menampilkan data profil pengguna serta menyediakan menu
// aksi untuk mengedit, menambah, dan menghapus data profil tersebut secara lokal.
// =========================================================================
class ProfileScreen extends StatefulWidget {
  final String role; // Menyimpan peran pengguna saat ini ('client' atau 'expert').
  final String email; // Menyimpan email pengguna yang masuk pertama kali.
  final String name; // Menyimpan nama lengkap pengguna.
  final ValueChanged<String> onTabChanged; // Callback (fungsi pemicu) untuk navigasi perpindahan tab menu utama.
  final VoidCallback onSignOut; // Callback untuk menangani proses keluar (log out) akun.
  final Function(String name, String email)? onProfileUpdated; // Callback untuk memberi tahu halaman utama (main.dart) jika nama atau email diubah secara dinamis.

  const ProfileScreen({
    super.key,
    required this.role,
    required this.email,
    required this.name,
    required this.onTabChanged,
    required this.onSignOut,
    this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // =========================================================================
  // STATE/VARIABEL LOKAL UNTUK MENGATUR STATE TOGGLE ONLINE PAKAR (EXPERT).
  // =========================================================================
  bool _isOnline = true;

  // =========================================================================
  // STATE/VARIABEL LOKAL UNTUK FITUR CRUD PROFIL (CREATE, READ, UPDATE, DELETE).
  // Nilai variabel ini akan ditampilkan langsung di UI dan disimpan di memori HP.
  // =========================================================================
  bool _hasProfile = true; // Menandakan apakah data profil sedang ada (True) atau sudah dihapus (False).
  String _profileName = ''; // Menyimpan nama profil aktif.
  String _profileEmail = ''; // Menyimpan email profil aktif.
  String _profileBio = ''; // Menyimpan deskripsi singkat (Bio) profil aktif.
  String _profilePhone = ''; // Menyimpan nomor telepon profil aktif.

  @override
  void initState() {
    super.initState();
    // initState() adalah fungsi daur hidup (lifecycle) yang dipanggil pertama kali
    // saat halaman profil ini dirender. Di sini, kita menginisiasi nama dan email 
    // dari parameter widget pembungkusnya, lalu memuat sisa data dari SharedPreferences.
    _profileName = widget.name;
    _profileEmail = widget.email;
    _loadProfileData();
  }

  // =========================================================================
  // READ (R) - MEMUAT DATA PROFIL LOKAL DARI SHAREDPREFERENCES.
  // Kita menggunakan kata kunci 'async' dan 'await' karena proses membaca data
  // dari memori HP membutuhkan waktu (proses asinkronus).
  // =========================================================================
  Future<void> _loadProfileData() async {
    // Membuka database penyimpanan lokal SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    
    // setState() memberi tahu Flutter bahwa nilai state berubah dan UI harus digambar ulang.
    setState(() {
      // Membaca data boolean & string. Simbol '??' memberikan nilai default jika kunci data kosong/null.
      _hasProfile = prefs.getBool('profile_exists') ?? true;
      _profileBio =
          prefs.getString('profile_bio') ??
          'Aspiring engineer learning Flutter CRUD.';
      _profilePhone = prefs.getString('profile_phone') ?? '+62 812-3456-7890';
    });
  }

  // =========================================================================
  // CREATE/UPDATE (C/U) - MENYIMPAN PERUBAHAN DATA PROFIL KE SHAREDPREFERENCES.
  // Menyimpan data terbaru ke memori lokal HP agar data tidak hilang saat aplikasi ditutup.
  // =========================================================================
  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    // Menyimpan data boolean & string dengan kata kunci (key) tertentu.
    await prefs.setBool('profile_exists', _hasProfile);
    await prefs.setString('profile_bio', _profileBio);
    await prefs.setString('profile_phone', _profilePhone);
    
    // Menyimpan sesi global nama, email dan peran pengguna agar sinkron di seluruh aplikasi.
    await PreferenceHandler.saveSession(
      email: _profileEmail,
      name: _profileName,
      role: widget.role,
    );
  }

  // =========================================================================
  // UPDATE (U) - POP-UP DIALOG UNTUK MEMPERBARUI/MENGEDIT DATA PROFIL.
  // =========================================================================
  void _showEditProfileDialog() {
    // TextEditingController bertugas mengambil dan mengontrol teks masukan pengguna di TextField.
    // Kita berikan nilai awal (text: ...) sesuai data state agar pengguna tinggal mengedit teks lama.
    final nameController = TextEditingController(text: _profileName);
    final emailController = TextEditingController(text: _profileEmail);
    final bioController = TextEditingController(text: _profileBio);
    final phoneController = TextEditingController(text: _profilePhone);
    final isDark = isDarkModeNotifier.value; // Membaca tema aktif (Dark/Light) dari ValueNotifier global.

    showDialog(
      context: context,
      builder: (context) {
        // BackdropFilter memberikan efek kaca buram (blur) estetik pada latar belakang pop-up.
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            // Warna latar dialog berubah secara dinamis menyesuaikan tema gelap atau terang.
            backgroundColor: AppColors.dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: AppColors.dividerColor),
            ),
            title: Text(
              'Update Profile (U)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              // SingleChildScrollView mencegah layout overflow saat keyboard handphone muncul di layar.
              child: Column(
                mainAxisSize: MainAxisSize.min, // Dialog tingginya menyesuaikan konten di dalamnya.
                children: [
                  _buildDialogTextField(nameController, 'Name'),
                  const SizedBox(height: 12),
                  _buildDialogTextField(emailController, 'Email'),
                  const SizedBox(height: 12),
                  _buildDialogTextField(bioController, 'Bio', maxLines: 3),
                  const SizedBox(height: 12),
                  _buildDialogTextField(phoneController, 'Phone'),
                ],
              ),
            ),
            actions: [
              // Tombol Batal (Cancel)
              TextButton(
                onPressed: () => Navigator.pop(context), // Menutup dialog modal saat ini.
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              // Tombol Simpan (Save)
              ElevatedButton(
                onPressed: () {
                  // Memperbarui data state lokal dengan teks baru yang diketik di TextField.
                  setState(() {
                    _profileName = nameController.text;
                    _profileEmail = emailController.text;
                    _profileBio = bioController.text;
                    _profilePhone = phoneController.text;
                  });
                  _saveProfileData(); // Tulis data baru ke memori lokal HP.
                  
                  // Memicu callback utama di main.dart untuk memperbarui nama & email di Drawer/Header.
                  if (widget.onProfileUpdated != null) {
                    widget.onProfileUpdated!(_profileName, _profileEmail);
                  }
                  Navigator.pop(context); // Tutup dialog.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.gold : AppColors.gold.withValues(alpha: 0.15),
                  foregroundColor: isDark ? Colors.black : AppColors.gold,
                  side: BorderSide(color: AppColors.gold, width: isDark ? 0 : 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: isDark ? 0 : 8.0,
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // CREATE (C) - POP-UP DIALOG UNTUK MEMBUAT PROFIL BARU KETIKA DATA KOSONG.
  // =========================================================================
  void _showCreateProfileDialog() {
    // Controller baru yang masih kosong karena bertujuan membuat data baru.
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final bioController = TextEditingController();
    final phoneController = TextEditingController();
    final isDark = isDarkModeNotifier.value;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: AppColors.dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: AppColors.dividerColor),
            ),
            title: Text(
              'Create Profile (C)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogTextField(nameController, 'Name'),
                  const SizedBox(height: 12),
                  _buildDialogTextField(emailController, 'Email'),
                  const SizedBox(height: 12),
                  _buildDialogTextField(bioController, 'Bio', maxLines: 3),
                  const SizedBox(height: 12),
                  _buildDialogTextField(phoneController, 'Phone'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _profileName = nameController.text;
                    _profileEmail = emailController.text;
                    _profileBio = bioController.text;
                    _profilePhone = phoneController.text;
                    _hasProfile = true; // Tandai bahwa profil sekarang sudah ada (True).
                  });
                  _saveProfileData(); // Simpan ke penyimpanan lokal HP.
                  
                  if (widget.onProfileUpdated != null) {
                    widget.onProfileUpdated!(_profileName, _profileEmail);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.gold : AppColors.gold.withValues(alpha: 0.15),
                  foregroundColor: isDark ? Colors.black : AppColors.gold,
                  side: BorderSide(color: AppColors.gold, width: isDark ? 0 : 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: isDark ? 0 : 8.0,
                  shadowColor: isDark ? Colors.transparent : AppColors.gold.withValues(alpha: 0.35),
                ),
                child: const Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // DELETE (D) - DIALOG KONFIRMASI UNTUK MENGHAPUS DATA PROFIL PENGGUNA.
  // =========================================================================
  void _deleteProfile() {
    final isDark = isDarkModeNotifier.value;
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: AppColors.dialogBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: AppColors.dividerColor),
            ),
            title: Text(
              'Delete Profile Data (D)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to clear/delete your profile details?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Mengosongkan data state profil lokal dan menonaktifkan status keberadaan profil.
                  setState(() {
                    _profileName = '';
                    _profileEmail = '';
                    _profileBio = '';
                    _profilePhone = '';
                    _hasProfile = false; // Tandai data profil telah dihapus (False).
                  });
                  _saveProfileData(); // Simpan status kosong ini ke memori penyimpanan lokal HP.
                  
                  if (widget.onProfileUpdated != null) {
                    widget.onProfileUpdated!('', ''); // Kosongkan nama & email di Header/Sidebar.
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.redAccent : Colors.redAccent.withValues(alpha: 0.15),
                  foregroundColor: isDark ? Colors.white : Colors.redAccent,
                  side: BorderSide(color: Colors.redAccent, width: isDark ? 0 : 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: isDark ? 0 : 8.0,
                  shadowColor: isDark ? Colors.transparent : Colors.redAccent.withValues(alpha: 0.35),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MERENDER FIELD INPUT DI POP-UP DIALOG SECARA INSTAN.
  // Mengurangi redundansi penulisan berulang dekorasi TextField.
  // =========================================================================
  Widget _buildDialogTextField(
    TextEditingController controller, // Menghubungkan masukan TextField dengan controller.
    String label, {                  // Label pemandu inputan.
    int maxLines = 1,                 // Menentukan jumlah baris maksimum field.
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.inputText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        // Gaya garis bawah ketika TextField tidak aktif/sedang tidak difokuskan.
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.hintText),
        ),
        // Gaya garis bawah ketika TextField aktif/sedang difokuskan pengguna.
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // DIBUNGKUS MAINLAYOUT AGAR BOTTOM NAVIGATION BAR TERPADU TETAP AKTIF TERLIHAT.
    // =========================================================================
    return MainLayout(
      activeTab: 'profile',
      onTabChanged: widget.onTabChanged,
      onSignOut: widget.onSignOut,
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // TRANSPARAN AGAR GRADIEN BACKGROUND DI BAWAHNYA TERLIHAT.
        body: SingleChildScrollView(
          // =========================================================================
          // BOUNCINGSCROLLPHYSICS MEMBERIKAN EFEK MEMANTUL (ELASTIC BOUNCE) KHAS IOS SAAT SCROLL.
          // =========================================================================
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          // =========================================================================
          // PENTING: PADDING BOTTOM 120.0 DISEMATKAN AGAR TOMBOL "SIGN OUT" PALING BAWAH TIDAK TERHALANG OLEH BOTTOM NAVIGATION BAR.
          // =========================================================================
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: 120.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================================
              // 1. KARTU PROFIL UTAMA (MAIN PROFILE CARD)
              // =========================================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    // =========================================================================
                    // STACK FOTO PROFIL BUNDAR DENGAN IKON RODA GIGI PENGATURAN DI KANAN BAWAH.
                    // =========================================================================
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 4),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // =========================================================================
                    // NAMA PENGGUNA.
                    // =========================================================================
                    Text(
                      _hasProfile ? _profileName : 'No Profile',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // =========================================================================
                    // EMAIL PENGGUNA.
                    // =========================================================================
                    Text(
                      _hasProfile ? _profileEmail : 'No Email',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // =========================================================================
                    // LABEL DESKRIPSI PERAN (ROLE).
                    // =========================================================================
                    Text(
                      widget.role == 'expert'
                          ? 'Mechanical Engineering Expert'
                          : 'Mechanical Engineering Client',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    if (_hasProfile) ...[
                      if (_profileBio.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _profileBio,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                      if (_profilePhone.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _profilePhone,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 16),
                    // =========================================================================
                    // TANDA BADGE LEVEL & TIER PENGGUNA.
                    // =========================================================================
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 6,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: AppColors.gold.withOpacity(0.1),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       child: const Text(
                    //         'LEVEL 4',
                    //         style: TextStyle(
                    //           color: AppColors.gold,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //           letterSpacing: 1.0,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 6,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: Colors.white.withOpacity(0.05),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //       child: const Text(
                    //         'CLIENT TIER',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //           letterSpacing: 1.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 24),
                    // =========================================================================
                    // TOMBOL AKSI CRUD PROFIL (CREATE/EDIT)
                    // Menggunakan operator ternary (? :) untuk menampilkan tombol yang berbeda:
                    // Jika profil ada (_hasProfile = True) -> Tampilkan tombol "Edit Profile" (Outlined).
                    // Jika profil kosong (_hasProfile = False) -> Tampilkan tombol "Create Profile" (Solid Gold).
                    // =========================================================================
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: MaestronesiaButton(
                        onPressed: _hasProfile
                            ? () {
                                // showModalBottomSheet adalah fungsi Flutter untuk memunculkan lembar opsi dari bawah layar.
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent, // Transparan agar efek kaca blur di bawahnya terlihat.
                                  barrierColor: Colors.black54, // Warna hitam redup di luar area BottomSheet.
                                  builder: (context) {
                                    // Efek blur kaca di belakang BottomSheet.
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // Warna latar dinamis disesuaikan tema aktif.
                                          color: AppColors.dialogBg,
                                          // Hanya sudut atas kiri dan kanan yang dibulatkan (desain laci BottomSheet).
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(24),
                                              ),
                                          border: Border(
                                            top: BorderSide(
                                              color: AppColors.dividerColor,
                                            ),
                                          ),
                                        ),
                                        child: SafeArea(
                                          // SafeArea memastikan item tidak terpotong notch/bagian bawah layar HP poni.
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min, // Tinggi BottomSheet menyesuaikan jumlah anak kolom.
                                            children: [
                                              // Opsi 1: Edit Details (U - Update)
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.edit,
                                                  color: AppColors.gold,
                                                ),
                                                title: Text(
                                                  'Edit Details',
                                                  style: TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context); // Tutup BottomSheet terlebih dahulu.
                                                  _showEditProfileDialog(); // Lalu buka dialog edit profil.
                                                },
                                              ),
                                              Divider(
                                                color: AppColors.dividerColor,
                                                height: 1,
                                              ),
                                              // Opsi 2: Delete Profile (D - Delete)
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                                title: const Text(
                                                  'Delete Profile',
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context); // Tutup BottomSheet terlebih dahulu.
                                                  _deleteProfile(); // Lalu buka dialog konfirmasi hapus profil.
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            : _showCreateProfileDialog, // Langsung buka dialog pembuatan profil baru (C - Create).
                        borderRadius: 16,
                        child: Text(_hasProfile ? 'EDIT PROFILE' : 'CREATE PROFILE'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // =========================================================================
              // 2. STATUS KEBERADAAN PAKAR (AVAILABILITY TOGGLE) - HANYA MUNCUL JIKA ROLE = 'EXPERT'
              // =========================================================================
              if (widget.role == 'expert') ...[
                Text(
                  'EXPERT STATUS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isOnline
                          ? AppColors.gold.withValues(alpha: 0.3)
                          : AppColors.dividerColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      // =========================================================================
                      // INDIKATOR BULAT HIJAU/ABU-ABU MELAMBANGKAN ONLINE/OFFLINE.
                      // =========================================================================
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _isOnline
                              ? AppColors.gold
                              : AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOnline
                                  ? 'Accepting Requests'
                                  : 'Currently Offline',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isOnline
                                  ? 'Available for live sessions'
                                  : 'Go online to receive requests',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // =========================================================================
                      // SWITCH TOGGLE UNTUK MENGAKTIFKAN/NONAKTIFKAN STATUS ONLINE PAKAR.
                      // =========================================================================
                      Switch(
                        value: _isOnline,
                        onChanged: (val) {
                          setState(() {
                            _isOnline = val;
                          });
                        },
                        activeThumbColor: AppColors.gold,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // =========================================================================
              // 3. MENU AKUN (ACCOUNT SETTINGS SECTION)
              // =========================================================================
              Text(
                'ACCOUNT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.dividerColor),
                ),
                child: Column(
                  children: [
                    _buildAccountItem(
                      icon: Icons.person_outline,
                      title: 'Settings',
                      subtitle: 'Personal info, login, security',
                      onTap: _showEditProfileDialog,
                    ),
                    Divider(color: AppColors.dividerColor, height: 1),
                    _buildAccountItem(
                      icon: Icons.credit_card,
                      title: 'Payments',
                      subtitle: 'Cards, billing history',
                      onTap: () => widget.onTabChanged('billing'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // =========================================================================
              // 4. TOMBOL KELUAR (SIGN OUT) WARNA MERAH MENCOLOK
              // =========================================================================
              SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: widget.onSignOut,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // FUNGSI PEMBANTU UNTUK MENYUSUN ITEM BARIS MENU PENGATURAN AKUN.
  // =========================================================================
  Widget _buildAccountItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap, // AKSI MENU ITEM.
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
