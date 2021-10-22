import 'package:currency_converter/data/network/apis/currency/currency_api.dart';
import 'package:currency_converter/data/network/constants/endpoints.dart';
import 'package:currency_converter/data/network/dio_client.dart';
import 'package:currency_converter/data/sharedpref/shared_preference_helper.dart';
import 'package:currency_converter/di/modules/preference_module.dart';
import 'package:dio/dio.dart';

class NetworkModule extends PreferenceModule {
  // ignore: non_constant_identifier_names
  final String TAG = "NetworkModule";

  // DI Providers:--------------------------------------------------------------
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.

  Dio provideDio(SharedPreferenceHelper sharedPrefHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrlApiUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          // // getting shared pref instance
          // var prefs = await SharedPreferences.getInstance();
          // await prefs.reload();

          // // getting token
          // var token = prefs.getString(Preferences.auth_token);

          // if (token != null) {
          //   options.headers
          //       .putIfAbsent('Authorization', () => "Bearer " + token);
          // } else {
          //   print('Auth token is null');
          // }
          return handler.next(options);
        },
        onError: ((DioError error, ErrorInterceptorHandler handler) async {
          return handler.next(error);

          // if (error.response?.statusCode == 401) {
          //   final prefs = await SharedPreferences.getInstance();
          //   final refreshToken = prefs.getString(Preferences.refresh_token);

          //   if (refreshToken != null) {
          //     RequestOptions options = error.response!.requestOptions;

          //     final res = await dio.post(Endpoints.refreshTokens,
          //         data: {"refreshToken": refreshToken});

          //     dio.interceptors.requestLock.lock();
          //     dio.interceptors.responseLock.lock();

          //     if (res.statusCode == 200) {
          //       final token = res.data["access"]["token"];
          //       final refresh = res.data["refresh"]["token"];

          //       await prefs.setString(Preferences.auth_token, token);
          //       await prefs.setString(Preferences.refresh_token, refresh);

          //       options.headers["Authorization"] = "Bearer " + token;

          //       dio.interceptors.requestLock.unlock();
          //       dio.interceptors.responseLock.unlock();

          //       Options opt = Options(
          //           contentType: options.contentType,
          //           headers: options.headers,
          //           method: options.method,
          //           sendTimeout: options.sendTimeout,
          //           receiveTimeout: options.receiveTimeout);
          //       var a = await dio.request(options.path,
          //           options: opt,
          //           data: options.data,
          //           queryParameters: options.queryParameters);
          //           handler.resolve(a);
          //       // return handler.next(DioError(requestOptions: options));
          //     }
          //   }
          //   dio.interceptors.requestLock.unlock();
          //   dio.interceptors.responseLock.unlock();

          //   return handler.next(error);
          // } else {
          //   dio.interceptors.requestLock.unlock();
          //   dio.interceptors.responseLock.unlock();

          //   return handler.next(error);
          // }
        }),
      ));

    return dio;
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.

  DioClient provideDioClient(Dio dio) => DioClient(dio);

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.

  // Api Providers:-------------------------------------------------------------
  // Define all your api providers here
  /// A singleton post_api provider.
  ///
  /// Calling it multiple times will return the same instance.

  CurrencyApi provideUsersApi(DioClient dioClient) => CurrencyApi(dioClient);
// Api Providers End:---------------------------------------------------------

}
