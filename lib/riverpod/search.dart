import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock/model/company_model.dart';
import 'package:stock/services/api_services.dart';

final apiServiceProvider = Provider((ref) => ApiServices());

final searchCompanyProvider =
    FutureProvider.family<List<Company>, String>((ref, searchText) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.searchStock(searchText);
});
