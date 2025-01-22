import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';

void main() {
  group('Node', () {
    test('should create a Node instance', () {
      final node = Node(
        id: '1',
        name: 'Node 1',
        type: NodeType.component,
      );

      expect(node.id, '1');
      expect(node.name, 'Node 1');
      expect(node.type, NodeType.component);
      expect(node.parentId, isNull);
      expect(node.locationId, isNull);
      expect(node.sensorType, isNull);
      expect(node.status, isNull);
      expect(node.children, isEmpty);
    });

    test('should support value equality', () {
      final node1 = Node(
        id: '1',
        name: 'Node 1',
        type: NodeType.component,
      );

      final node2 = Node(
        id: '1',
        name: 'Node 1',
        type: NodeType.component,
      );

      expect(node1, equals(node2));
    });

    test('should copy with new values', () {
      final node = Node(
        id: '1',
        name: 'Node 1',
        type: NodeType.component,
      );

      final updatedNode = node.copyWith(
        name: 'Updated Node',
        type: NodeType.asset,
      );

      expect(updatedNode.id, '1');
      expect(updatedNode.name, 'Updated Node');
      expect(updatedNode.type, NodeType.asset);
      expect(updatedNode.parentId, isNull);
      expect(updatedNode.locationId, isNull);
      expect(updatedNode.sensorType, isNull);
      expect(updatedNode.status, isNull);
      expect(updatedNode.children, isEmpty);
    });
  });
}
