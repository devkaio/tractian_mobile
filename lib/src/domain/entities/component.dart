import 'dart:convert';

import 'package:equatable/equatable.dart';

class Component extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final String? sensorType;
  final String? status;

  const Component({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
        locationId,
        sensorType,
        status,
      ];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentId': parentId,
      'locationId': locationId,
      'sensorType': sensorType,
      'status': status,
    };
  }

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      id: map['id'] as String,
      name: map['name'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      locationId:
          map['locationId'] != null ? map['locationId'] as String : null,
      sensorType:
          map['sensorType'] != null ? map['sensorType'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Component.fromJson(String source) =>
      Component.fromMap(json.decode(source) as Map<String, dynamic>);
}
