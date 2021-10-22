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
  double toValueCurr = 0.0;

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

  @observable
  double quantity = 0.0;

  // constructor:---------------------------------------------------------------
  _CurrencyStore(this._repository);

  Future initialize() async {
    try {
      currencies = await _repository.getListOfCurrencies();
      selectedFrom = await _repository.getSelectedCurrency();
      selectedTo = await _repository.getSelectedTo() ??
          currencies.where((element) => element.id != selectedFrom.id).first;

      Map<Currency, Currency> currenciesMap = _getCurriwnciesMap();
      converted = await _repository.convertFromTo(currenciesMap);
      convertVal();
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

    if (selectedTo.id == id) {
      setSelectedToById(
          currencies.where((element) => element.id != id).first.id);
    }
    isLoading = true;

    selectedFrom = currencies.firstWhere((element) => element.id == id);
    converted = await _repository.convertFromTo(_getCurriwnciesMap());

    convertVal();

    isLoading = false;
  }

  @action
  setSelectedToById(String? id) async {
    if (id == null) {
      return;
    }
    if (selectedTo.id == id) {
      await setSelectedFromById(
          currencies.where((element) => element.id != id).first.id);
    }
    selectedTo = currencies.firstWhere((element) => element.id == id);

    convertVal();
  }

  convertVal() {
    double convertCoef = converted[selectedTo] ?? 0.0;

    toValueCurr = this.quantity * convertCoef;
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
