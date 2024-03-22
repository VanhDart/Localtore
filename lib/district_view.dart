import 'dart:convert';

class District {
  String? id;
  String? name;
  String? level;
  String? provinceId;

  District({
    this.id,
    this.name,
    this.level,
    this.provinceId,
  });

  District copyWith({
    String? id,
    String? name,
    String? level,
    String? provinceId,
  }) {
    return District(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      provinceId: provinceId ?? this.provinceId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'provinceId': provinceId,
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'] as String?,
      name: map['name'] as String?,
      level: map['level'] as String?,
      provinceId: map['provinceId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) =>
      District.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'District(id: $id, name: $name, level: $level, provinceId: $provinceId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is District &&
        other.id == id &&
        other.name == name &&
        other.level == level &&
        other.provinceId == provinceId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        level.hashCode ^
        provinceId.hashCode;
  }
}
