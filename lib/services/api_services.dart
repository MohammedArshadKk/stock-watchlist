import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock/model/company_model.dart';

class ApiServices {
  final api = dotenv.env['API_KEY'];
  final Dio dio = Dio();
  //search Company
  Future<List<Company>> searchStock(String searchText) async {
    final String url =
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$searchText&apikey=$api';

    try {
      if (searchText.isNotEmpty) {
        final response = await dio.get(url);
        log(response.statusCode.toString());
        if (response.statusCode == 200) {
          final data = response.data;
          if (data.containsKey('bestMatches')) {
            return List<Company>.from(
              data['bestMatches'].map((item) => Company.fromMap(item)),
            );
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<String> getPrice(String symbol) async {
    try {
      final String url =
          'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$api';
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final timeSeries = response.data['Time Series (Daily)'];
        final latestDate = timeSeries.keys.first;
        final latestData = timeSeries[latestDate];
        final latestClose = latestData['4. close'];
        final latestOpen = latestData["1. open"];
        log('$latestClose&$latestOpen');
        return '$latestClose&$latestOpen';
      }
    } catch (e) {
      log(e.toString());
    }
    return '';
  }
}
