import 'package:currency_converter/models/currency/currency.dart';
import 'package:currency_converter/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

import '../../data/repository.dart';

part 'currency_store.g.dart';

class CurrencyStore = _CurrencyStore with _$CurrencyStore;

abstract class _CurrencyStore with Store {
  // repository instance
  final Repository _repository;

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  @observable
  List<Currency> currencies = [];

  @observable
  Map<Currency, double> converted = {};

  @observable
  Currency selectedFrom = Currency.defaultCurrency;

  @observable
  Currency selectedTo = Currency.defaultCurrency;

  @observable
  bool isLoading = true;

  // constructor:---------------------------------------------------------------
  _CurrencyStore(this._repository);

  Future initialize() async {
    try {
      currencies = await _repository.getListOfCurrencies();
      selectedFrom = await _repository.getSelectedCurrency();

      Map<Currency, Currency> currenciesMap = _getCurriwnciesMap();
      currencies.forEach((currency) {
        if (currency.id != selectedFrom.id) {
          currenciesMap[currency] = selectedFrom;
        }
      });
      converted = await _repository.convertFromTo(currenciesMap);
    } catch (error) {
      errorStore.errorMessage = error.toString();
    }

    isLoading = false;
  }

  @action
  setSelectedFromById(String? id) async {
    if (id == null) {
      return;
    }
    isLoading = true;
    selectedFrom = currencies.firstWhere((element) => element.id == id);
    converted = await _repository.convertFromTo(_getCurriwnciesMap());

    isLoading = false;
  }

  @action
  setSelectedToById(String? id) {
    if (id == null) {
      return;
    }
    selectedTo = currencies.firstWhere((element) => element.id == id);
  }

  Map<Currency, Currency> _getCurriwnciesMap() {
    Map<Currency, Currency> currenciesMap = {};
    currencies.forEach((currency) {
      if (currency.id != selectedFrom.id) {
        currenciesMap[currency] = selectedFrom;
      }
    });
    return currenciesMap;
  }
}
