import 'package:bluecapped/bluecapped.dart';
import 'package:flutter/material.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';

class TreeView extends StatelessWidget {
  final List<Node> nodes;
  final void Function(Node node) onNodeTap;

  const TreeView({
    super.key,
    required this.nodes,
    required this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    final flatNodes = nodes.flattenTree();
    return ListView.builder(
      itemCount: flatNodes.length,
      itemBuilder: (context, index) {
        final flat = flatNodes[index];
        return Padding(
          padding: EdgeInsets.only(left: flat.depth * 24.0),
          child: TreeTileWidget(
            key: ValueKey(flat.node.id),
            node: flat.node,
            level: flat.depth,
            index: index,
            onToggle: onNodeTap,
          ),
        );
      },
    );
  }
}

class TreeTileWidget extends StatelessWidget {
  const TreeTileWidget({
    super.key,
    required this.node,
    required this.level,
    required this.index,
    required this.onToggle,
  });

  final Node node;
  final int level;
  final int index;
  final void Function(Node node) onToggle;

  Icon get _leadinIcon => switch (node.type) {
        NodeType.location => Icon(BlueCappedIcons.location),
        NodeType.asset => Icon(BlueCappedIcons.asset),
        NodeType.component => Icon(BlueCappedIcons.component),
        _ => Icon(Icons.error),
      };

  Widget get _statusIcon {
    if (node.sensorType == null) return const SizedBox.shrink();

    return switch (node.status) {
      NodeStatus.operating => Icon(
          Icons.bolt,
          color: Colors.amber,
        ),
      NodeStatus.alert => Icon(
          Icons.circle,
          size: 8.0,
          color: Colors.red,
        ),
      _ => SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: node.children.isEmpty
              ? null
              : () => onToggle(node),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                if (node.children.isNotEmpty)
                  Icon(
                    node.expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: context.appColors.ui.platformHeader,
                  ),
                if (node.children.isEmpty) const SizedBox(width: 24.0),
                _leadinIcon,
                Flexible(
                    child: Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    node.name,
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: _statusIcon,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
