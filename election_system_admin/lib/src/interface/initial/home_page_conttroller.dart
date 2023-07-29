import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/admin.dart';
import '../../services/local_storage_service.dart';
import '../candidates/view/candidates_view.dart';
import '../dashboard/view/dashboard_view.dart';
import '../elections/view/elections_view.dart';
import '../requests/view/requests_view.dart';
import '../security_log/view/security_log_view.dart';
import '../voters/view/voter_view.dart';

class HomePageController extends GetxController {
  Rx<int> pageIndex = 0.obs;
  Rx<Admin?> admin = Rx(null);

  List<Map<String, dynamic>> pages = [
    {
      'name': "Dashboard",
      'icon': const Icon(Icons.dashboard),
      'page': const DashboardView()
    },
    {
      'name': "Elections",
      'icon': const Icon(Icons.event),
      'page': const ElectionView()
    },
    {
      'name': "Candidates",
      'icon': const Icon(Icons.person_4),
      'page': const CandidatesView()
    },
    {
      'name': "Voters",
      'icon': const Icon(Icons.how_to_vote),
      'page': const VotersView()
    },
    {
      'name': "Requests",
      'icon': const Icon(Icons.notifications),
      'page': const RequestsView()
    },
    {
      'name': "Security Logs",
      'icon': const Icon(Icons.show_chart),
      'page': const SecurityLogView()
    },
  ];

  set setIndex(int value) {
    pageIndex.value = value;
    update();
  }

  @override
  void onInit() {
    getCurrentUserData();
    super.onInit();
  }

  getCurrentUserData() async {
    LocalStorageService localStorageService = LocalStorageServiceImpl();
    admin.value = await localStorageService.getCurrentUser();
  }
}
