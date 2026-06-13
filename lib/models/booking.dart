// =========================================================================
// BOOKING ADALAH MODEL DATA UNTUK MENYIMPAN INFORMASI PEMESANAN KONSULTASI.
// =========================================================================
class Booking {
  final int? id;
  final String userEmail;
  final int expertId;
  final String expertName;
  final String date;
  final String time;
  final String status;
  final String type; // CONTOH: 'Premium Video', 'Chat Only'

  Booking({
    this.id,
    required this.userEmail,
    required this.expertId,
    required this.expertName,
    required this.date,
    required this.time,
    required this.status,
    required this.type,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int?,
      userEmail: json['user_email'] as String,
      expertId: json['expert_id'] as int,
      expertName: json['expert_name'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
      type: json['type'] as String? ?? 'Premium Video',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_email': userEmail,
      'expert_id': expertId,
      'expert_name': expertName,
      'date': date,
      'time': time,
      'status': status,
      'type': type,
    };
  }

  // =========================================================================
  // FUNGSI COPYWITH UNTUK MENDUPLIKASI OBJEK DENGAN BEBERAPA PROPERTI BARU.
  // =========================================================================
  Booking copyWith({
    int? id,
    String? userEmail,
    int? expertId,
    String? expertName,
    String? date,
    String? time,
    String? status,
    String? type,
  }) {
    return Booking(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      expertId: expertId ?? this.expertId,
      expertName: expertName ?? this.expertName,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}
