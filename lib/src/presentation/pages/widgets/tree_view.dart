import 'package:flutter/material.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';

class TreeView extends StatelessWidget {
  final List<Node> nodes;

  const TreeView({
    super.key,
    required this.nodes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        return TreeTileWidget(node: node, level: 0);
      },
    );
  }
}

class TreeTileWidget extends StatelessWidget {
  const TreeTileWidget({
    super.key,
    required this.node,
    required this.level,
  });

  final Node node;
  final int level;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(left: level * 16.0);

    if (node.children != null && node.children!.isNotEmpty) {
      return Padding(
        padding: padding,
        child: ExpansionTile(
          leading: switch (node.type) {
            NodeType.component => Icon(Icons.sensor_door),
            NodeType.location => Icon(Icons.location_city),
            NodeType.asset => Icon(Icons.sensor_window),
          },
          title: Text(node.name),
          children: node.children!
              .map((e) => TreeTileWidget(node: e, level: level + 1))
              .toList(),
        ),
      );
    } else {
      return Padding(
        padding: padding,
        child: ListTile(
          title: Text(node.name),
          leading: switch (node.type) {
            NodeType.component => Icon(Icons.sensor_door),
            NodeType.location => Icon(Icons.location_city),
            NodeType.asset => Icon(Icons.sensor_window),
          },
        ),
      );
    }
  }
}
