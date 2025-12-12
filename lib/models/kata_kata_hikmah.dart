class KataKataHikmah {
  final int nombor;
  final String sumber;
  final String kutipan;

  KataKataHikmah({
    required this.nombor,
    required this.sumber,
    required this.kutipan,
  });

  /// Create a KataKataHikmah object from JSON
  factory KataKataHikmah.fromJson(Map<String, dynamic> json) {
    // Handle both "nombor" and "nomor" (typo in JSON)
    final number = json['nombor'] ?? json['nomor'] ?? 0;
    
    return KataKataHikmah(
      nombor: number is int ? number : int.tryParse(number.toString()) ?? 0,
      sumber: json['sumber'] as String? ?? '',
      kutipan: json['kutipan'] as String? ?? '',
    );
  }

  /// Convert KataKataHikmah object to JSON
  Map<String, dynamic> toJson() {
    return {
      'nombor': nombor,
      'sumber': sumber,
      'kutipan': kutipan,
    };
  }
}
