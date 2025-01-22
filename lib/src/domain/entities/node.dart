import 'package:flutter/foundation.dart';

enum NodeType {
  component,
  location,
  asset,
}

enum NodeStatus {
  operating,
  alert,
}

enum NodeSensorType {
  energy,
  vibration,
}

class Node {
  final String id;
  final String name;
  final NodeType? type;
  final String? parentId;
  final String? locationId;
  final NodeSensorType? sensorType;
  final NodeStatus? status;
  final List<Node> children;

  bool _expanded = false;

  bool get expanded => _expanded;

  void updateExpansionStatus(bool value) {
    _expanded = value;
  }

  Node({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
    this.children = const [],
  });

  bool get isRoot => parentId == null && locationId == null;

  Node copyWith({
    String? id,
    String? name,
    NodeType? type,
    String? parentId,
    String? locationId,
    NodeSensorType? sensorType,
    NodeStatus? status,
    List<Node>? children,
    bool? expanded,
    bool? isFiltered,
  }) {
    _expanded = expanded ?? this.expanded;

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

  @override
  bool operator ==(covariant Node other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.type == type &&
        other.parentId == parentId &&
        other.locationId == locationId &&
        other.sensorType == sensorType &&
        other.status == status &&
        listEquals(other.children, children) &&
        other.expanded == expanded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        parentId.hashCode ^
        locationId.hashCode ^
        sensorType.hashCode ^
        status.hashCode ^
        children.hashCode ^
        expanded.hashCode;
  }

  @override
  String toString() {
    return 'Node(id: $id, name: $name, type: $type, parentId: $parentId, locationId: $locationId, sensorType: $sensorType, status: $status, children: $children, _expanded: $_expanded)';
  }
}
