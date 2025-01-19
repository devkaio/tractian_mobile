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
        NodeType.location => Icon(Icons.location_on_outlined),
        NodeType.asset => Icon(Icons.token),
        NodeType.component => Icon(Icons.token_outlined),
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
              if (node.status == ActiveFilter.energySensor.name)
                Icon(Icons.bolt),
              if (node.status == ActiveFilter.criticState.name)
                Icon(Icons.warning),
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
            if (node.status == 'operating')
              Icon(
                Icons.bolt,
                color: Colors.amber,
              ),
            if (node.status == 'alert')
              SizedBox.square(
                dimension: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
}
