// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Voter {
  String? voter_id;
  String? user_id;
  String full_name;
  DateTime birth_date;
  String address;
  String? voter_img;
  Voter({
    this.voter_id,
    this.user_id,
    required this.full_name,
    required this.birth_date,
    this.voter_img,
    required this.address,
  });

  Voter copyWith({
    String? voter_id,
    String? user_id,
    String? full_name,
    DateTime? birth_date,
    String? voter_img,
  }) {
    return Voter(
      voter_id: voter_id ?? this.voter_id,
      user_id: user_id ?? this.user_id,
      full_name: full_name ?? this.full_name,
      birth_date: birth_date ?? this.birth_date,
      voter_img: voter_img ?? this.voter_img,
      address: address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'voter_id': voter_id,
      'user_id': user_id,
      'full_name': full_name,
      'birth_date': birth_date.toIso8601String(),
      'voter_img': voter_img,
      'address': address
    };
  }

  factory Voter.fromMap(Map<dynamic, dynamic> map) {
    return Voter(
        voter_id: map['voter_id'].toString(),
        user_id: map['user_id'] != null ? map['user_id'] as String : null,
        full_name: map['full_name'] as String,
        birth_date: DateTime.parse(map['birth_date'].toString()),
        voter_img: map['voter_img'],
        address: map['address'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Voter.fromJson(String source) =>
      Voter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Voter(id: $voter_id, user_id: $user_id, full_name: $full_name, birth_date: $birth_date, voter_img: $voter_img)';
  }

  @override
  bool operator ==(covariant Voter other) {
    if (identical(this, other)) return true;

    return other.voter_id == voter_id &&
        other.user_id == user_id &&
        other.full_name == full_name &&
        other.birth_date == birth_date &&
        other.voter_img == voter_img;
  }

  @override
  int get hashCode {
    return voter_id.hashCode ^
        user_id.hashCode ^
        full_name.hashCode ^
        birth_date.hashCode ^
        voter_img.hashCode;
  }
}

class VoterCount {
  String title;
  int count;
  VoterCount({
    required this.title,
    required this.count,
  });

  VoterCount copyWith({
    String? title,
    int? count,
  }) {
    return VoterCount(
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

  factory VoterCount.fromMap(Map<String, dynamic> map) {
    return VoterCount(
      title: map['title'] as String,
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoterCount.fromJson(String source) =>
      VoterCount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VoterCount(title: $title, count: $count)';

  @override
  bool operator ==(covariant VoterCount other) {
    if (identical(this, other)) return true;

    return other.title == title && other.count == count;
  }

  @override
  int get hashCode => title.hashCode ^ count.hashCode;
}
