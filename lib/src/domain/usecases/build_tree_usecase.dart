import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:tractian_mobile/src/core/data_result/data_result.dart';
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

    final rootNodes = await compute(BuildTreeUseCase.buildTree, {
      'locations': locations,
      'assets': assets,
      'components': components,
    });

    return DataResult.success(rootNodes);
  }

  static List<Node> buildTree(Map<String, dynamic> data) {
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
        sensorType: NodeSensorType.values.firstWhereOrNull(
          (e) => e.name == asset.sensorType,
        ),
        status: NodeStatus.values.firstWhereOrNull(
          (e) => e.name == asset.status,
        ),
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
        sensorType: NodeSensorType.values.firstWhereOrNull(
          (e) => e.name == component.sensorType,
        ),
        status: NodeStatus.values.firstWhereOrNull(
          (e) => e.name == component.status,
        ),
      );
      nodeMap[component.id] = node;
      if (component.parentId != null) {
        childrenMap.putIfAbsent(component.parentId!, () => []).add(node);
      } else if (component.locationId != null) {
        childrenMap.putIfAbsent(component.locationId!, () => []).add(node);
      }
    }

    // Helper function to build the tree iteratively using queue for deeper levels
    Node buildSubtree(Node node, int depth) {
      if (depth > 1000) {
        // Switch to iterative approach for deeper levels
        final stack = Queue<Node>();
        stack.add(node);

        while (stack.isNotEmpty) {
          final currentNode = stack.removeFirst();
          final children = childrenMap[currentNode.id] ?? [];
          final builtChildren = <Node>[];

          for (final child in children) {
            stack.add(child);
            builtChildren.add(child.copyWith(children: childrenMap[child.id]));
          }

          nodeMap[currentNode.id] = currentNode.copyWith(
            children: builtChildren,
          );
        }

        return nodeMap[node.id]!;
      } else {
        final children = childrenMap[node.id] ?? [];
        final builtChildren =
            children.map((child) => buildSubtree(child, depth + 1)).toList();
        return node.copyWith(children: builtChildren);
      }
    }

    final rootNodesWithChildren = <Node>[];
    final rootNodesWithoutChildren = <Node>[];
    final unlinkedAssets = <Node>[];
    final unlinkedComponents = <Node>[];

    for (var node in nodeMap.values) {
      if (node.parentId == null && node.locationId == null) {
        final root = buildSubtree(node, 0);
        if (root.type == NodeType.asset) {
          unlinkedAssets.add(root);
        } else if (root.type == NodeType.component) {
          unlinkedComponents.add(root);
        } else if (root.children.isNotEmpty) {
          rootNodesWithChildren.add(root);
        } else {
          rootNodesWithoutChildren.add(root);
        }
      }
    }

    final rootNodes = <Node>[];
    rootNodes.addAll(rootNodesWithChildren);
    rootNodes.addAll(rootNodesWithoutChildren);
    rootNodes.addAll(unlinkedAssets);
    rootNodes.addAll(unlinkedComponents);

    return rootNodes;
  }

  static List<Node> filterTree(Map<String, dynamic> filterCriteria) {
    final nodes = filterCriteria['nodes'] as List<Node>;
    final query = filterCriteria['query'] as String?;
    final status = filterCriteria['status'] as NodeStatus?;
    final sensorType = filterCriteria['sensorType'] as NodeSensorType?;

    bool matchesFilterCriteria(Node node) {
      if (status != null && node.status != status) {
        return false;
      }
      if (sensorType != null && node.sensorType != sensorType) {
        return false;
      }
      if (query != null &&
          query.isNotEmpty &&
          !node.name.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    }

    Node? traverse(Node node) {
      bool isNodeFiltered = matchesFilterCriteria(node);
      List<Node> filteredChildren = [];

      for (final child in node.children) {
        final filteredChild = traverse(child);
        if (filteredChild != null) {
          filteredChildren.add(filteredChild);
          isNodeFiltered = true;
        }
      }

      if (isNodeFiltered) {
        return Node(
          id: node.id,
          name: node.name,
          type: node.type,
          sensorType: node.sensorType,
          status: node.status,
          children: filteredChildren,
          parentId: node.parentId,
        );
      }

      return null;
    }

    List<Node> filteredNodes = [];

    for (final node in nodes) {
      final filteredNode = traverse(node);
      if (filteredNode != null) {
        filteredNodes.add(filteredNode);
      }
    }

    return filteredNodes;
  }

  Future<List<Node>> filterTreeData({
    required List<Node> nodes,
    String? query,
    NodeStatus? status,
    NodeSensorType? sensorType,
  }) async {
    // use isolate to compute the filtered tree

    final nodeMap = {
      'nodes': nodes,
      'query': query,
      'status': status,
      'sensorType': sensorType,
    };

    final filteredNodes = await compute(filterTree, nodeMap);

    return filteredNodes;
  }
}
