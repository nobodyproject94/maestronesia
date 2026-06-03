class PortfolioItem {
  final String title;
  final String year;
  final String type;

  PortfolioItem({required this.title, required this.year, required this.type});
}

class JournalItem {
  final String title;
  final String year;
  final String journal;

  JournalItem({required this.title, required this.year, required this.journal});
}

class CredentialItem {
  final String title;
  final String institute;

  CredentialItem({required this.title, required this.institute});
}

class Evidence {
  final List<PortfolioItem> portfolio;
  final List<JournalItem> journals;
  final List<CredentialItem> credentials;

  Evidence({
    required this.portfolio,
    required this.journals,
    required this.credentials,
  });
}

class Expert {
  final int id;
  final String name;
  final String expertise;
  final String experience;
  final double rating;
  final int reviews;
  final String price;
  final String status;
  final List<String> tags;
  final String avatar;
  final Evidence evidence;

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

final List<Expert> mockExperts = [
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
