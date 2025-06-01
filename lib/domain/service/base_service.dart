import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../print_log_format.dart';
import '../core/encryptor/aes_encrypt.dart';
import '../core/interfaces/log_json_format.dart';
import 'api_secure.dart';
import 'auth_storage.dart';
import 'interceptor.dart';

class BaseService {
  final Dio _dio;
  final AuthStorage _authStorage;

  // // NOTE: live key
  final String _rsaPK =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqY/uwNlFBElLTrgDtfI2MfZlBDvGWBheFodGWcdVBtnOCDppLMMM/JooospSp/EarcMYZnt/D0Hctctxtix4QrVHifA39SJi2JtpJ4K76/3psKY5hnM9zf7i7pTvo+z67FyXjSYTa51gY76jz9wjtrPvjedz2+3w4Ri8Ix2K+/uR73SaS5xN1E2uGPhQ7LULz7CBv0KWJz0YYi+GnsbiqNOHKK6Sult1+Pn6fO6Y+mb8C/t5TIxUNzQ0XQNcL3xF0Kb6fechsrgkTunKSUUYLgFas+f1+SGUjJjN8G+iS5YN38fq78b0A6ul5Sins13XneponRjfMy//nX8d60jAaQIDAQAB";

  // // NOTE: uat key
  // // final String _rsaPK =
  // //     "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoMGngEFhIUPs9ZgusEbFxragyq5Zbr+abAzWsTXpk7GkxzWT3A/vv/3a3OlupYaB36RtFcITt+pCKJwlcISWbxOT4XYhXtFFCCD9MKS7c0/2cnWHfzeZqDbq3frtYTFoIigFUk1rn73PO12dz4q8tIZ6a+EVSzNatmPdkB9mNTiy5ZF6Qjcyf85Aglhx8VgmmiGhUct53dsZr5Ze+nBuPra/xBEg+LwjLYlj2kmqreCjxkIFTGbp+50w0s7mLbwHZuFLdQnumZu8hFyiJv2XRtq/ndPeI8mwky5lxeveucKuZYlcKOk/ZOomu5QlzpP1UvfjvTDJdur5Pb9kJdeZ7QIDAQAB";

  BaseService()
      : _dio = Dio()..interceptors.add(RequestInterceptors()),
        _authStorage = AuthStorage();

  Future<void> loadAuthHeader() async {
    try {
      Map<String, String> userInfo = await _authStorage.getUserInfo();
      String token = userInfo['accessToken'] ?? '';

      if (token.isNotEmpty) {
        _dio.options.headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
      } else {
        log("TOKEN IS EMPTY");
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<Either<String, T>> trySecureEitherPost<T>(
    String url,
    bool isDynamicRSA, {
    required String name,
    Object? reqBody,
    Map<String, dynamic>? queryParameters,
    bool isEncrypt = false,
    Map<String, String>? headers,
  }) async {
    try {
      dynamic key;
      dynamic rsaPublicKey;
      if (isEncrypt) {
        key = AESEncryption().generateBase64Key();

        rsaPublicKey =
            isDynamicRSA ? await _authStorage.getRSAPublicKey() : _rsaPK;
      }

      var result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        return const Left('NO_CONNECTION');
      }

      final response = await _dio.post(
        url,
        data: isEncrypt
            ? await APISecure.reqBodyEncrypted(
                key ?? '',
                reqBody,
                rsaPublicKey ?? '',
              )
            : reqBody,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (_) => true,
          headers: headers ?? _dio.options.headers,
        ),
      );

      printLogFormat(name);
      if (isEncrypt) log(key, name: '$name key');

      logJson(reqBody, name: "$name req");

      if (response.statusCode == 401) {
        // LoginController().logOut();
        return const Left('401_TOKEN_EPX');
      }

      if (response.statusCode == 403) {
        return const Left('403_BAD_SERVICE');
      }

      Map<String, dynamic> res;

      if (isEncrypt) {
        res = await APISecure.resBodyDecrypted(key, response, name: name);

        logJson(response.requestOptions.headers, name: "Header");
        logJson(response.requestOptions.data, name: "Encryption Header");
      } else {
        // Assume normal JSON response body
        if (response.data is Map<String, dynamic>) {
          res = response.data;

          logJson(response.data, name: '$name response');
        } else {
          // Try to parse the response into Map if it's a String
          try {
            res = Map<String, dynamic>.from(response.data);
          } catch (_) {
            log("Response format is invalid or not JSON", name: "Error");
            return const Left('Invalid response format');
          }
        }
      }

      // var res = await APISecure.resBodyDecrypted(key, response, name: name);

      if (res.containsKey('code')) {
        if (res['code'] == '0' || res['code'] == '1' || res['code'] == '3') {
          return Right(res as T);
        } else if (res['code'] == 401) {
          // LoginController().logOut();
          return const Left('401_TOKEN_EPX');
        } else if (res['code'] == 403) {
          return const Left('403_BAD_SERVICE');
        }
      }

      // Log the response to check if it was in an unexpected format
      log('Unexpected response format: $res', name: 'Error');

      return const Left('Invalid response format');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return const Left('Connection timed out. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        return const Left(
            'Cannot connect to server. Check your network or server address.');
      } else if (e.type == DioExceptionType.badResponse) {
        return const Left('Received invalid response from server.');
      } else {
        return Left('Network error: ${e.message}');
      }
    } catch (error) {
      return Left('$error');
    }
  }

  getConnection(callData) async {
    final hasConnection = await InternetConnection().hasInternetAccess;
    if (hasConnection == true) {
      callData;
    }
  }
}
