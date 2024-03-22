import 'dart:convert';

class Ward {
  String? id;
  String? name;
  String? level;
  String? provinceId;
  String? districtId;

  Ward({
    this.id,
    this.name,
    this.level,
    this.provinceId,
    this.districtId,
  });

  Ward copyWith({
    String? id,
    String? name,
    String? level,
    String? provinceId,
    String? districtId,
  }) {
    return Ward(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      provinceId: provinceId ?? this.provinceId,
      districtId: districtId ?? this.districtId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'provinceId': provinceId,
      'districtId': districtId,
    };
  }

  factory Ward.fromMap(Map<String, dynamic> map) {
    return Ward(
      id: map['id'] as String?,
      name: map['name'] as String?,
      level: map['level'] as String?,
      provinceId: map['provinceId'] as String?,
      districtId: map['districtId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ward.fromJson(String source) => Ward.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Ward(id: $id, name: $name, level: $level, provinceId: $provinceId, districtId: $districtId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ward &&
        other.id == id &&
        other.name == name &&
        other.level == level &&
        other.provinceId == provinceId &&
        other.districtId == districtId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        level.hashCode ^
        provinceId.hashCode ^
        districtId.hashCode;
  }
}
