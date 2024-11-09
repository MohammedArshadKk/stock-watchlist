import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock/services/database_services.dart';
import 'package:stock/model/company_model.dart';

class Watchlist extends StatefulWidget {
  Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  final DatabaseServices databaseServices = DatabaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: FutureBuilder<List<Company>>(
        future: databaseServices.getWatchlist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final watchlist = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final company = watchlist[index];
                log(company.id.toString());
                return ListTile(
                  onLongPress: () {
                    databaseServices.delete(company.id!);
                    setState(() {});
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        double.parse(company.close) < double.parse(company.open)
                            ? Colors.red
                            : Colors.green,
                    child: Center(
                      child: Text(company.symbol[0].toUpperCase()),
                    ),
                  ),
                  title: Text(company.name),
                  subtitle: Text(company.region),
                  trailing: Text(
                    company.close,
                    style: TextStyle(
                      fontSize: 20,
                      color: double.parse(company.close) <
                              double.parse(company.open)
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: watchlist.length,
            ),
          );
        },
      ),
    );
  }
}
