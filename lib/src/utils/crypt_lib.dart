import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:brotli/brotli.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import "package:hex/hex.dart";
import 'package:rafiki/src/utils/app_logger.dart';

class CryptLibImpl {
  static const staticEncryptKey = "csXDRzpcEPm_jMny";
  static const staticEncryptIv = "84jfkfndl3ybdfkf";
  static const staticLogKeyValue = "KBSB&er3bflx9%";

  static String toSHA256(String key, int length) {
    var bytes1 = utf8.encode(key); // data being hashed
    var digest1 = sha256.convert(bytes1);
    var digestBytes = digest1.bytes;
    var hex = HEX.encode(digestBytes);
    if (length > hex.toString().length) {
      return hex.toString();
    } else {
      return hex.toString().substring(0, length);
    }
  }

  static String decrypt(
      String ciphertext, String decryptKey, String decryptIv) {
    final key = Key.fromUtf8(decryptKey);
    final iv = IV.fromUtf8(decryptIv);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted enBase64 = Encrypted.from64(ciphertext);
    final decrypted = encrypter.decrypt(enBase64, iv: iv);
    return decrypted;
  }

  static String encrypt(String plainText, String encryptKey, String encryptIv) {
    final key = Key.fromUtf8(toSHA256(encryptKey, 32));
    final iv = IV.fromUtf8(encryptIv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String encryptField(String plainText) {
    final hashKey = Key.fromUtf8(toSHA256(staticLogKeyValue, 32));
    AppLogger.appLogI(
        tag: "HASH KEY: STATIC ENCRYPT",
        message: utf8.decode(base64.decode(hashKey.base64)));
    final encrypter = Encrypter(AES(hashKey, mode: AESMode.cbc));
    final encryptedText =
        encrypter.encrypt(plainText, iv: IV.fromUtf8(staticEncryptIv));
    return encryptedText.base64;
  }

  static String encryptPayloadObj(
      String decryptedString, String keyvaltest, String serverIV) {
    String data = "";
    String key = toSHA256(keyvaltest, 32);
    data = encrypt(decryptedString, key, serverIV);
    data = data.replaceAll("\\r\\n|\\r|\\n", "");
    return data;
  }

  static String gzipDecompressStaticData(String gzippedString) {
    return utf8.decode(GZipDecoder().decodeBytes(base64.decode(gzippedString)));
  }
}
