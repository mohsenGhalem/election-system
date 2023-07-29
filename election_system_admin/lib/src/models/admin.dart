import 'dart:convert';

class Admin {
  String? admin_id;
  String? user_id;
  String full_name;
  String? admin_image;
  String admin_status;
  Admin({
    this.admin_id,
    this.user_id,
    required this.full_name,
    this.admin_image,
    required this.admin_status,
  });

  Admin copyWith({
    String? id,
    String? user_id,
    String? full_name,
    String? admin_image,
    String? admin_status,
  }) {
    return Admin(
      admin_id: id ?? admin_id,
      user_id: user_id ?? this.user_id,
      full_name: full_name ?? this.full_name,
      admin_image: admin_image ?? this.admin_image,
      admin_status: admin_status ?? this.admin_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'admin_id': admin_id,
      'user_id': user_id,
      'full_name': full_name,
      'admin_image': admin_image,
      'admin_status': admin_status,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      admin_id: map['admin_id'].toString(),
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      full_name: map['full_name'] as String,
      admin_image: map['admin_image'] as String?,
      admin_status: map['admin_status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin(id: $admin_id, user_id: $user_id, full_name: $full_name, admin_image: $admin_image, admin_status: $admin_status)';
  }

  @override
  bool operator ==(covariant Admin other) {
    if (identical(this, other)) return true;

    return other.admin_id == admin_id &&
        other.user_id == user_id &&
        other.full_name == full_name &&
        other.admin_image == admin_image &&
        other.admin_status == admin_status;
  }

  @override
  int get hashCode {
    return admin_id.hashCode ^
        user_id.hashCode ^
        full_name.hashCode ^
        admin_image.hashCode ^
        admin_status.hashCode;
  }
}
