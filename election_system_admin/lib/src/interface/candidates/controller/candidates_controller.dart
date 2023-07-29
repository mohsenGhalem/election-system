import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/candidate.dart';
import '../../../models/election.dart';
import '../../../services/candidate_service.dart';

class CandidateController extends GetxController {
  final CandidateService candidateService;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Rx<String> currentCandidateId = Rx<String>('');

  CandidateController({required this.candidateService});

  set setCurrentId(String value) {
    currentCandidateId.value = value;
    update();
  }

  Future<List<Candidate>> getAllCandidates() async {
    final data = await candidateService.getAllCandidates();
    return data.fold((l) => [], (r) => r);
  }

  Future<Candidate?> getCandidate({required String id}) async {
    final data = await candidateService.getCandidate(id: id);
    return data.fold((l) => null, (r) => r);
  }

  Future<List<ElectionCandidate>> getCandidateElections(
      {required String id}) async {
    final data = await candidateService.getCandidateElections(id: id);
    return data.fold((l) => [], (r) => r);
  }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeEndDrawer();
  }
}
