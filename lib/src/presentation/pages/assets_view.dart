import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';

import 'widgets/asset_tree_view.dart';

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
      body: BlocBuilder<AssetCubit, AssetState>(
        builder: (context, state) {
          if (state is AssetStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AssetStateError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is AssetStateSuccess) {
            return AssetTreeView(
              locations: state.locations,
              assets: state.assets,
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
