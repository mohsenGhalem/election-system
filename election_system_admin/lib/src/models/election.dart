// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Election {
  String? election_id;
  String election_name;
  String description;
  DateTime start_date;
  DateTime end_date;
  DateTime deadline_date;
  bool isActive;
  String? election_image;
  Election({
    this.election_id,
    required this.election_name,
    required this.description,
    required this.start_date,
    required this.end_date,
    required this.deadline_date,
    required this.isActive,
    required this.election_image,
  });

  Election copyWith({
    String? election_id,
    String? election_name,
    String? description,
    DateTime? start_date,
    DateTime? end_date,
    DateTime? deadline_date,
    bool? isActive,
    String? election_image,
  }) {
    return Election(
      election_id: election_id ?? this.election_id,
      election_name: election_name ?? this.election_name,
      description: description ?? this.description,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      deadline_date: deadline_date ?? this.deadline_date,
      isActive: isActive ?? this.isActive,
      election_image: election_image ?? this.election_image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'election_id': election_id,
      'election_name': election_name,
      'description': description,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
      'deadline_date': deadline_date.toIso8601String(),
      'is_active': isActive,
      'election_image': election_image,
    };
  }

  factory Election.fromMap(Map<String, dynamic> map) {
    return Election(
      election_id: map['election_id'].toString(),
      election_name: map['election_name'] as String,
      description: map['description'] as String,
      start_date: DateTime.parse(map['start_date'].toString()),
      end_date: DateTime.parse(map['end_date'].toString()),
      deadline_date: DateTime.parse(map['deadline_date'].toString()),
      isActive: map['is_active'] as bool,
      election_image: map['election_image'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Election.fromJson(String source) =>
      Election.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Election(id: $election_id, election_name: $election_name, description: $description, start_date: $start_date, end_date: $end_date, deadline_date: $deadline_date, is_active: $isActive, election_image: $election_image)';
  }

  @override
  bool operator ==(covariant Election other) {
    if (identical(this, other)) return true;

    return other.election_id == election_id &&
        other.election_name == election_name &&
        other.description == description &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.deadline_date == deadline_date &&
        other.isActive == isActive &&
        other.election_image == election_image;
  }

  @override
  int get hashCode {
    return election_id.hashCode ^
        election_name.hashCode ^
        description.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        deadline_date.hashCode ^
        isActive.hashCode ^
        election_image.hashCode;
  }
}

class ElectionCandidate extends Election {
  String status;

  ElectionCandidate({
    super.election_id,
    required super.election_name,
    required super.description,
    required super.start_date,
    required super.end_date,
    required super.deadline_date,
    required super.isActive,
    required super.election_image,
    required this.status,
  });

  factory ElectionCandidate.fromMap(Map<String, dynamic> map) {
    return ElectionCandidate(
      election_id: map['election_id'].toString(),
      election_name: map['elections']['election_name'] as String,
      description: map['elections']['description'] as String,
      start_date: DateTime.parse(map['elections']['start_date'] as String),
      end_date: DateTime.parse(map['elections']['end_date'] as String),
      deadline_date:
          DateTime.parse(map['elections']['deadline_date'] as String),
      isActive: map['elections']['is_active'] as bool,
      election_image: map['elections']['election_image'] as String,
      status: map['is_verified'] as String,
    );
  }
}

class ElectionCount {
  String title;
  int count;
  ElectionCount({
    required this.title,
    required this.count,
  });

  ElectionCount copyWith({
    String? title,
    int? count,
  }) {
    return ElectionCount(
      title: title ?? this.title,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'count': count,
    };
  }

  factory ElectionCount.fromMap(Map<String, dynamic> map) {
    return ElectionCount(
      title: map['title'] as String,
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectionCount.fromJson(String source) =>
      ElectionCount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ElectionCount(title: $title, count: $count)';

  @override
  bool operator ==(covariant ElectionCount other) {
    if (identical(this, other)) return true;

    return other.title == title && other.count == count;
  }

  @override
  int get hashCode => title.hashCode ^ count.hashCode;
}
