import 'package:flutter/material.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';

import 'location_tree_widget.dart';

class AssetTreeView extends StatelessWidget {
  final List<Location> locations;
  final List<Asset> assets;

  const AssetTreeView({
    super.key,
    required this.locations,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return LocationTreeWidget(
          location: location,
          locations: locations,
          assets: assets,
        );
      },
    );
  }
}
