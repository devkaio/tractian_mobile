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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Assets'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                filled: true,
                hintText: 'Buscar Ativo ou Local',
                prefixIcon: Icon(Icons.search),
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
            Flexible(
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
                            // TODO: update with DS button
                            ElevatedButton.icon(
                              onPressed: () => context
                                  .read<AssetCubit>()
                                  .fetchAssetTree(widget.companyId),
                              label: Text('Try again'),
                            ),
                          ],
                        ),
                      );
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
      ),
    );
  }
}
