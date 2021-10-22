import 'package:currency_converter/data/local/constants/db_constants.dart';
import 'package:currency_converter/models/currency/currency.dart';
import 'package:sembast/sembast.dart';

class CurrencyDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _currencyStore =
      intMapStoreFactory.store(DBConstants.CURRENCY_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  CurrencyDataSource(this._db);

  Future<List<Currency>> getAllCurrencies() async {
    List<Currency> currs = [];
    final finder = Finder(
        sortOrders: [SortOrder(DBConstants.CURRENCY_NAME_FIELD, false, false)]);

    final recordSnapshots =
        await _currencyStore.find(await _db, finder: finder);

    if (recordSnapshots.isNotEmpty) {
      currs = recordSnapshots
          .map((snapshot) => Currency.fromMap(snapshot.value))
          .toList();
    }
    return currs;
  }

  Future<Currency> getCurrencyById(String? s) async {
    return Currency.defaultCurrency;
  }
}
