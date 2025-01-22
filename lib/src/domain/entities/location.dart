import 'dart:convert';

import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;
  final String? parentId;

  const Location({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
      ];
  @override
  bool? get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentId': parentId,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);
}
