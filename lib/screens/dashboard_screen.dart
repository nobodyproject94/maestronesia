import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';

// =========================================================================
// DASHBOARDSCREEN MERENDER HALAMAN BERANDA UTAMA (CLIENT DASHBOARD) APLIKASI MAESTRONESIA.
// MENAMPILKAN KOLOM PENCARIAN, DAFTAR KATEGORI KEAHLIAN, EXPERT REKOMENDASI BULAN INI (HERO CARD), DAN DAFTAR REKOMENDASI EXPERT LAINNYA.
// =========================================================================
class DashboardScreen extends StatefulWidget {
  final ValueChanged<int> onSelectExpert;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  final bool isOriginalExpert; // MENUNJUKKAN APAKAH PERAN ASLI USER ADALAH EXPERT.
  final VoidCallback? onSwitchRole; // CALLBACK UNTUK MELAKUKAN PENGALIHAN PERAN.

  const DashboardScreen({
    super.key,
    required this.onSelectExpert,
    required this.onTabChanged,
    required this.onSignOut,
    this.isOriginalExpert = false,
    this.onSwitchRole,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // =========================================================================
  // DAFTAR KATEGORI SPESIALISASI UNTUK FILTER HORIZONTAL.
  // =========================================================================
  final List<String> _categories = [
    'Technology',
    'Creative',
    'Business',
    'Legal',
    'Healthcare',
    'Engineering'
  ];
  int _selectedCategoryIndex = 0; // STATE INDEKS KATEGORI AKTIF TERPILIH.

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'dashboard',
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          isOriginalExpert: widget.isOriginalExpert, // MENUNJUKKAN STATUS USER ASLINYA EXPERT.
          onSwitchRole: widget.onSwitchRole, // CALLBACK PENGALIHAN PERAN KEMBALI KE EXPERT.
          currentRole: 'client', // PERAN AKTIF SAAT INI ADALAH CLIENT.
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              // =========================================================================
              // EFEK SCROLL BOUNCE.
              // =========================================================================
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0), // PADDING DISESUAIKAN BOTTOM BAR.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner pengalihan peran di dashboard utama telah dipindahkan ke drawer menu
                  // dan profile screen agar tampilan beranda client tetap bersih dan luas.
                  // =========================================================================
                  // KOLOM PENCARIAN (SEARCH BAR) TERPADU
                  // =========================================================================
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: AppColors.textSecondary),
                        hintText: 'Search for subjects or experts...',
                        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // =========================================================================
                  // LIST HORIZONTAL KATEGORI KEAHLIAN (FILTER CHIPS)
                  // =========================================================================
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final active = index == _selectedCategoryIndex;

                        Color chipBg;
                        Border chipBorder;
                        Color chipTextColor;

                        // =========================================================================
                        // KONFIGURASI VISUAL WARNA CHIP BERDASARKAN TEMA AKTIF DAN STATUS SELEKSI CHIP.
                        // =========================================================================
                        if (active) {
                          if (isDark) {
                            chipBg = AppColors.gold;
                            chipBorder = Border.all(color: AppColors.gold);
                            chipTextColor = Colors.black;
                          } else {
                            chipBg = Colors.white.withOpacity(0.12);
                            chipBorder = Border.all(color: AppColors.gold, width: 1.5);
                            chipTextColor = AppColors.gold;
                          }
                        } else {
                          chipBg = isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05);
                          chipBorder = Border.all(color: Colors.white.withOpacity(0.05));
                          chipTextColor = AppColors.textSecondary;
                        }

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(20),
                              border: chipBorder,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // =========================================================================
                                  // MENAMPILKAN TITIK LINGKARAN KECIL EMAS DI SEBELAH KIRI TEKS JIKA TERPILIH DI LIGHT MODE.
                                  // =========================================================================
                                  if (active && !isDark) ...[
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.gold,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    cat,
                                    style: TextStyle(
                                      color: chipTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // =========================================================================
                  // KARTU UTAMA REKOMENDASI (FEATURED HERO CARD)
                  // =========================================================================
                  GestureDetector(
                    onTap: () => widget.onSelectExpert(1), // MENGHUBUNGKAN LANGSUNG KE PROFILE PROF. HERMANTO (ID: 1).
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              isDark 
                                  ? const Color(0xFF131D24).withOpacity(0.9)
                                  : const Color(0xFF0B1528).withOpacity(0.8),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'EXPERT OF THE MONTH',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                Text(
                                  'Prof. Dr. Hermanto',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.check_circle, color: AppColors.gold, size: 20),
                              ],
                            ),
                            Text(
                              'Mechanical Engineering Specialist',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // =========================================================================
                  // BARIS HEADER DAFTAR EXPERT
                  // =========================================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Experts',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // =========================================================================
                  // LIST CARD EXPERT REKOMENDASI
                  // =========================================================================
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(), // SCROLL DINONAKTIFKAN AGAR SCROLL DIPEGANG PENUH OLEH SINGLECHILDSCROLLVIEW.
                    shrinkWrap: true,
                    itemCount: mockExperts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final expert = mockExperts[index];
                      return GestureDetector(
                        onTap: () => widget.onSelectExpert(expert.id),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // =========================================================================
                                  // FOTO PROFIL DENGAN INDIKATOR STATUS KETERSEDIAAN
                                  // =========================================================================
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundImage: NetworkImage(expert.avatar),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: expert.status == 'Available' ? AppColors.gold : AppColors.textSecondary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDark ? const Color(0xFF172128) : Colors.white.withOpacity(0.05),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // =========================================================================
                                  // DETAIL IDENTITAS EXPERT
                                  // =========================================================================
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              expert.name,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(Icons.check_circle, color: AppColors.gold, size: 16),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          expert.expertise,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${expert.rating}',
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(width: 3, height: 3, decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${expert.experience} exp',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Divider(
                                color: isDark ? Colors.white10 : Colors.white.withOpacity(0.05),
                                height: 1,
                              ),
                              const SizedBox(height: 16),
                              // =========================================================================
                              // BARIS TAG DAN TARIF LAYANAN PER SESI
                              // =========================================================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: expert.tags.take(2).map((tag) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Per Session',
                                        style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
                                      ),
                                      Text(
                                        expert.price,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
