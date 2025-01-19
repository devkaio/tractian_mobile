import 'package:data_result/data_result.dart';
import 'package:flutter/foundation.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/entities/component.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/domain/repositories/asset_repository.dart';
import 'package:tractian_mobile/src/domain/repositories/location_repository.dart';

class BuildTreeUseCase {
  final AssetRepository assetRepository;
  final LocationRepository locationRepository;

  BuildTreeUseCase({
    required this.assetRepository,
    required this.locationRepository,
  });

  Future<DataResult<List<Node>>> fetchTreeData(String companyId) async {
    final assetResult = await assetRepository.fetchAssets(companyId);
    final locationResult = await locationRepository.fetchLocations(companyId);

    if (assetResult.error != null) {
      return DataResult.failure(assetResult.error!);
    }

    if (locationResult.error != null) {
      return DataResult.failure(locationResult.error!);
    }

    final locations = locationResult.data!;
    final assets =
        assetResult.data!.where((asset) => asset.sensorType == null).toList();

    final components = assetResult.data!
        .where((asset) => asset.sensorType != null)
        .map((asset) => Component(
              id: asset.id,
              name: asset.name,
              parentId: asset.parentId,
              locationId: asset.locationId,
              sensorType: asset.sensorType,
              status: asset.status,
            ))
        .toList();

    final rootNodes = await compute(BuildTreeUseCase.buildTreeIsolated, {
      'locations': locations,
      'assets': assets,
      'components': components,
    });

    return DataResult.success(rootNodes);
  }

  static List<Node> buildTreeIsolated(Map<String, dynamic> data) {
    final locations = data['locations'] as List<Location>;
    final assets = data['assets'] as List<Asset>;
    final components = data['components'] as List<Component>;

    final nodeMap = <String, Node>{};
    final childrenMap = <String, List<Node>>{};

    // Create nodes for locations, assets, and components
    for (final location in locations) {
      final node = Node(
        id: location.id,
        name: location.name,
        type: NodeType.location,
        parentId: location.parentId,
      );
      nodeMap[location.id] = node;
      if (location.parentId != null) {
        childrenMap.putIfAbsent(location.parentId!, () => []).add(node);
      }
    }

    for (final asset in assets) {
      final node = Node(
        id: asset.id,
        name: asset.name,
        type: NodeType.asset,
        parentId: asset.parentId,
        locationId: asset.locationId,
        sensorType: asset.sensorType,
        status: asset.status,
      );
      nodeMap[asset.id] = node;
      if (asset.parentId != null) {
        childrenMap.putIfAbsent(asset.parentId!, () => []).add(node);
      } else if (asset.locationId != null) {
        childrenMap.putIfAbsent(asset.locationId!, () => []).add(node);
      }
    }

    for (final component in components) {
      final node = Node(
        id: component.id,
        name: component.name,
        type: NodeType.component,
        parentId: component.parentId,
        locationId: component.locationId,
        sensorType: component.sensorType,
        status: component.status,
      );
      nodeMap[component.id] = node;
      if (component.parentId != null) {
        childrenMap.putIfAbsent(component.parentId!, () => []).add(node);
      } else if (component.locationId != null) {
        childrenMap.putIfAbsent(component.locationId!, () => []).add(node);
      }
    }

    // Helper function to build the tree iteratively using a stack
    Node buildNode(Node node) {
      final stack = <Node>[];
      stack.add(node);

      while (stack.isNotEmpty) {
        final currentNode = stack.removeLast();
        final children = childrenMap[currentNode.id] ?? [];
        final builtChildren = <Node>[];

        for (final child in children) {
          stack.add(child);
          builtChildren.add(child.copyWith(children: childrenMap[child.id]));
        }

        nodeMap[currentNode.id] = currentNode.copyWith(
          children: builtChildren.isEmpty ? null : builtChildren,
        );
      }

      return nodeMap[node.id]!;
    }

    // Build the root nodes and categorize them
    final rootNodesWithChildren = <Node>[];
    final rootNodesWithoutChildren = <Node>[];
    final unlinkedAssets = <Node>[];
    final unlinkedComponents = <Node>[];

    for (var node in nodeMap.values) {
      if (node.parentId == null && node.locationId == null) {
        final rootNode = buildNode(node);
        if (rootNode.type == NodeType.asset) {
          unlinkedAssets.add(rootNode);
        } else if (rootNode.type == NodeType.component) {
          unlinkedComponents.add(rootNode);
        } else if (rootNode.children != null && rootNode.children!.isNotEmpty) {
          rootNodesWithChildren.add(rootNode);
        } else {
          rootNodesWithoutChildren.add(rootNode);
        }
      }
    }

    // Combine the nodes in the desired order
    final rootNodes = <Node>[];
    rootNodes.addAll(rootNodesWithChildren);
    rootNodes.addAll(rootNodesWithoutChildren);
    rootNodes.addAll(unlinkedAssets);
    rootNodes.addAll(unlinkedComponents);

    return rootNodes;
  }

  List<Node> filterTreeData({
    required List<Node> nodes,
    String query = '',
  }) {
    final filteredNodes = <Node>[];

    for (final node in nodes) {
      final children = node.children != null
          ? filterTreeData(nodes: node.children!, query: query)
          : <Node>[];

      if (node.name.toLowerCase().contains(query.toLowerCase()) ||
          children.isNotEmpty) {
        filteredNodes.add(
          Node(
            id: node.id,
            name: node.name,
            type: node.type,
            parentId: node.parentId,
            locationId: node.locationId,
            sensorType: node.sensorType,
            status: node.status,
            children: children.isEmpty ? null : children,
          ),
        );
      }
    }

    return filteredNodes;
  }

  List<Node> filterByStatus({
    required List<Node> nodes,
    required String status,
  }) {
    final filteredNodes = <Node>[];

    for (final node in nodes) {
      final children = node.children != null
          ? filterByStatus(nodes: node.children!, status: status)
          : <Node>[];

      if (node.status == status || children.isNotEmpty) {
        filteredNodes.add(
          Node(
            id: node.id,
            name: node.name,
            type: node.type,
            parentId: node.parentId,
            locationId: node.locationId,
            sensorType: node.sensorType,
            status: node.status,
            children: children.isEmpty ? null : children,
          ),
        );
      }
    }

    return filteredNodes;
  }
}
