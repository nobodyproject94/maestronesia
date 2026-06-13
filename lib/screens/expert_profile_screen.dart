import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/expert.dart';
import '../widgets/main_layout.dart';
import '../widgets/custom_snackbar.dart';

// =========================================================================
// EXPERTPROFILESCREEN MENAMPILKAN PROFIL DETAIL LENGKAP DARI SEORANG AHLI (EXPERT) YANG DILIHAT OLEH CLIENT.
// MENYEDIAKAN INFORMASI DESKRIPSI KUALIFIKASI, PORTOFOLIO TERVERIFIKASI, ULASAN/TESTIMONI, DAN TOMBOL PENDAFTARAN SESI (BOOKING).
// =========================================================================
class ExpertProfileScreen extends StatefulWidget {
  final Expert expert; // MODEL DATA EXPERT YANG AKAN DITAMPILKAN.
  final VoidCallback onBack; // AKSI TOMBOL KEMBALI.
  final VoidCallback onBook; // AKSI TOMBOL PEMESANAN SESI KONSULTASI.
  final ValueChanged<String> onTabChanged;
  final VoidCallback onSignOut;

  const ExpertProfileScreen({
    super.key,
    required this.expert,
    required this.onBack,
    required this.onBook,
    required this.onTabChanged,
    required this.onSignOut,
  });

