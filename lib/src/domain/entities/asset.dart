import 'dart:convert';

import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final String id;
  final String name;
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? status;

  const Asset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        locationId,
        parentId,
      ];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'locationId': locationId,
      'parentId': parentId,
      'sensorType': sensorType,
      'status': status,
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] as String,
      name: map['name'] as String,
      locationId:
          map['locationId'] != null ? map['locationId'] as String : null,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      sensorType:
          map['sensorType'] != null ? map['sensorType'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Asset.fromJson(String source) =>
      Asset.fromMap(json.decode(source) as Map<String, dynamic>);
}
