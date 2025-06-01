// ignore_for_file: depend_on_referenced_packages

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAEncryption {
  Future<T> parseKeyFromStr<T extends RSAAsymmetricKey>(String str) async {
    final paser = RSAKeyParser();
    return paser.parse(str) as T;
  }

  encryptRSA64({required String plainText, String? publicKeyStr}) async {
    String publicKeyPEM =
        '-----BEGIN PUBLIC KEY-----\n$publicKeyStr\n-----END PUBLIC KEY-----';
    final publicKey = await parseKeyFromStr<RSAPublicKey>(publicKeyPEM);
    Encrypter encrypter;
    Encrypted encrypted;
    encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.PKCS1,
        digest: RSADigest.SHA256,
      ),
    );

    encrypted = encrypter.encrypt(plainText);
    return encrypted.base64.toString();
  }
}
