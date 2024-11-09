import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock/model/company_model.dart';
import 'package:stock/riverpod/search.dart';
import 'package:stock/services/api_services.dart';
import 'package:stock/services/database_services.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final DatabaseServices databaseServices = DatabaseServices();
  final ApiServices apiServices = ApiServices();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 5), () {
      setState(() {
        _searchText = query.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(searchCompanyProvider(_searchText));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Search'),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  labelText: 'Search...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: searchResult.when(
              data: (companies) => companies.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        final company = companies[index];
                        return ListTile(
                          title: Text(company.name),
                          subtitle: Text(company.symbol),
                          trailing: IconButton(
                              onPressed: () async {
                                final String price =
                                    await apiServices.getPrice(company.symbol);
                                if (price.isNotEmpty) {
                                  List<String> prices = price.split('&');
                                  String close = prices[0];
                                  String open = prices[1];
                                  log(close);
                                  log(open);
                                  final selectedCompany = Company(
                                      symbol: company.symbol,
                                      name: company.name,
                                      region: company.region,
                                      open: open,
                                      close: close);
                                  databaseServices.addData(selectedCompany);
                                } else {
                                  log('price is null');
                                }
                              },
                              icon: const Icon(Icons.add)),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
