// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Candidate {
  String? candidate_id;
  String? user_id;
  String full_name;
  DateTime birth_date;
  String candidate_statement;
  String? candidate_image;
  Candidate({
    this.candidate_id,
    this.user_id,
    required this.full_name,
    required this.birth_date,
    required this.candidate_statement,
    required this.candidate_image,
  });

  Candidate copyWith({
    String? id,
    String? user_id,
    String? full_name,
    DateTime? birth_date,
    String? candidate_statement,
    String? candidate_image,
  }) {
    return Candidate(
      candidate_id: id ?? candidate_id,
      user_id: user_id ?? this.user_id,
      full_name: full_name ?? this.full_name,
      birth_date: birth_date ?? this.birth_date,
      candidate_statement: candidate_statement ?? this.candidate_statement,
      candidate_image: candidate_image ?? this.candidate_image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'candidate_id': candidate_id,
      'user_id': user_id,
      'full_name': full_name,
      'birth_date': birth_date.toIso8601String(),
      'candidate_statement': candidate_statement,
      'candidate_image': candidate_image,
    };
  }

  factory Candidate.fromMap(Map<dynamic, dynamic> map) {
    return Candidate(
      candidate_id: map['candidate_id'].toString(),
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      full_name: map['full_name'] as String,
      birth_date: DateTime.parse(map['birth_date'].toString()),
      candidate_statement: map['candidate_statement'] as String,
      candidate_image: map['candidate_image'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Candidate.fromJson(String source) =>
      Candidate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Candidate(candidate_id: $candidate_id, user_id: $user_id, full_name: $full_name, birth_date: $birth_date, candidate_statement: $candidate_statement, candidate_image: $candidate_image)';
  }

  @override
  bool operator ==(covariant Candidate other) {
    if (identical(this, other)) return true;

    return other.candidate_id == candidate_id &&
        other.user_id == user_id &&
        other.full_name == full_name &&
        other.birth_date == birth_date &&
        other.candidate_statement == candidate_statement &&
        other.candidate_image == candidate_image;
  }

  @override
  int get hashCode {
    return candidate_id.hashCode ^
        user_id.hashCode ^
        full_name.hashCode ^
        birth_date.hashCode ^
        candidate_statement.hashCode ^
        candidate_image.hashCode;
  }
}

class CandidateCount {
  String title;
  int count;
  CandidateCount({
    required this.title,
    required this.count,
  });

  CandidateCount copyWith({
    String? title,
    int? count,
  }) {
    return CandidateCount(
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

  factory CandidateCount.fromMap(Map<String, dynamic> map) {
    return CandidateCount(
      title: map['title'] as String,
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CandidateCount.fromJson(String source) =>
      CandidateCount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CandidateCount(title: $title, count: $count)';

  @override
  bool operator ==(covariant CandidateCount other) {
    if (identical(this, other)) return true;

    return other.title == title && other.count == count;
  }

  @override
  int get hashCode => title.hashCode ^ count.hashCode;
}

class CandidateElectionVoteCount extends Candidate {
  int vote_count;

  CandidateElectionVoteCount({
    super.candidate_id,
    super.user_id,
    required super.full_name,
    required super.birth_date,
    required super.candidate_statement,
    required super.candidate_image,
    required this.vote_count,
  });
}
