import 'package:flutter/material.dart';
import 'package:tractian_mobile/src/domain/entities/asset.dart';
import 'package:tractian_mobile/src/domain/entities/location.dart';

import 'asset_tree_widget.dart';

class LocationTreeWidget extends StatelessWidget {
  final Location location;
  final List<Location> locations;
  final List<Asset> assets;
  final int level;

  const LocationTreeWidget({
    super.key,
    required this.location,
    required this.locations,
    required this.assets,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    final subLocations =
        locations.where((loc) => loc.parentId == location.id).toList();

    final assetSubLocations =
        assets.where((asset) => asset.locationId == location.id).toList();

    final children = [
      ...assetSubLocations.map(
        (asset) => AssetTreeWidget(
          asset: asset,
          assets: assets,
          level: level + 1,
        ),
      ),
      ...subLocations.map(
        (childLocation) => LocationTreeWidget(
          location: childLocation,
          locations: locations,
          assets: assets,
          level: level + 1,
        ),
      ),
    ];

    if (children.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: level * 16.0),
        child: ExpansionTile(
          key: PageStorageKey<Location>(location),
          leading: children.isNotEmpty && children.first is AssetTreeWidget
              ? Icon(Icons.devices_other_outlined)
              : Icon(Icons.location_on_outlined),
          title: Text(location.name),
          children: children,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: level * 16.0),
        child: ListTile(
          leading: Icon(Icons.pin_drop_outlined),
          title: Text(location.name),
        ),
      );
    }
  }
}
