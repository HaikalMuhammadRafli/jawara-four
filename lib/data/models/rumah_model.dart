enum StatusRumah {
  ditempati('Ditempati'),
  kosong('Kosong'),
  disewakan('Disewakan');

  final String value;
  const StatusRumah(this.value);

  static StatusRumah fromString(String value) {
    return StatusRumah.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusRumah.ditempati,
    );
  }
}

class Rumah {
  final String id;
  final String alamat;
  final StatusRumah status;
  final String pemilik;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Rumah({
    required this.id,
    required this.alamat,
    required this.status,
    required this.pemilik,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'alamat': alamat,
      'status': status.value,
      'pemilik': pemilik,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Rumah.fromMap(Map<String, dynamic> map) {
    return Rumah(
      id: map['id'] as String,
      alamat: map['alamat'] as String,
      status: StatusRumah.fromString(map['status'] as String),
      pemilik: map['pemilik'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Rumah copyWith({
    String? id,
    String? alamat,
    StatusRumah? status,
    String? pemilik,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Rumah(
      id: id ?? this.id,
      alamat: alamat ?? this.alamat,
      status: status ?? this.status,
      pemilik: pemilik ?? this.pemilik,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
