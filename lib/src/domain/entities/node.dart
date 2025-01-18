import 'package:equatable/equatable.dart';

enum NodeType {
  component,
  location,
  asset,
}

class Node extends Equatable {
  final String id;
  final String name;
  final NodeType type;
  final String? parentId;
  final String? locationId;
  final String? sensorType;
  final String? status;
  final List<Node>? children;

  const Node({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
    this.children = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
        locationId,
        type,
        sensorType,
        status,
        children,
      ];

  @override
  bool? get stringify => true;

  Node copyWith({
    String? id,
    String? name,
    NodeType? type,
    String? parentId,
    String? locationId,
    String? sensorType,
    String? status,
    List<Node>? children,
  }) {
    return Node(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      locationId: locationId ?? this.locationId,
      sensorType: sensorType ?? this.sensorType,
      status: status ?? this.status,
      children: children ?? this.children,
    );
  }
}
