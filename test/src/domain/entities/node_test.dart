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

  group('FlatNode & flattenTree', () {
    test('flattenTree returns correct flat list and depth', () {
      final tree = [
        Node(
          id: '1',
          name: 'Root',
          type: NodeType.location,
          expanded: true,
          children: [
            Node(
              id: '1-1',
              name: 'Child',
              type: NodeType.asset,
              expanded: true,
              children: [
                Node(
                  id: '1-1-1',
                  name: 'Grandchild',
                  type: NodeType.component,
                ),
              ],
            ),
          ],
        ),
      ];

      final flat = tree.flattenTree();
      expect(flat.length, 3);
      expect(flat[0].node.id, '1');
      expect(flat[0].depth, 0);
      expect(flat[1].node.id, '1-1');
      expect(flat[1].depth, 1);
      expect(flat[2].node.id, '1-1-1');
      expect(flat[2].depth, 2);
    });

    test('flattenTree skips children of collapsed nodes', () {
      final tree = [
        Node(
          id: '1',
          name: 'Root',
          type: NodeType.location,
          expanded: false,
          children: [
            Node(
              id: '1-1',
              name: 'Child',
              type: NodeType.asset,
            ),
          ],
        ),
      ];

      final flat = tree.flattenTree();
      expect(flat.length, 1);
      expect(flat[0].node.id, '1');
    });

    test('flattenTree works with multiple root nodes', () {
      final tree = [
        Node(id: '1', name: 'Root1', type: NodeType.location),
        Node(id: '2', name: 'Root2', type: NodeType.asset),
      ];

      final flat = tree.flattenTree();
      expect(flat.length, 2);
      expect(flat[0].node.id, '1');
      expect(flat[1].node.id, '2');
    });

    test('FlatNode stores node and depth correctly', () {
      final node = Node(id: '1', name: 'Test', type: NodeType.location);
      final flat = FlatNode(node, 3);
      expect(flat.node, node);
      expect(flat.depth, 3);
    });
  });
}
