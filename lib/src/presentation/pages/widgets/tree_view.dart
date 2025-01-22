import 'package:bluecapped/bluecapped.dart';
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
        return TreeTileWidget(
          key: ValueKey(node.id),
          node: node,
          level: 0,
          index: index,
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
  });

  final Node node;
  final int level;
  final int index;

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
              : () {
                  node.updateExpansionStatus(!node.expanded);
                  (context as Element).markNeedsBuild();
                },
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
        if (node.expanded)
          for (final child in node.children)
            Padding(
              padding: EdgeInsets.only(left: 24),
              child: TreeTileWidget(
                node: child,
                level: level + 1,
                index: index,
              ),
            ),
      ],
    );
  }
}
