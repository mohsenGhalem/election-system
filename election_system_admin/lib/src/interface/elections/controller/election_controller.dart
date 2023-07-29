import 'dart:io';

import '../../../models/candidate.dart';
import '../../../services/election_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/election.dart';

enum ElectionOrCandidate { election, candidate }

class ElectionController extends GetxController {
  final ElectionService electionService;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Election? electionData;

  String currentId = '';
  Rx<ElectionOrCandidate> electionOrCandidate =
      ElectionOrCandidate.election.obs;

  set setCurrentId(String id) {
    currentId = id;
    update();
  }

  set setElectionOrCandidate(ElectionOrCandidate value) {
    electionOrCandidate.value = value;
    update();
  }

  ElectionController({required this.electionService});

  void openDrawer() {
    if (scaffoldKey.currentState?.isEndDrawerOpen == true) {
      scaffoldKey.currentState?.closeEndDrawer();
    }
    Future.delayed(Duration.zero, () {
      scaffoldKey.currentState?.openEndDrawer();
    });
  }

  void closeDrawer() {
    if (electionOrCandidate.value == ElectionOrCandidate.candidate) {
      setElectionOrCandidate = ElectionOrCandidate.election;
    }

    scaffoldKey.currentState?.closeEndDrawer();
  }

  Future<List<Election>> getAllElection() async {
    List<Election> election = [];

    final result = await electionService.getAllElection();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => election = data,
    );
    return election;
  }

  Future<void> createElection(
      {required Election election, required File image}) async {
    final result =
        await electionService.createElection(election: election, image: image);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => Get.snackbar(
        'Success',
        'Election created successfully',
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  Future<void> updateElection(
      {required Election election, required File image}) async {
    final result =
        await electionService.updateElection(election: election, image: image);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => Get.snackbar(
        'Success',
        'Election updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  Future<bool> deleteElection({required String election_id}) async {
    bool succesed = false;
    final result =
        await electionService.deleteElection(election_id: election_id);
    result.fold(
      (l) => null,
      (r) => succesed = true,
    );
    return succesed;
  }

  Future<Election?> getElectionById({required String id}) async {
    Election? election;

    final result = await electionService.getElection(id: id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => election = data,
    );
    electionData = election;
    return election;
  }

  Future<List<Candidate>> getElectionAcceptedCaandidate(
      {required String id}) async {
    List<Candidate> candidates = [];

    final result = await electionService.getElectionAcceptedCaandidate(id: id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => candidates = data,
    );
    return candidates;
  }

  Future<List<Candidate>> getElectionRefusedCaandidate(
      {required String id}) async {
    List<Candidate> candidates = [];

    final result = await electionService.getElectionRefusedCaandidate(id: id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => candidates = data,
    );
    return candidates;
  }

  Future<List<Candidate>> getElectionRequests({required String id}) async {
    List<Candidate> candidates = [];

    final result = await electionService.getElectionRequests(id: id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => candidates = data,
    );
    return candidates;
  }

  


  Future<bool> acceptCandidateToElection(
      {required String candidate_id, required String election_id}) async {
    bool succesed = false;
    final result = await electionService.acceptCandidateToElection(
        candidate_id: candidate_id, election_id: election_id);
    result.fold(
      (failure) => succesed = false,
      (data) => succesed = true,
    );

    return succesed;
  }

  Future<bool> refuseCandidateToElection(
      {required String candidate_id, required String election_id}) async {
    bool succesed = false;
    final result = await electionService.refuseCandidateToElection(
        candidate_id: candidate_id, election_id: election_id);
    result.fold(
      (failure) => succesed = false,
      (data) => succesed = true,
    );

    return succesed;
  }

  Future<bool> changeCandidateInElection(
      {required String candidate_id,
      required String election_id,
      required String status}) async {
    bool succesed = false;
    final result = await electionService.changeCandidateInElection(
        candidate_id: candidate_id, election_id: election_id, status: status);
    result.fold(
      (failure) => succesed = false,
      (data) => succesed = true,
    );

    return succesed;
  }
}
