import 'package:bluecapped/bluecapped.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';

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
      };

  Widget get _statusIcon => switch (node.status) {
        'operating' => Icon(
            Icons.bolt,
            color: Colors.amber,
          ),
        'alert' => Icon(
            Icons.circle,
            size: 8.0,
            color: Colors.red,
          ),
        _ => SizedBox.shrink(),
      };

  @override
  Widget build(BuildContext context) {
    if (node.children != null && node.children!.isNotEmpty) {
      return ListTileTheme(
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            context.read<AssetCubit>().onExpandedToggled(
                  nodeId: node.id,
                  isExpanded: expanded,
                );
          },
          controlAffinity: ListTileControlAffinity.trailing,
          showTrailingIcon: false,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocSelector<AssetCubit, AssetState, bool>(
                  selector: (state) => state.expandedNodeIds.contains(node.id),
                  builder: (context, state) {
                    return Icon(
                      state
                          ? Icons.keyboard_arrow_down_outlined
                          : Icons.keyboard_arrow_right_outlined,
                    );
                  }),
              Flexible(child: _leadinIcon),
              _statusIcon,
            ],
          ),
          shape: const OutlineInputBorder(borderSide: BorderSide.none),
          childrenPadding: const EdgeInsets.only(left: 16.0),
          key: PageStorageKey(node.id),
          title: Text(node.name),
          children: node.children!
              .mapIndexed((index, e) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: StreamBuilder<AssetState>(
                          stream: context.read<AssetCubit>().stream,
                          builder: (context, snapshot) {
                            return TreeTileWidget(
                              node: e,
                              level: level + 1,
                              index: index,
                            );
                          },
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
      );
    } else {
      return ListTile(
        leading: _leadinIcon,
        title: Row(
          spacing: 4.0,
          children: [
            Text(node.name),
            _statusIcon,
          ],
        ),
      );
    }
  }
}
