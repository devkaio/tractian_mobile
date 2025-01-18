import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';

import 'widgets/tree_view.dart';

class AssetView extends StatefulWidget {
  final String companyId;

  const AssetView({super.key, required this.companyId});

  static const routeName = '/assets';

  @override
  State<AssetView> createState() => _AssetViewState();
}

class _AssetViewState extends State<AssetView> {
  @override
  void initState() {
    super.initState();

    context.read<AssetCubit>().fetchAssetTree(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assets')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 16.0,
            children: [
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sensor de Energia'),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Critico'),
                ),
              ),
            ],
          ),
          SearchBar(
            onChanged: (query) {
              context.read<AssetCubit>().filterByText(query: query);
            },
          ),
          Flexible(
            child: BlocBuilder<AssetCubit, AssetState>(
              builder: (context, state) {
                switch (state.status) {
                  case AssetStateStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case AssetStateStatus.error:
                    return Center(child: Text('Error: ${state.message}'));
                  case AssetStateStatus.success:
                    return TreeView(nodes: state.nodes);
                  case AssetStateStatus.filtered:
                    return TreeView(nodes: state.filteredNodes);
                  default:
                    return Center(child: Text('No data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
