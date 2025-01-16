class Asset {
  final String id;
  final String name;
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? sensorId;
  final String? status;
  final String? gatewayId;

  Asset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.sensorId,
    this.status,
    this.gatewayId,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorType: json['sensorType'],
      sensorId: json['sensorId'],
      status: json['status'],
      gatewayId: json['gatewayId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'locationId': locationId,
      'parentId': parentId,
      'sensorType': sensorType,
      'sensorId': sensorId,
      'status': status,
      'gatewayId': gatewayId,
    };
  }
}