  @override
  State<ExpertProfileScreen> createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends State<ExpertProfileScreen> {
  // =========================================================================
  // MENENTUKAN SUB-TAB DETAIL YANG SEDANG AKTIF: 'INFO' (OVERVIEW) ATAU 'PROVEN' (PORTFOLIO).
  // =========================================================================
  String _activeSection = 'info'; 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return MainLayout(
          activeTab: 'dashboard',
          showAppBar: false,
          onTabChanged: widget.onTabChanged,
          onSignOut: widget.onSignOut,
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF131D24) : Colors.transparent,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 120.0, // DIBERIKAN JARAK PADDING BAWAH AGAR TOMBOL AKSI TIDAK TERHALANG BOTTOM NAVIGATION BAR.
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================================================
                  // BARIS TOMBOL AKSI NAVIGASI ATAS (KEMBALI & NOTIFIKASI)
                  // =========================================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: widget.onBack,
                        icon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showCustomSnackBar(context, 'Notifications are up to date!');
                        },
                        icon: Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // =========================================================================
                  // INFORMASI UTAMA HEADER PROFIL (FOTO, NAMA, KEAHLIAN, DAN BINTANG RATING)
                  // =========================================================================
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.gold, width: 4),
                                image: DecorationImage(
                                  image: NetworkImage(widget.expert.avatar),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withValues(alpha: 0.1),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            // =========================================================================
                            // INDIKATOR STATUS KETERSEDIAAN EXPERT (TERSEDIA / TIDAK)
                            // =========================================================================
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: widget.expert.status == 'Available' ? AppColors.gold : AppColors.textSecondary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isDark ? const Color(0xFF131D24) : Colors.white.withValues(alpha: 0.05), width: 4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.expert.name,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle, color: AppColors.gold, size: 20),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.expert.expertise,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // =========================================================================
                          // MERENDER BARIS IKON BINTANG SESUAI DENGAN RATING AHLI
                          // =========================================================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    Icons.star,
                                    color: index < widget.expert.rating.floor() ? Colors.amber : AppColors.dividerColor,
                                    size: 16,
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.expert.rating} Rating',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // =========================================================================
                    // SELECTOR SUB-TAB (OVERVIEW VS PORTFOLIO)
                    // =========================================================================
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF172128).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        children: [
                          // =========================================================================
                          // TAB OVERVIEW
                          // =========================================================================
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _activeSection = 'info';
                                });
                              },
                              child: _buildSubTabContainer('Overview', _activeSection == 'info', isDark),
                            ),
                          ),
                          // =========================================================================
                          // TAB PORTFOLIO
                          // =========================================================================
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _activeSection = 'proven';
                                });
                              },
                              child: _buildSubTabContainer('Portfolio', _activeSection == 'proven', isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // =========================================================================
                    // MERENDER KONTEN SUB-TAB YANG TERPILIH SECARA DINAMIS
                    // =========================================================================
                    _activeSection == 'info' ? _buildOverview(isDark) : _buildPortfolio(isDark),
                    const SizedBox(height: 40),

                    // =========================================================================
                    // TOMBOL BOOKING KONSULTASI (CALL TO ACTION)
                    // =========================================================================
                  // TOMBOL BOOKING KONSULTASI (CALL TO ACTION)
                  // =========================================================================
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: widget.onBook,
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
                        child: const Text(
                          'Book Consultation',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  // =========================================================================
  // BUILDER HELPER FOR THE TAB CONTAINER
  // =========================================================================
  Widget _buildSubTabContainer(String label, bool active, bool isDark) {
    Color tabBg;
    Border? tabBorder;
    Color tabTextColor;
    if (active) {
      if (isDark) {
        tabBg = AppColors.gold;
        tabBorder = null;
        tabTextColor = Colors.black;
      } else {
        tabBg = Colors.white.withValues(alpha: 0.12);
        tabBorder = Border.all(color: AppColors.gold, width: 1.5);
        tabTextColor = AppColors.gold;
      }
    } else {
      tabBg = Colors.transparent;
      tabBorder = null;
      tabTextColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: tabBg,
        borderRadius: BorderRadius.circular(16),
        border: tabBorder,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              label,
              style: TextStyle(
                color: tabTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // WIDGET PEMBANGUN KONTEN SUB-TAB OVERVIEW.
  // =========================================================================
  Widget _buildOverview(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================================================================
        // GRID STATISTIK SINGKAT (CONSULTATIONS, EXPERIENCE, TARIF)
        // =========================================================================
        Row(
          children: [
            Expanded(
              child: _buildStatItem('${widget.expert.reviews * 2}', 'Consultations', isDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(widget.expert.experience, 'Experience', isDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(widget.expert.price, 'Per Session', isDark),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // =========================================================================
        // BAGIAN PENGUASAAN KEAHLIAN (MASTERIES TAGS)
        // =========================================================================
        Text(
          'MASTERIES',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.expert.tags.map((s) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF172128) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Text(
                s.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // =========================================================================
        // BAGIAN TESTIMONI TERBARU DARI PELANGGAN
        // =========================================================================
        Text(
          'RECENT TESTIMONIALS',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF172128).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.dividerColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Verified Learner',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return const Icon(Icons.star, color: AppColors.gold, size: 12);
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"Extremely patient explanation. My technical issues were resolved within the first 15 minutes of the live session."',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // MEMBUAT ITEM KOTAK STATISTIK DI BAGIAN OVERVIEW.
  // =========================================================================
  Widget _buildStatItem(String val, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF172128).withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // WIDGET PEMBANGUN KONTEN SUB-TAB PORTFOLIO.
  // =========================================================================
  Widget _buildPortfolio(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================================================================
        // KOTAK INFORMASI DISCLAIMER VERIFIKASI DATA OLEH APLIKASI
        // =========================================================================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gold.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: AppColors.gold, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Maestronesia independently verifies all credentials, journals, and career milestones listed below.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // =========================================================================
        // RIWAYAT PENGALAMAN KERJA (EXPERIENCE LIST)
        // =========================================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.business_center_outlined, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Experience',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'VERIFIED',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.expert.evidence.portfolio.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = widget.expert.evidence.portfolio[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF172128).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.grid_view, color: AppColors.gold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.type.toUpperCase()} • ${item.year}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, color: AppColors.textSecondary, size: 16),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // =========================================================================
        // DAFTAR PUBLIKASI JURNAL ILMIAH (SCIENTIFIC JOURNALS)
        // =========================================================================
        if (widget.expert.evidence.journals.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.book_outlined, color: AppColors.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'Scientific Journals',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.expert.evidence.journals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = widget.expert.evidence.journals[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF172128).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.journal.toUpperCase()} • ${item.year}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],

        // =========================================================================
        // DAFTAR AKREDITASI DAN SERTIFIKASI (ACCREDITATIONS)
        // =========================================================================
        Row(
          children: [
            Icon(Icons.workspace_premium_outlined, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text(
              'Accreditations',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.expert.evidence.credentials.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = widget.expert.evidence.credentials[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF172128).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, color: AppColors.gold, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.institute.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
