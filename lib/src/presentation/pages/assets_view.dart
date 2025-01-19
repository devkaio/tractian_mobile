import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';

import 'widgets/tree_view.dart';

class AssetsView extends StatefulWidget {
  final String companyId;

  const AssetsView({super.key, required this.companyId});

  static const routeName = '/assets';

  @override
  State<AssetsView> createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {
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
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar Ativo ou Local',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (query) {
              context.read<AssetCubit>().filterByText(query: query);
            },
          ),
          Row(
            spacing: 16.0,
            children: [
              BlocSelector<AssetCubit, AssetState, bool>(
                selector: (state) =>
                    state.activeFilter == ActiveFilter.energySensor,
                builder: (context, active) => ElevatedButton.icon(
                  icon: Icon(
                    Icons.bolt,
                    color: active ? Colors.white : Colors.grey,
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: active ? Colors.blue : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: active ? Colors.transparent : Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    foregroundColor: active ? Colors.white : null,
                  ),
                  onPressed:
                      context.read<AssetCubit>().onFilterByEnergySensorTapped,
                  label: Text(
                    'Sensor de Energia',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: active ? Colors.white : Colors.grey,
                        ),
                  ),
                ),
              ),
              BlocSelector<AssetCubit, AssetState, bool>(
                  selector: (state) =>
                      state.activeFilter == ActiveFilter.criticState,
                  builder: (context, active) {
                    return ElevatedButton.icon(
                      icon: Icon(
                        Icons.info_outline,
                        color: active ? Colors.white : Colors.grey,
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor:
                            active ? Colors.blue : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: active ? Colors.transparent : Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        foregroundColor: active ? Colors.white : null,
                      ),
                      onPressed: context
                          .read<AssetCubit>()
                          .onFilterByCriticStateTapped,
                      label: Text(
                        'Critico',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: active ? Colors.white : Colors.grey,
                            ),
                      ),
                    );
                  }),
            ],
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
                    return TreeView(
                      nodes: state.nodes,
                    );
                  case AssetStateStatus.filtered:
                    return TreeView(
                      nodes: state.filteredNodes,
                    );
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
