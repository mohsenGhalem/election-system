import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/candidate.dart';
import '../../../models/election.dart';
import '../../../models/voter.dart';
import '../../../services/dashboard_services.dart';

enum DataType {
  voter,
  candidate,
  election,
}

class DashboardController extends GetxController {
  final DashboardService dashboardService;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DataType dataType = DataType.election;

  DashboardController({required this.dashboardService});

  Future<List<ElectionCount>> getElectionCount() async {
    List<ElectionCount> electionCount = [];

    final result = await dashboardService.getElectionCount();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => electionCount = data,
    );
    return electionCount;
  }



  set setDataType(DataType value) {
    dataType = value;
  }

  Future<List<CandidateCount>> getCandidateCount() async {
    List<CandidateCount> candidateCount = [];

    final result = await dashboardService.getCandidateCount();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => candidateCount = data,
    );
    return candidateCount;
  }

  Future<List<VoterCount>> getVoterCount() async {
    List<VoterCount> voterCount = [];

    final result = await dashboardService.getVotersCount();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => voterCount = data,
    );
    return voterCount;
  }

  Future<List<Election>> getNewElections() async {
    List<Election> newElections = [];

    final result = await dashboardService.getNewElections();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => newElections = data,
    );
    return newElections;
  }

  Future<List<Candidate>> getNewCandidates() async {
    List<Candidate> newCandidates = [];

    final result = await dashboardService.getNewCandidates();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => newCandidates = data,
    );
    return newCandidates;
  }

  Future<List<Voter>> getNewVoters() async {
    List<Voter> newVoters = [];

    final result = await dashboardService.getNewVoters();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => newVoters = data,
    );
    return newVoters;
  }
}
