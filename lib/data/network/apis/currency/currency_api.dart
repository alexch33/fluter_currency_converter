import 'package:currency_converter/constants/strings.dart';
import 'package:currency_converter/data/network/constants/endpoints.dart';
import 'package:currency_converter/data/network/dio_client.dart';
import 'package:currency_converter/models/currency/currency.dart';

class CurrencyApi {
  // dio instance
  static const List<String> currsIds = ['USD', 'EUR', "RUB"];
  final DioClient _dioClient;

  // injecting dio instance
  CurrencyApi(this._dioClient);

  Future<List<Currency>> fetchListOfCurriencies() async {
    List<Currency> result = [];
    String querry =
        '${Endpoints.baseUrlApiUrl}/api/v7/currencies?apiKey=${Strings.apiKey}';

    final response = await _dioClient.get(querry);

    for (final key in response["results"].keys) {
      final json = response["results"][key];
      Currency currency = Currency.fromMap(json);
      if (currsIds.indexOf(currency.id) >= 0) {
        result.add(currency);
      }
    }

    return result;
  }

  Future<Map<String, double>> convertFromTo(
      Map<Currency, Currency> currensiecMap) async {
    String constructedQuerry = '';
    Map<String, double> result = {};
    currensiecMap.forEach((key, value) {
      constructedQuerry += '${value.id}_${key.id},';
    });
    constructedQuerry =
        constructedQuerry.substring(0, constructedQuerry.length - 1);
    String querry =
        '${Endpoints.baseUrlApiUrl}/api/v7/convert?q=$constructedQuerry&compact=ultra&apiKey=${Strings.apiKey}';

    final response = await _dioClient.get(querry);

    for (final key in response.keys) {
      String id = key.toString().split('_').last;
      result[id] = response[key];
    }
    return result;
  }
}
