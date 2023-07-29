// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SecurityLog {
  String? id;
  String user_id;
  String action_description;
  DateTime log_date;
  SecurityLog({
    this.id,
    required this.user_id,
    required this.action_description,
    required this.log_date,
  });

  SecurityLog copyWith({
    String? id,
    String? user_id,
    String? action_description,
    DateTime? dateTime,
  }) {
    return SecurityLog(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      action_description: action_description ?? this.action_description,
      log_date: dateTime ?? log_date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': user_id,
      'action_description': action_description,
      'log_date': log_date.toIso8601String(),
    };
  }

  factory SecurityLog.fromMap(Map<String, dynamic> map) {
    return SecurityLog(
      id: map['id'] != null ? map['id'] as String : null,
      user_id: map['user_id'] as String,
      action_description: map['action_description'] as String,
      log_date: DateTime.parse(map['log_date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory SecurityLog.fromJson(String source) => SecurityLog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SecurityLog(id: $id, user_id: $user_id, action_description: $action_description, dateTime: $log_date)';
  }

  @override
  bool operator ==(covariant SecurityLog other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user_id == user_id &&
      other.action_description == action_description &&
      other.log_date == log_date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user_id.hashCode ^
      action_description.hashCode ^
      log_date.hashCode;
  }
}
