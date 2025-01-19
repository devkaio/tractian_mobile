import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tractian_mobile/src/presentation/cubits/company_cubit.dart';
import 'package:tractian_mobile/src/presentation/pages/assets_view.dart';

class CompanyView extends StatefulWidget {
  const CompanyView({super.key});

  static const routeName = '/';

  @override
  State<CompanyView> createState() => _CompanyViewState();
}

class _CompanyViewState extends State<CompanyView> {
  @override
  void initState() {
    super.initState();

    context.read<CompanyCubit>().fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Companies')),
      body: BlocBuilder<CompanyCubit, CompanyState>(
        builder: (context, state) {
          switch (state.status) {
            case CompanyStateStatus.loading:
              return Center(child: CircularProgressIndicator());
            case CompanyStateStatus.error:
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
                      onPressed: context.read<CompanyCubit>().fetchCompanies,
                      label: Text('Try again'),
                    ),
                  ],
                ),
              );
            case CompanyStateStatus.success:
              return ListView.builder(
                itemCount: state.companies.length,
                itemBuilder: (context, index) {
                  final company = state.companies[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 32,
                      ),
                      tileColor: Colors.blue,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      leading: Icon(
                        Icons.business,
                      ),
                      title: Text(company.name),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AssetsView.routeName,
                          arguments: company.id,
                        );
                      },
                    ),
                  );
                },
              );
            default:
              return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
