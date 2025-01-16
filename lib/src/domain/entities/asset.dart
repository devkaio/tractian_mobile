class Asset {
  final String id;
  final String name;
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? sensorId;
  final String status;

  Asset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.sensorId,
    required this.status,
  });
}
