import 'package:flutter/material.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';

class AssetTreeWidget extends StatelessWidget {
  final Asset asset;
  final List<Asset> assets;
  final int level;

  const AssetTreeWidget({
    super.key,
    required this.asset,
    required this.assets,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final childAssets =
        assets.where((child) => child.parentId == asset.id).toList();

    if (childAssets.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: level * 16.0),
        child: ExpansionTile(
          title: Row(
            children: [
              const Icon(Icons.device_hub),
              const SizedBox(width: 8),
              Text(asset.name),
            ],
          ),
          children: childAssets
              .map(
                (childAsset) => AssetTreeWidget(
                  asset: childAsset,
                  assets: assets,
                  level: level + 1,
                ),
              )
              .toList(),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: level * 16.0),
        child: ListTile(
          title: Row(
            children: [
              const Icon(Icons.device_hub),
              const SizedBox(width: 8),
              Text(asset.name),
            ],
          ),
        ),
      );
    }
  }
}
