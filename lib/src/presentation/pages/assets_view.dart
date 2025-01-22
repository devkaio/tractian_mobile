import 'package:bluecapped/bluecapped.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: BCTopAppbar(title: 'Assets'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          children: [
            BCTextField(onChanged: context.read<AssetCubit>().onTextQuery),
            Row(
              spacing: 8.0,
              children: [
                BlocSelector<AssetCubit, AssetState, bool>(
                  selector: (state) =>
                      state.activeFilter == ActiveFilter.energySensor,
                  builder: (context, active) => BCFilterButton.withIcon(
                    active: active,
                    onPressed:
                        context.read<AssetCubit>().onFilterByEnergySensorTapped,
                    icon: Icon(
                      Icons.bolt,
                      color: active ? Colors.white : Colors.grey,
                    ),
                    label: 'Sensor de Energia',
                  ),
                ),
                BlocSelector<AssetCubit, AssetState, bool>(
                  selector: (state) =>
                      state.activeFilter == ActiveFilter.criticState,
                  builder: (context, active) => BCFilterButton.withIcon(
                    active: active,
                    onPressed:
                        context.read<AssetCubit>().onFilterByCriticStateTapped,
                    icon: Icon(
                      Icons.info_outline,
                      color: active ? Colors.white : Colors.grey,
                    ),
                    label: 'Critico',
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<AssetCubit, AssetState>(
                builder: (context, state) {
                  switch (state.status) {
                    case AssetStateStatus.loading:
                      return Center(child: CircularProgressIndicator());
                    case AssetStateStatus.error:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                            ),
                            BCFilterButton.withIcon(
                              onPressed: () => context
                                  .read<AssetCubit>()
                                  .fetchAssetTree(widget.companyId),
                              icon: Icon(
                                Icons.refresh,
                                color: context.appColors.neutral.grey200,
                              ),
                              label: 'Try again',
                            ),
                          ],
                        ),
                      );
                    case AssetStateStatus.success:
                      final nodes = state.activeFilter != ActiveFilter.none
                          ? state.filteredNodes
                          : state.nodes;
                      if (nodes.isEmpty) {
                        return Center(
                            child: Text(
                                'Nenhum ativo encontrado. Tente outro filtro.'));
                      }
                      return TreeView(nodes: nodes);
                    default:
                      return Center(child: Text('No data'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
