import 'package:bluecapped/bluecapped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/data/api/dio_client.dart';
import 'package:tractian_mobile/src/data/repositories/asset_repository_impl.dart';
import 'package:tractian_mobile/src/data/repositories/company_repository_impl.dart';
import 'package:tractian_mobile/src/data/repositories/location_repository_impl.dart';
import 'package:tractian_mobile/src/domain/repositories/asset_repository.dart';
import 'package:tractian_mobile/src/domain/repositories/company_repository.dart';
import 'package:tractian_mobile/src/domain/usecases/build_tree_usecase.dart';
import 'package:tractian_mobile/src/presentation/cubits/assets_cubit.dart';
import 'package:tractian_mobile/src/presentation/cubits/company_cubit.dart';
import 'package:tractian_mobile/src/presentation/pages/assets_view.dart';
import 'package:tractian_mobile/src/presentation/pages/company_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => DioClient()),
        RepositoryProvider<CompanyRepository>(
          create: (context) => CompanyRepositoryImpl(
            context.read(),
          ),
        ),
        RepositoryProvider<AssetRepository>(
          create: (context) => AssetRepositoryImpl(
            context.read(),
          ),
        ),
        RepositoryProvider(
          create: (context) => LocationRepositoryImpl(
            context.read(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CompanyCubit(context.read<CompanyRepository>())
              ..fetchCompanies(),
          ),
        ],
        child: AppWidget(),
      ),
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({
    super.key,
  });

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final ValueNotifier<bool> isDarkNotifier = ValueNotifier(false);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    isDarkNotifier.value =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isDarkNotifier,
        builder: (context, darkMode, child) {
          child = MaterialApp(
            title: 'Tractian Mobile',
            theme: BlueCappedTheme().light,
            darkTheme: BlueCappedTheme().dark,
            themeMode: ThemeMode.system,
            initialRoute: '/',
            routes: {
              CompanyView.routeName: (context) => CompanyView(),
              AssetsView.routeName: (context) {
                final companyId =
                    ModalRoute.of(context)?.settings.arguments as String;

                return BlocProvider(
                  create: (context) => AssetCubit(
                    BuildTreeUseCase(
                      assetRepository: context.read<AssetRepository>(),
                      locationRepository:
                          context.read<LocationRepositoryImpl>(),
                    ),
                  ),
                  child: AssetsView(companyId: companyId),
                );
              },
            },
          );

          return child;
        });
  }
}
