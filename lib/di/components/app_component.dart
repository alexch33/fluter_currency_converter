import 'package:currency_converter/data/local/datasources/currency/currency_datasource.dart';
import 'package:currency_converter/data/network/apis/currency/currency_api.dart';
import 'package:currency_converter/data/network/dio_client.dart';
import 'package:currency_converter/data/repository.dart';
import 'package:currency_converter/data/sharedpref/shared_preference_helper.dart';
import 'package:currency_converter/di/modules/local_module.dart';
import 'package:currency_converter/di/modules/netwok_module.dart';
import 'package:currency_converter/di/modules/preference_module.dart';

/// The top level injector that stitches together multiple app features into
/// a complete app.
abstract class AppComponent {
  static Repository? _repository;
  static bool isInited = false;
  NetworkModule? networkModule;
  LocalModule? localModule;
  PreferenceModule? preferenceModule;

  static Repository? getReposInstance(NetworkModule networkModule,
      LocalModule localModule, PreferenceModule preferenceModule) {
    if (isInited) return _repository;

    SharedPreferenceHelper _sharedPreferenceHelper =
        networkModule.provideSharedPreferenceHelper();
    DioClient _dioClient = networkModule
        .provideDioClient(networkModule.provideDio(_sharedPreferenceHelper));

    CurrencyApi _currencyApi = CurrencyApi(_dioClient);

    CurrencyDataSource _currencyDataSource =
        CurrencyDataSource(localModule.provideDatabase());

    isInited = true;

    _repository =
        Repository(_currencyApi, _sharedPreferenceHelper, _currencyDataSource);

    return _repository;
  }
}
