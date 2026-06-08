// =========================================================================
// SECTION 1: BLUEPRINT / MODEL CLASS (Struktur Cetakan Data)
// =========================================================================

// Model untuk item portofolio milik expert
class PortfolioItem {
  final String
  title; // Judul proyek/kegiatan (misal: 'Ketua Riset Mobil Listrik')
  final String year; // Tahun pelaksanaan
  final String
  type; // Jenis portofolio (misal: 'Research', 'Project', 'Consultation')

  // Constructor wajib untuk mengisi data PortfolioItem
  PortfolioItem({required this.title, required this.year, required this.type});
}

// Model untuk riwayat jurnal ilmiah yang pernah diterbitkan oleh expert
class JournalItem {
  final String title; // Judul jurnal ilmiah
  final String year; // Tahun terbit jurnal
  final String
  journal; // Nama penerbit/media jurnal (misal: 'International Mechanical Review')

  JournalItem({required this.title, required this.year, required this.journal});
}

// Model untuk sertifikasi, lisensi, atau gelar akademik expert
class CredentialItem {
  final String
  title; // Nama gelar/sertifikasi (misal: 'PhD in Mechanical Engineering')
  final String institute; // Lembaga/Universitas yang mengeluarkan sertifikat

  CredentialItem({required this.title, required this.institute});
}

// Model gabungan (kontainer) untuk menampung semua bukti validasi expert (portofolio, jurnal, dan kredensial)
class Evidence {
  final List<PortfolioItem>
  portfolio; // Menampung banyak item portofolio dalam bentuk List []
  final List<JournalItem>
  journals; // Menampung banyak item jurnal dalam bentuk List []
  final List<CredentialItem>
  credentials; // Menampung banyak item sertifikasi dalam bentuk List []

  Evidence({
    required this.portfolio,
    required this.journals,
    required this.credentials,
  });
}

// Model Utama untuk profil seorang Expert (Ahli)
class Expert {
  final int id; // ID unik pembeda antar expert (untuk pencarian di database)
  final String name; // Nama lengkap beserta gelar
  final String expertise; // Bidang keahlian utama (misal: 'Informatika & AI')
  final String experience; // Lama pengalaman kerja (misal: '15 yrs')
  final double
  rating; // Nilai rating kepuasan (menggunakan double untuk angka desimal, misal: 4.9)
  final int reviews; // Jumlah total user yang memberikan review
  final String price; // Tarif harga konsultasi
  final String
  status; // Status ketersediaan (misal: 'Available', 'Available tomorrow')
  final List<String>
  tags; // Sub-keahlian spesifik dalam bentuk List teks pendek (misal: ['Machine Learning', 'Cyber Security'])
  final String avatar; // URL string tautan gambar foto profil dari internet
  final Evidence
  evidence; // Data relasi objek bukti kredibilitas (mengambil struktur dari class Evidence di atas)

  Expert({
    required this.id,
    required this.name,
    required this.expertise,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.status,
    required this.tags,
    required this.avatar,
    required this.evidence,
  });
}

// =========================================================================
// SECTION 2: MOCK DATA (Data Simulasi yang Siap Digunakan di UI Aplikasi)
// =========================================================================

// Mendeklarasikan variabel 'mockExperts' berupa List global yang berisi sekumpulan objek data Expert
final List<Expert> mockExperts = [
  // ---------------- EXPERT 1: Prof. Dr. Hermanto ----------------
  Expert(
    id: 1,
    name: 'Prof. Dr. Hermanto',
    expertise: 'Teknik Mesin & Termodinamika',
    experience: '15 yrs',
    rating: 4.9,
    reviews: 128,
    price: 'Rp 150k',
    status: 'Available',
    tags: ['Mekanika Fluida', 'Manufaktur'],
    avatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
    evidence: Evidence(
      portfolio: [
        PortfolioItem(
          title: 'Ketua Riset Mobil Listrik Nasional',
          year: '2023',
          type: 'Research',
        ),
        PortfolioItem(
          title: 'Konsultan Teknik Pertamina',
          year: '2022',
          type: 'Consultation',
        ),
      ],
      journals: [
        JournalItem(
          title: 'Analysis of Thermal Efficiency in Combustion Engines',
          year: '2021',
          journal: 'International Mechanical Review',
        ),
      ],
      credentials: [
        CredentialItem(
          title: 'PhD in Mechanical Engineering',
          institute: 'Bandung Institute of Technology',
        ),
        CredentialItem(
          title: 'Certified Senior Engineer',
          institute: 'Biro Klasifikasi Indonesia',
        ),
      ],
    ),
  ),

  // ---------------- EXPERT 2: Dr. Sarah Amelia ----------------
  Expert(
    id: 2,
    name: 'Dr. Sarah Amelia',
    expertise: 'Informatika & AI',
    experience: '8 yrs',
    rating: 4.8,
    reviews: 64,
    price: 'Rp 120k',
    status: 'Available',
    tags: ['Machine Learning', 'Cyber Security'],
    avatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop',
    evidence: Evidence(
      portfolio: [
        PortfolioItem(
          title: 'Lead AI Developer at TechGiant',
          year: '2023',
          type: 'Project',
        ),
        PortfolioItem(
          title: 'Speaker at Global AI Summit',
          year: '2022',
          type: 'Conference',
        ),
      ],
      journals: [
        JournalItem(
          title: 'Ethical Implications of AI in Automation',
          year: '2022',
          journal: 'Technology & Society',
        ),
      ],
      credentials: [
        CredentialItem(
          title: 'Doctor of Computer Science',
          institute: 'University of Indonesia',
        ),
      ],
    ),
  ),

  // ---------------- EXPERT 3: Ir. Ahmad Fauzi ----------------
  Expert(
    id: 3,
    name: 'Ir. Ahmad Fauzi',
    expertise: 'Teknik Sipil & Struktur',
    experience: '12 yrs',
    rating: 4.9,
    reviews: 42,
    price: 'Rp 135k',
    status: 'Available tomorrow',
    tags: ['Konstruksi Gedung', 'Bridges'],
    avatar:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
    evidence: Evidence(
      portfolio: [
        PortfolioItem(
          title: 'Lead Structural Engineer - MRT Jakarta',
          year: '2024',
          type: 'Infrastructure',
        ),
      ],
      journals: [
        JournalItem(
          title: 'Seismic Resistance of High-Rise Buildings',
          year: '2022',
          journal: 'Civil Engineering Today',
        ),
      ],
      credentials: [
        CredentialItem(
          title: 'Licensed Professional Engineer',
          institute: 'Indonesian Engineers Association',
        ),
      ],
    ),
  ),
];
