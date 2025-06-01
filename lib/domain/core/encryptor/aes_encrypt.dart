import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';


class AESEncryption {
  final String iv = 'BIDCBANK_NUMBER1';

  String generateBase64Key() {
    const int len = 16; // 16 bytes
    const String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random();
    final String strBase64Key =
        List.generate(len, (_) => chars[random.nextInt(chars.length)]).join();
    final bytes = utf8.encode(strBase64Key);
    return base64.encode(bytes);
  }

  String encryptAES64({required String plainText, required String secretKeyBase64Text}) {
    final key = Key.fromUtf8(
      String.fromCharCodes(base64.decode(secretKeyBase64Text)),
    );
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));
    final initializationVector = IV.fromUtf8(iv);
    final encrypted = encrypter.encrypt(
      plainText,
      iv: initializationVector,
    );
    return encrypted.base64;
  }

  String decryptAES64(String encryptedBas64Text, String secretKeyBase64Text) {
    final key = Key.fromUtf8(
      String.fromCharCodes(base64.decode(secretKeyBase64Text)),
    );
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));
    final initializationVector = IV.fromUtf8(iv);
    final decrypted = encrypter.decrypt64(
      encryptedBas64Text,
      iv: initializationVector,
    );
    return decrypted;
  }
}
