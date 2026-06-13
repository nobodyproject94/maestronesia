// =========================================================================
// PORTFOLIOITEM MEREPRESENTASIKAN ITEM PORTOFOLIO DARI SEORANG AHLI (EXPERT),
// BERISI JUDUL PROYEK, TAHUN PELAKSANAAN, DAN TIPE PROYEK.
// =========================================================================
// =========================================================================
class PortfolioItem {
  final String title;
  final String year;
  final String type;

  PortfolioItem({required this.title, required this.year, required this.type});

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      title: json['title'] as String,
      year: json['year'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'year': year,
      'type': type,
    };
  }
}

// =========================================================================
// JOURNALITEM MEREPRESENTASIKAN ARTIKEL JURNAL ILMIAH YANG PERNAH DITULIS/DITERBITKAN OLEH AHLI,
// BERISI JUDUL JURNAL, TAHUN PUBLIKASI, DAN NAMA PENERBIT JURNAL.
// =========================================================================
// =========================================================================
class JournalItem {
  final String title;
  final String year;
  final String journal;

  JournalItem({required this.title, required this.year, required this.journal});

  factory JournalItem.fromJson(Map<String, dynamic> json) {
    return JournalItem(
      title: json['title'] as String,
      year: json['year'] as String,
      journal: json['journal'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'year': year,
      'journal': journal,
    };
  }
}

// =========================================================================
// CREDENTIALITEM MEREPRESENTASIKAN KREDENSIAL AKADEMIK ATAU SERTIFIKASI PROFESIONAL DARI AHLI,
// BERISI GELAR/NAMA SERTIFIKASI DAN NAMA INSTITUT PENERBITNYA.
// =========================================================================
// =========================================================================
class CredentialItem {
  final String title;
  final String institute;

  CredentialItem({required this.title, required this.institute});

  factory CredentialItem.fromJson(Map<String, dynamic> json) {
    return CredentialItem(
      title: json['title'] as String,
      institute: json['institute'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'institute': institute,
    };
  }
}

// =========================================================================
// EVIDENCE MENGELOMPOKKAN BUKTI-BUKTI KOMPETENSI AHLI, MELIPUTI PORTOFOLIO, PUBLIKASI JURNAL, DAN SERTIFIKASI/KREDENSIAL.
// =========================================================================
// =========================================================================
class Evidence {
  final List<PortfolioItem> portfolio;
  final List<JournalItem> journals;
  final List<CredentialItem> credentials;

