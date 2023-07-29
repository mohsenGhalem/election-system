import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/election.dart';
import '../services/local_storage_service.dart';

class HomeController extends GetxController {
  LocalStorageService localStorageService = LocalStorageServiceImpl();

  Future<List<Election>> getActiveElection() async {
    try {
      final List<dynamic> response = await Supabase.instance.client
          .from('elections')
          .select()
          .eq('is_active', true);
      List<Election> elections = [];

      elections = response.map((e) => Election.fromMap(e)).toList();

      return elections;
    } catch (e) {
      debugPrint('getActiveElection error: $e');
      return [];
    }
  }
}
