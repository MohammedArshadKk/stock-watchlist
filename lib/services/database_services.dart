import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:stock/model/company_model.dart';

late Database _db;

class DatabaseServices {
  List<Company> watchlist = [];
  Future<void> initDatabase() async {
    try {
      _db = await openDatabase(
        'watchlistDb.db',
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE watchlistDb(id INTEGER PRIMARY KEY , symbol TEXT , name TEXT ,region TEXT, open TEXT,close TEXT)');
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  addData(Company company) async {
    try {
      await _db.rawInsert(
          'INSERT INTO watchlistDb(symbol,name,region,open,close) VALUES(?,?,?,?,?)',
          [
            company.symbol,
            company.name,
            company.region,
            company.open,
            company.close
          ]);
      log('added');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Company>> getWatchlist() async {
    try {
      watchlist.clear();
      final data = await _db.rawQuery('SELECT * FROM watchlistDb');
      watchlist = data.map((company) {
        return Company.databaseFromMap(company as Map<String, dynamic>);
      }).toList();
      log(data.toString());
      return watchlist;
    } catch (e) {
      log(e.toString());
    }
    return watchlist;
  }

 Future<void> delete(int id) async {
  try {
    await _db.rawDelete('DELETE FROM watchlistDb WHERE id = ?', [id]);
    log('Deleted entry with id: $id');
  } catch (e) {
    log(e.toString());
  }
}

}
