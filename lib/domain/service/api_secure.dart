// ignore_for_file: await_only_futures, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../core/encryptor/aes_encrypt.dart';
import '../core/encryptor/rsa_encrypt.dart';

class APISecure {
  static reqBodyEncrypted(
      String aesPrivateKey, Object? reqBody, String rsaPublicKey) async {
    var reqDataEncryptedAES = AESEncryption().encryptAES64(
      plainText: json.encode(reqBody),
      secretKeyBase64Text: aesPrivateKey,
    );

    final keyEncryptedRSA = await RSAEncryption().encryptRSA64(
      plainText: aesPrivateKey,
      publicKeyStr: rsaPublicKey,
    );

    Map<String, dynamic> reqBodyEncrypted = {
      "q": reqDataEncryptedAES, // AES-encrypted request body
      "m": keyEncryptedRSA, // RSA-encrypted AES secret key
    };

    return json.encode(reqBodyEncrypted);
  }

  static resBodyDecrypted(String key, Response<dynamic> response,
      {required String name}) async {
    var diid = AESEncryption().decryptAES64('${response.data['q']}', key);
    log('${response.data['q']}', name: '>>> Response Data <<<');
    log(diid, name: '$name');
    return json.decode(diid);
  }
}
