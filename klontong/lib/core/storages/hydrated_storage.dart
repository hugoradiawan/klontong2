import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

class KlontongStorage {
  static const String password = 'KlontongSecureStorage';
  static Future<void> init() async {
    final byteskey = sha256.convert(utf8.encode(password)).bytes;
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
      encryptionCipher: HydratedAesCipher(byteskey),
    );
  }

  static Future<void> clear() => HydratedBloc.storage.clear();
}
