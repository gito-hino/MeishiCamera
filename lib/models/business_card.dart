class BusinessCard {
  final String? id;
  final String name;
  final String company;
  final String email;
  final String phone;
  final String memo;
  final DateTime? timestamp;

  BusinessCard({
    this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.memo,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company': company,
      'email': email,
      'phone': phone,
      'memo': memo,
    };
  }

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      memo: json['memo'] ?? '',
      timestamp:
          json['timestamp'] != null
              ? DateTime.tryParse(json['timestamp'].toString())
              : null,
    );
  }
}