  Evidence({
    required this.portfolio,
    required this.journals,
    required this.credentials,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      portfolio: (json['portfolio'] as List<dynamic>?)
              ?.map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      journals: (json['journals'] as List<dynamic>?)
              ?.map((e) => JournalItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      credentials: (json['credentials'] as List<dynamic>?)
              ?.map((e) => CredentialItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'portfolio': portfolio.map((e) => e.toJson()).toList(),
      'journals': journals.map((e) => e.toJson()).toList(),
      'credentials': credentials.map((e) => e.toJson()).toList(),
    };
  }
}

// =========================================================================
// EXPERT ADALAH MODEL DATA UTAMA UNTUK MENYIMPAN INFORMASI PROFIL AHLI (EXPERT).
// =========================================================================
// =========================================================================
class Expert {
  final int id; // ID UNIK EXPERT.
  final String name; // NAMA LENGKAP EXPERT BESERTA GELAR.
  final String category; // KATEGORI: 'Academic' atau 'Non-Academic'
  final String expertise; // BIDANG KEAHLIAN UTAMA EXPERT.
  final String experience; // LAMA WAKTU PENGALAMAN (CONTOH: "15 YRS").
  final double rating; // RATING RATA-RATA DARI ULASAN CLIENT.
  final int reviews; // JUMLAH TOTAL ULASAN/REVIEWS.
  final String price; // TARIF KONSULTASI PER SESI.
  final String status; // STATUS KETERSEDIAAN (CONTOH: "AVAILABLE").
  final List<String> tags; // LABEL/TAG KEAHLIAN SPESIFIK.
  final String avatar; // URL GAMBAR FOTO PROFIL EXPERT.
  final Evidence evidence; // BUKTI SERTIFIKASI DAN PORTOFOLIO EXPERT.

  Expert({
    required this.id,
    required this.name,
    required this.category,
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

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      expertise: json['expertise'] as String,
      experience: json['experience'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      price: json['price'] as String,
      status: json['status'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      avatar: json['avatar'] as String,
      evidence: Evidence.fromJson(json['evidence'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'expertise': expertise,
      'experience': experience,
      'rating': rating,
      'reviews': reviews,
      'price': price,
      'status': status,
      'tags': tags,
      'avatar': avatar,
      'evidence': evidence.toJson(),
    };
  }
}

// =========================================================================
// MOCKEXPERTS ADALAH DAFTAR DATA STATIS EXPERT UNTUK KEPERLUAN SIMULASI TAMPILAN DAN DATA AWAL APLIKASI.
// =========================================================================
// =========================================================================
final List<Expert> mockExperts = [
  Expert(
    id: 1,
    name: 'Prof. Dr. Hermanto',
    category: 'Non-Academic',
    expertise: 'Teknik Mesin & Termodinamika',
    experience: '15 yrs',
    rating: 4.9,
    reviews: 128,
    price: 'Rp 150k',
    status: 'Available',
    tags: ['Mekanika Fluida', 'Manufaktur'],
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
    evidence: Evidence(
      portfolio: [
        PortfolioItem(title: 'Ketua Riset Mobil Listrik Nasional', year: '2023', type: 'Research'),
        PortfolioItem(title: 'Konsultan Teknik Pertamina', year: '2022', type: 'Consultation'),
      ],
      journals: [
        JournalItem(title: 'Analysis of Thermal Efficiency in Combustion Engines', year: '2021', journal: 'International Mechanical Review'),
      ],
      credentials: [
        CredentialItem(title: 'PhD in Mechanical Engineering', institute: 'Bandung Institute of Technology'),
        CredentialItem(title: 'Certified Senior Engineer', institute: 'Biro Klasifikasi Indonesia'),
      ],
    ),
  ),
  Expert(
    id: 2,
    name: 'Dr. Sarah Amelia',
    category: 'Academic',
    expertise: 'Informatika & AI',
    experience: '8 yrs',
    rating: 4.8,
    reviews: 64,
    price: 'Rp 120k',
    status: 'Available',
    tags: ['Machine Learning', 'Cyber Security'],
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop',
    evidence: Evidence(
      portfolio: [
        PortfolioItem(title: 'Lead AI Developer at TechGiant', year: '2023', type: 'Project'),
        PortfolioItem(title: 'Speaker at Global AI Summit', year: '2022', type: 'Conference'),
      ],
      journals: [
        JournalItem(title: 'Ethical Implications of AI in Automation', year: '2022', journal: 'Technology & Society'),
      ],
      credentials: [
        CredentialItem(title: 'Doctor of Computer Science', institute: 'University of Indonesia'),
      ],
    ),
  ),
  Expert(
    id: 3,
    name: 'Ir. Ahmad Fauzi',
    category: 'Non-Academic',
    expertise: 'Teknik Sipil & Struktur',
    experience: '12 yrs',
    rating: 4.9,
    reviews: 42,
    price: 'Rp 135k',
    status: 'Available tomorrow',
    tags: ['Konstruksi Gedung', 'Bridges'],
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
    evidence: Evidence(
      portfolio: [
        PortfolioItem(title: 'Lead Structural Engineer - MRT Jakarta', year: '2024', type: 'Infrastructure'),
      ],
      journals: [
        JournalItem(title: 'Seismic Resistance of High-Rise Buildings', year: '2022', journal: 'Civil Engineering Today'),
      ],
      credentials: [
        CredentialItem(title: 'Licensed Professional Engineer', institute: 'Indonesian Engineers Association'),
      ],
    ),
  ),
];
