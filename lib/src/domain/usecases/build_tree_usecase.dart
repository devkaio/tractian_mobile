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

    // Create nodes for locations
    for (final location in locations) {
      nodeMap[location.id] = Node(
        id: location.id,
        name: location.name,
        type: NodeType.location,
        parentId: location.parentId,
      );
    }

    // Create nodes for assets
    for (final asset in assets) {
      nodeMap[asset.id] = Node(
        id: asset.id,
        name: asset.name,
        type: NodeType.asset,
        parentId: asset.parentId,
        locationId: asset.locationId,
        sensorType: asset.sensorType,
        status: asset.status,
      );
    }

    // Create nodes for components
    for (final component in components) {
      nodeMap[component.id] = Node(
        id: component.id,
        name: component.name,
        type: NodeType.component,
        parentId: component.parentId,
        locationId: component.locationId,
        sensorType: component.sensorType,
        status: component.status,
      );
    }

    // Helper function to build the tree recursively
    Node? buildTreeRecursive(Node node) {
      final children = <Node>[];
      for (var childNode in nodeMap.values) {
        if (childNode.parentId == node.id || childNode.locationId == node.id) {
          final child = buildTreeRecursive(childNode);
          if (child != null) {
            children.add(child);
          }
        }
      }
      return node.copyWith(children: children.isEmpty ? null : children);
    }

    // Build the root nodes
    final rootNodes = <Node>[];
    for (var node in nodeMap.values) {
      if (node.parentId == null && node.locationId == null) {
        final rootNode = buildTreeRecursive(node);
        if (rootNode != null) {
          rootNodes.add(rootNode);
        }
      }
    }

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
}
