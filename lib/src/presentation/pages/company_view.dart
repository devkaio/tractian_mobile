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
          if (state is CompanyStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CompanyStateError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if (state is CompanyStateSuccess) {
            final companies = state.result;
            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
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
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
