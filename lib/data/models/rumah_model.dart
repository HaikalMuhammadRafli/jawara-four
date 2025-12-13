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
  final String rt;
  final String rw;
  final String? nomorRumah;
  final StatusRumah status;
  final String?
  pemilikId; // Optional - auto-assigned from kepalaKeluarga when Keluarga occupies
  final double? luasTanah;
  final double? luasBangunan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Rumah({
    required this.id,
    required this.alamat,
    required this.rt,
    required this.rw,
    this.nomorRumah,
    required this.status,
    this.pemilikId, // Now optional
    this.luasTanah,
    this.luasBangunan,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'alamat': alamat,
      'rt': rt,
      'rw': rw,
      'nomorRumah': nomorRumah,
      'status': status.value,
      'pemilikId': pemilikId,
      'luasTanah': luasTanah,
      'luasBangunan': luasBangunan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Rumah.fromMap(Map<String, dynamic> map) {
    return Rumah(
      id: map['id'] as String,
      alamat: map['alamat'] as String? ?? '',
      rt: map['rt'] as String? ?? '',
      rw: map['rw'] as String? ?? '',
      nomorRumah: map['nomorRumah'] as String?,
      status: map['status'] != null
          ? StatusRumah.fromString(map['status'] as String)
          : StatusRumah.kosong,
      pemilikId: map['pemilikId'] as String? ?? map['pemilik'] as String? ?? '',
      luasTanah: map['luasTanah'] != null
          ? (map['luasTanah'] as num).toDouble()
          : null,
      luasBangunan: map['luasBangunan'] != null
          ? (map['luasBangunan'] as num).toDouble()
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Rumah copyWith({
    String? id,
    String? alamat,
    String? rt,
    String? rw,
    String? nomorRumah,
    StatusRumah? status,
    String? pemilikId,
    double? luasTanah,
    double? luasBangunan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Rumah(
      id: id ?? this.id,
      alamat: alamat ?? this.alamat,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      nomorRumah: nomorRumah ?? this.nomorRumah,
      status: status ?? this.status,
      pemilikId: pemilikId ?? this.pemilikId,
      luasTanah: luasTanah ?? this.luasTanah,
      luasBangunan: luasBangunan ?? this.luasBangunan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
