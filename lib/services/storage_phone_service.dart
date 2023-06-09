import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/storage_phone_item.dart';

class StorageServicesPhone {
  final _securePhoneStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  Future<void> writeSecureData(String phone) async {
    debugPrint("Writing sNumber $phone");
    await _securePhoneStorage.write(
        key: phone, value: 'Yes', aOptions: _getAndroidOptions());
  }

  Future<String?> readSecureData(String phone) async {
    debugPrint("Reading Phone : $phone");
    var readData = await _securePhoneStorage.read(
        key: phone, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<void> deleteSecureData(StoragePhone item) async {
    debugPrint("Deleting phone:  ${item.phone}");
    await _securePhoneStorage.delete(
        key: item.phone, aOptions: _getAndroidOptions());
  }

  Future<void> deleteAllSecureData() async {
    debugPrint("Deleting all phone");
    await _securePhoneStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  Future<bool> containsKeyInSecureData(String phone) async {
    debugPrint("Checking phone: $phone");
    var containsKey = await _securePhoneStorage.containsKey(
        key: phone, aOptions: _getAndroidOptions());
    return containsKey;
  }

  Future<List<StoragePhone>> readAllSecureData() async {
    debugPrint("Reading all secured data");
    var allData =
        await _securePhoneStorage.readAll(aOptions: _getAndroidOptions());
    List<StoragePhone> list =
        allData.entries.map((e) => StoragePhone(e.key, e.value)).toList();
    return list;
  }
}
