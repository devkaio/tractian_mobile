class Component {
  final String id;
  final String name;
  final String sensorType;
  final String sensorId;
  final String status;
  final String? parentId;

  Component({
    required this.id,
    required this.name,
    required this.sensorType,
    required this.sensorId,
    required this.status,
    this.parentId,
  });
}
