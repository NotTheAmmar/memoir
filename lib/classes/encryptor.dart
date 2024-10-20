import 'dart:convert';
import 'dart:typed_data';

import 'package:memoir/classes/user_preferences.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;

/// To Handle encryption and decryption
///
/// Make sure that all the keys are generated using [initializeKeys]
abstract final class Encryptor {
  /// Helper Object for RSA Encryption
  static final rsa.RsaKeyHelper _rsaHelper = rsa.RsaKeyHelper();

  /// Generates necessary encryption keys
  static Future<void> initializeKeys() async {
    await _deriveKey();
    await _generateKeyPair();
  }

  /// Derives AES encryption key using Master Password
  ///
  /// Does not derive if already exists
  static Future<void> _deriveKey() async {
    if (UserPreferences.aesKey.isNotEmpty) return;

    final crypto.Argon2id algorithm = crypto.Argon2id(
      parallelism: 4,
      memory: 32 * 1024,
      iterations: 3,
      hashLength: 32,
    );

    final crypto.SecretKey secretKey = await algorithm.deriveKeyFromPassword(
      password: UserPreferences.masterPassword,
      nonce: [],
    );

    final Uint8List keyBytes = Uint8List.fromList(
      await secretKey.extractBytes(),
    );

    final encrypt.Key key = encrypt.Key(keyBytes);

    UserPreferences.aesKey = key.base64;
  }

  /// Generates random RSA public and private keys
  ///
  /// Encodes the keys to `pem` and then to `base64`
  ///
  /// Does not regenerate keys if they already exist
  static Future<void> _generateKeyPair() async {
    if (UserPreferences.privateKey.isNotEmpty) return;

    final keyPair = await _rsaHelper.computeRSAKeyPair(
      _rsaHelper.getSecureRandom(),
    );

    String publicKey = _rsaHelper.encodePublicKeyToPemPKCS1(
      keyPair.publicKey as dynamic,
    );
    Uint8List publicKeyBytes = utf8.encode(publicKey);
    UserPreferences.publicKey = base64Encode(publicKeyBytes);

    String privateKey = _rsaHelper.encodePrivateKeyToPemPKCS1(
      keyPair.privateKey as dynamic,
    );
    Uint8List privateKeyBytes = utf8.encode(privateKey);
    UserPreferences.privateKey = base64Encode(privateKeyBytes);
  }

  /// Encrypts password using AES Encryption
  ///
  /// Converts the encrypted password to `base64`
  ///
  /// The iv is also included in the result, it is the first 16 bytes
  static String encryptPassword(String password) {
    final encrypt.Key key = encrypt.Key.fromBase64(UserPreferences.aesKey);

    final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
      key,
      mode: encrypt.AESMode.cbc,
    ));

    final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);
    final encrypt.Encrypted encrypted = encrypter.encrypt(password, iv: iv);

    return base64Encode(iv.bytes + encrypted.bytes);
  }

  /// Decrypts the password using AES
  static String decryptPassword(String encrypted) {
    final encrypt.Key key = encrypt.Key.fromBase64(UserPreferences.aesKey);

    final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
      key,
      mode: encrypt.AESMode.cbc,
    ));

    final Uint8List encryptedBytes = base64Decode(encrypted);

    final Uint8List ivBytes = encryptedBytes.sublist(0, 16);
    final String iv64 = base64Encode(ivBytes);
    final encrypt.IV iv = encrypt.IV.fromBase64(iv64);

    final String encryptedData = base64Encode(encryptedBytes.sublist(16));

    return encrypter.decrypt64(encryptedData, iv: iv);
  }

  /// Encrypts the file data using AES encryption,
  /// but encrypts the AES Key using RSA Encryption
  /// 
  /// Cannot encrypt the data using RSA due to size limitations
  /// 
  /// The AES Key, IV, and Data are stored in json format,
  /// then encoded in base64 format
  /// 
  /// Random AES Key and IV are used
  static String encryptFile(String data, String publicKey) {
    final encrypt.Key aesKey = encrypt.Key.fromSecureRandom(32);
    final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);

    final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
      aesKey,
      mode: encrypt.AESMode.cbc,
    ));

    final encrypt.Encrypted encrypted = encrypter.encrypt(data, iv: iv);

    Uint8List publicKeyBytes = base64Decode(publicKey);
    final String encryptedAesKey = rsa.encrypt(
      aesKey.base64,
      _rsaHelper.parsePublicKeyFromPem(utf8.decode(publicKeyBytes)),
    );

    final String encryptedData = jsonEncode({
      "key": encryptedAesKey,
      "iv": iv.base64,
      "data": encrypted.base64,
    });

    final Uint8List encryptedBytes = utf8.encode(encryptedData);

    return base64Encode(encryptedBytes);
  }

  /// Decodes the base64 data back to json then
  /// decrypts the encrypted AES Key using RSA  
  /// (uses the device private key to decrypt, if no private key is provided),
  /// then decrypts the encrypted data using AES
  static String decryptFile(String data, String? privateKey) {
    final Uint8List encryptedDataBytes = base64Decode(data);
    final String encryptedData = utf8.decode(encryptedDataBytes);

    final Map jsonData = json.decode(encryptedData);

    Uint8List privateKeyBytes = base64Decode(privateKey ?? UserPreferences.privateKey);
    final String aesKey64 = rsa.decrypt(
      jsonData["key"],
      _rsaHelper.parsePrivateKeyFromPem(utf8.decode(privateKeyBytes)),
    );

    final encrypt.Key aesKey = encrypt.Key.fromBase64(aesKey64);
    final encrypt.IV iv = encrypt.IV.fromBase64(jsonData["iv"]);

    final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(
      aesKey,
      mode: encrypt.AESMode.cbc,
    ));

    return encrypter.decrypt64(jsonData["data"], iv: iv);
  }
}
