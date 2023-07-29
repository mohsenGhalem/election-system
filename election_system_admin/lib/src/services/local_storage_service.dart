import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/admin.dart';

abstract class LocalStorageService {
  Future<void> saveCurrentUser({required Admin admin});
  Future<Admin> getCurrentUser();
  Future<void> clearCurrentUser();
}

class LocalStorageServiceImpl implements LocalStorageService {
  LocalStorageServiceImpl();
  @override
  Future<Admin> getCurrentUser() async {
    Box localeStorageBox = await Hive.openBox('user_data');
    final data = localeStorageBox.get('user');

    Admin admin = Admin(
        user_id: data['user_id'],
        admin_id: data['admin_id'],
        full_name: data['full_name'],
        admin_status: data['admin_status'],
        admin_image: data['admin_image']);
    debugPrint(admin.toString());

    return admin;
  }

  @override
  Future<void> saveCurrentUser({required Admin admin}) async {
    Box localeStorageBox = await Hive.openBox('user_data');
    await localeStorageBox.put('user', admin.toMap());
    debugPrint("User info saved");
  }

  @override
  Future<void> clearCurrentUser() async {
    Box localeStorageBox = await Hive.openBox('user_data');
    await localeStorageBox.delete('user');
    debugPrint("User info deleted");
  }
}
