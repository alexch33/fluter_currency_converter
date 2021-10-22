import 'dart:async';

import 'package:currency_converter/data/local/constants/db_constants.dart';
import 'package:currency_converter/data/local/datasources/currency/currency_datasource.dart';
import 'package:currency_converter/data/network/apis/currency/currency_api.dart';
import 'package:currency_converter/data/repository.dart';
import 'package:currency_converter/data/sharedpref/shared_preference_helper.dart';
import 'package:currency_converter/utils/encryption/xxtea.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:currency_converter/di/modules/netwok_module.dart';

class LocalModule extends NetworkModule {
  // DI variables:--------------------------------------------------------------
  late Future<Database> database;

  // constructor
  // Note: Do not change the order in which providers are called, it might cause
  // some issues
  LocalModule() {
    database = provideDatabase();
  }

  // DI Providers:--------------------------------------------------------------
  /// A singleton database provider.
  ///
  /// Calling it multiple times will return the same instance.
 
  Future<Database> provideDatabase() async {
    // Key for encryption
    var encryptionKey = "";

    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, DBConstants.DB_NAME);

    // Check to see if encryption is set, then provide codec
    // else init normal db with path
    var database;
    if (encryptionKey.isNotEmpty) {
      // Initialize the encryption codec with a user password
      var codec = getXXTeaCodec(password: encryptionKey);
      database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    } else {
      database = await databaseFactoryIo.openDatabase(dbPath);
    }

    // Return database instance
    return database;
  }

  // DataSources:---------------------------------------------------------------
  // Define all your data sources here
  /// A singleton post dataSource provider.
  ///
  /// Calling it multiple times will return the same instance.

  CurrencyDataSource provideCurrencyDataSource() => CurrencyDataSource(database);


  // DataSources End:-----------------------------------------------------------

  /// A singleton repository provider.
  ///
  /// Calling it multiple times will return the same instance.

  Repository provideRepository(
    CurrencyApi currencyApi,
    CurrencyDataSource currencyDataSourceApi,
    SharedPreferenceHelper preferenceHelper,
  ) =>
      Repository(currencyApi, preferenceHelper, currencyDataSourceApi);
}
