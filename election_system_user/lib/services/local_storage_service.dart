import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/candidate.dart';
import '../models/voter.dart';

abstract class LocalStorageService {
  Future<void> saveCurrentUser({Voter? voter, Candidate candidate});
  Future<Voter> getCurrentUserVoter();
  Future<bool> isVoter();
  Future<Candidate> getCurrentUserCandidate();
  Future<void> clearCurrentUser();
}

class LocalStorageServiceImpl implements LocalStorageService {
  LocalStorageServiceImpl();
  

  @override
  Future<void> saveCurrentUser({Voter? voter, Candidate? candidate}) async {
    Box localeStorageBox = await Hive.openBox('user_data');
    if (voter != null) {
      await localeStorageBox.put('user', voter.toMap());
      await localeStorageBox.put('user_role', 'voter');
    } else if (candidate != null) {
      await localeStorageBox.put('user', candidate.toMap());
      await localeStorageBox.put('user_role', 'candidate');
    }

    debugPrint("User info saved");
  }

  @override
  Future<void> clearCurrentUser() async {
    await Supabase.instance.client.auth.signOut();
    Box localeStorageBox = await Hive.openBox('user_data');
    await localeStorageBox.delete('user');
    await localeStorageBox.delete('user_role');

    debugPrint("User info deleted");
    Get.offAllNamed('/auth');
  }

  @override
  Future<Candidate> getCurrentUserCandidate() async {
    Box localeStorageBox = await Hive.openBox('user_data');
    final data = localeStorageBox.get('user');

    Candidate candidate = Candidate.fromMap(data);

    return candidate;
  }
  @override
  Future<Voter> getCurrentUserVoter() async {
    Box localeStorageBox = await Hive.openBox('user_data');
    final data = localeStorageBox.get('user');

    Voter voter = Voter.fromMap(data);

    return voter;
  }

  @override
  Future<bool> isVoter() async {
    Box localeStorageBox = await Hive.openBox('user_data');
    final data = localeStorageBox.get('user_role');
    if (data == 'voter') {
      return true;
    }
    return false;
  }
}
