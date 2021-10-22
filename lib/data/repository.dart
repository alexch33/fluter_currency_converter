import 'dart:async';
import 'package:currency_converter/data/local/datasources/currency/currency_datasource.dart';
import 'package:currency_converter/data/network/apis/currency/currency_api.dart';
import 'package:currency_converter/data/sharedpref/shared_preference_helper.dart';
import 'package:currency_converter/models/currency/currency.dart';

class Repository {
  List<Currency> _currencies = [];
  // data source object
  final CurrencyDataSource _currencyDataSource;

  // api objects
  final CurrencyApi _currencyApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(
    this._currencyApi,
    this._sharedPrefsHelper,
    this._currencyDataSource,
  );

  Future<List<Currency>> getListOfCurrencies() async {
    _currencies = await _currencyDataSource.getAllCurrencies();
    if (_currencies.isEmpty) {
      _currencies = await _currencyApi.fetchListOfCurriencies();
    }

    return _currencies;
  }

  Future<Map<Currency, double>> convertFromTo(
      Map<Currency, Currency> currensiecMap) async {
    Map<Currency, double> result = {};

    Map<String, double> idCurrencyMap =
        await _currencyApi.convertFromTo(currensiecMap);
    idCurrencyMap.entries.forEach((element) {
      Currency currency = _currencies.firstWhere((el) => el.id == element.key);
      result[currency] = element.value;
    });
    return result;
  }

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  Future<bool> get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  Future<String?> get currentLanguage => _sharedPrefsHelper.currentLanguage;

  Future<Currency> getSelectedCurrency() async {
    return _currencyDataSource
        .getCurrencyById(await _sharedPrefsHelper.selectedCurrencyId());
  }
}
