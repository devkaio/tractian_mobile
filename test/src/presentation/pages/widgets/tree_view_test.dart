import 'package:bluecapped/bluecapped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian_mobile/src/domain/entities/node.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';
import 'package:tractian_mobile/src/presentation/pages/widgets/tree_view.dart';

import '../../../domain/domain_mocks.dart';

void main() {
  group('TreeView Widget Tests', () {
    late List<Node> nodes;
    late AssetCubit assetCubit;
    late MockBuildTreeUseCase mockBuildTreeUseCase;

    setUp(() {
      nodes = [
        Node(
          id: '1',
          name: 'Node 1',
          type: NodeType.location,
          status: NodeStatus.operating,
          children: [
            Node(
              id: '1-1',
              name: 'Node 1-1',
              type: NodeType.asset,
              sensorType: NodeSensorType.energy,
              status: NodeStatus.alert,
              children: [],
            ),
          ],
        ),
        Node(
          id: '2',
          name: 'Node 2',
          type: NodeType.component,
          status: NodeStatus.operating,
          sensorType: NodeSensorType.energy,
          children: [],
        ),
      ];

      mockBuildTreeUseCase = MockBuildTreeUseCase();

      assetCubit = AssetCubit(mockBuildTreeUseCase);
    });

    testWidgets('TreeView displays nodes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BlueCappedTheme().light,
          darkTheme: BlueCappedTheme().dark,
          home: Scaffold(
            body: BlocProvider(
              create: (_) => assetCubit,
              child: TreeView(
                nodes: nodes,
                onNodeTap: assetCubit.onExpandedToggled,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Node 1'), findsOneWidget);
      expect(find.text('Node 2'), findsOneWidget);
      expect(find.byIcon(BlueCappedIcons.location), findsOneWidget);
      expect(find.byIcon(BlueCappedIcons.component), findsOneWidget);
    });

    testWidgets('TreeTileWidget expands and collapses correctly', (WidgetTester tester) async {
      assetCubit.emit(assetCubit.state.copyWith(nodes: nodes));

      await tester.pumpWidget(
        MaterialApp(
          theme: BlueCappedTheme().light,
          darkTheme: BlueCappedTheme().dark,
          home: Scaffold(
            body: BlocProvider(
              create: (_) => assetCubit,
              child: BlocBuilder<AssetCubit, AssetState>(
                builder: (context, state) => TreeView(
                  nodes: state.nodes,
                  onNodeTap: assetCubit.onExpandedToggled,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Node 1-1'), findsNothing);

      await tester.tap(find.text('Node 1'));
      await tester.pumpAndSettle(Durations.extralong4);

      expect(find.text('Node 1-1'), findsOneWidget);

      await tester.tap(find.text('Node 1'));
      await tester.pumpAndSettle(Durations.extralong4);

      expect(find.text('Node 1-1'), findsNothing);
    });

    testWidgets('TreeTileWidget displays status icons correctly', (WidgetTester tester) async {
      assetCubit.emit(assetCubit.state.copyWith(nodes: nodes));

      await tester.pumpWidget(
        MaterialApp(
          theme: BlueCappedTheme().light,
          darkTheme: BlueCappedTheme().dark,
          home: Scaffold(
            body: BlocProvider(
              create: (_) => assetCubit,
              child: BlocBuilder<AssetCubit, AssetState>(
                builder: (context, state) => TreeView(
                  nodes: state.nodes,
                  onNodeTap: assetCubit.onExpandedToggled,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.bolt), findsNWidgets(1));
      expect(find.byIcon(Icons.circle), findsNothing);

      await tester.tap(find.text('Node 1'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.circle), findsOneWidget);
    });
  });
}
