import 'dart:io';

import 'package:dartz/dartz.dart';
import '../models/admin.dart';
import 'local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/errors/failures.dart';
import '../models/candidate.dart';
import '../models/election.dart';
import '../models/security_log.dart';

///[ElectionService] is an abstract class that defines the methods that helpes in election management
abstract class ElectionService {
  ///[createElection] to create an election
  Future<Either<Failure, Unit>> createElection(
      {required Election election, File? image});

  ///[updateElection] to update an existing election
  Future<Either<Failure, Unit>> updateElection(
      {required Election election, File? image});

  ///[deleteElection] to delete an existing election
  Future<Either<Failure, Unit>> deleteElection({required String election_id});

  ///[getElection] to get an existing election
  Future<Either<Failure, Election>> getElection({required String id});

  ///[getElection] to get all existing election
  Future<Either<Failure, List<Election>>> getAllElection();

  ///[getElectionAcceptedCaandidate] to get all accepted candidates of an existing election
  Future<Either<Failure, List<Candidate>>> getElectionAcceptedCaandidate(
      {required String id});

  ///[getElectionRefusedCaandidate] to get all refused candidates of an existing election
  Future<Either<Failure, List<Candidate>>> getElectionRefusedCaandidate(
      {required String id});

  ///[getElectionRequests] to get all requests of an existing election
  Future<Either<Failure, List<Candidate>>> getElectionRequests(
      {required String id});

  ///[getVoteCount] to get the number of votes of an existing election
  Future<Either<Failure, List<CandidateElectionVoteCount>>> getVoteCount(
      {required String id});

  ///[acceptCandidateToElection] to accept a candidate to an existing election
  Future<Either<Failure, Unit>> acceptCandidateToElection(
      {required String candidate_id, required String election_id});

  ///[refuseCandidateToElection] to refuse a candidate to an existing election
  Future<Either<Failure, Unit>> refuseCandidateToElection(
      {required String candidate_id, required String election_id});

  ///[changeCandidateInElection] to change a candidate status to an existing election
  Future<Either<Failure, Unit>> changeCandidateInElection(
      {required String candidate_id,
      required String election_id,
      required String status});
}

class ElectionServiceImpl implements ElectionService {
  final SupabaseClient client;

  const ElectionServiceImpl({required this.client});
  @override
  Future<Either<Failure, Unit>> acceptCandidateToElection(
      {required String candidate_id, required String election_id}) async {
    try {
      await client
          .from('candidates_elections')
          .update({'is_verified': 'accepted'})
          .eq('candidate_id', candidate_id)
          .eq('election_id', election_id);

      ///Log
      LocalStorageService localStorageService = LocalStorageServiceImpl();
      final Admin currentUser = await localStorageService.getCurrentUser();
      SecurityLog securityLog = SecurityLog(
          user_id: currentUser.user_id!,
          action_description:
              'Accepted Candidate($candidate_id) in Election($election_id)',
          log_date: DateTime.now());
      await client.from('security_logs').insert(securityLog.toMap());

      return const Right(unit);
    } catch (e) {
      debugPrint('acceptCandidateToElection ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createElection(
      {required Election election, File? image}) async {
    try {
      if (image != null) {
        String fileName =
            'elections/election-${election.election_name.replaceAll(' ', '')}.jpg';
        await client.storage.from('election-storage').upload(fileName, image);
        final url = await client.storage
            .from('election-storage')
            .createSignedUrl(fileName, const Duration(days: 365).inSeconds);
        election.election_image = url;
      }

      Map<String, dynamic> data = election.toMap();
      data.remove('election_id');

      final List<Map<String, dynamic>> insertedData =
          await client.from('elections').insert(data).select();
      LocalStorageService localStorageService = LocalStorageServiceImpl();
      final Admin currentUser = await localStorageService.getCurrentUser();
      SecurityLog securityLog = SecurityLog(
          user_id: currentUser.user_id!,
          action_description:
              'Added Election(${insertedData[0]['election_id']})',
          log_date: DateTime.now());
      await client.from('security_logs').insert(securityLog.toMap());

      return const Right(unit);
    } catch (e) {
      debugPrint('createElection ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteElection(
      {required String election_id}) async {
    try {
      int eid = int.parse(election_id);
      await client.from('elections').delete().eq('election_id', eid);
      LocalStorageService localStorageService = LocalStorageServiceImpl();

      final Admin currentUser = await localStorageService.getCurrentUser();

      SecurityLog securityLog = SecurityLog(
          user_id: currentUser.user_id!,
          action_description: 'delete Election($election_id)',
          log_date: DateTime.now());
      await client.from('security_logs').insert(securityLog.toMap());

      return const Right(unit);
    } catch (e) {
      debugPrint('deleteElection ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Election>>> getAllElection() async {
    try {
      final List<dynamic> response = await client.from('elections').select();
      final List<Election> elections =
          response.map((e) => Election.fromMap(e)).toList();
      return Right(elections);
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Election>> getElection({required String id}) async {
    try {
      final Map<String, dynamic> response = await client
          .from('elections')
          .select()
          .eq('election_id', int.parse(id))
          .single();
      final Election elections = Election.fromMap(response);
      return Right(elections);
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Candidate>>> getElectionAcceptedCaandidate(
      {required String id}) async {
    try {
      final List<dynamic> data = await client
          .from('candidates_elections')
          .select('*,candidates(*)')
          .eq('is_verified', 'accepted')
          .eq('election_id', id);
      return Right(
          data.map((e) => Candidate.fromMap(e['candidates'])).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Candidate>>> getElectionRefusedCaandidate(
      {required String id}) async {
    try {
      final List<dynamic> data = await client
          .from('candidates_elections')
          .select('*,candidates(*)')
          .eq('is_verified', 'refused')
          .eq('election_id', id);
      return Right(
          data.map((e) => Candidate.fromMap(e['candidates'])).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Candidate>>> getElectionRequests(
      {required String id}) async {
    try {
      final List<dynamic> data = await client
          .from('candidates_elections')
          .select('*,candidates(*)')
          .eq('is_verified', 'pending')
          .eq('election_id', id);

      return Right(
          data.map((e) => Candidate.fromMap(e['candidates'])).toList());
    } catch (e) {
      debugPrint("getElectionRequests ERROR = $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CandidateElectionVoteCount>>> getVoteCount(
      {required String id}) async {
    try {
      List<dynamic> candidates_ids =
          await client.from('candidates_elections').select('candidate_id');

      candidates_ids = candidates_ids.map((e) => e['candidate_id']).toList();
      //await client.from('candidates').select('*,votes(count(*) as vote_count)');
      List<dynamic> response = await client
          .from('candidates')
          .select('*, full_name,votes(*)')
          .in_('candidate_id', candidates_ids);
      List<CandidateElectionVoteCount> list = response.map(
        (item) {
          
          return CandidateElectionVoteCount(
              candidate_id: item['candidate_id'].toString(),
              user_id: item['user_id'],
              full_name: item['full_name'],
              birth_date: DateTime.parse(item['birth_date']),
              candidate_statement: item['candidate_statement'],
              candidate_image: item['candidate_image'],
              vote_count: (item['votes'] ?? 0).length);
        },
      ).toList();
      list.sort(
        (a, b) => b.vote_count.compareTo(a.vote_count),
      );
      return Right(list);
    } catch (e) {
      debugPrint('getVoteCount ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateElection(
      {required Election election, File? image}) async {
    try {
      if (image != null) {
        String fileName =
            'elections/election-${election.election_name.replaceAll(' ', '')}.jpg';
        if (election.election_image != null) {
          await client.storage.from('election-storage').update(fileName, image);
        } else {
          await client.storage.from('election-storage').upload(fileName, image);
        }

        final url = await client.storage
            .from('election-storage')
            .createSignedUrl(fileName, const Duration(days: 365).inSeconds);
        election.election_image = url;
        Map<String, dynamic> data = election.toMap();
        data.remove('election_id');
        await client
            .from('elections')
            .update(data)
            .eq('election_id', election.election_id);
      } else {
        Map<String, dynamic> data = election.toMap();
        data.remove('election_id');
        data.remove('election_image');
        await client
            .from('elections')
            .update(data)
            .eq('election_id', election.election_id);
      }

      /// Log
      LocalStorageService localStorageService = LocalStorageServiceImpl();
      final Admin currentUser = await localStorageService.getCurrentUser();
      SecurityLog securityLog = SecurityLog(
          user_id: currentUser.user_id!,
          action_description: 'Updated Election(${election.election_id})',
          log_date: DateTime.now());
      await client.from('security_logs').insert(securityLog.toMap());
      return const Right(unit);
    } catch (e) {
      debugPrint('updateElection ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> refuseCandidateToElection(
      {required String candidate_id, required String election_id}) async {
    try {
      await client
          .from('candidates_elections')
          .update({'is_verified': 'refused'})
          .eq('candidate_id', candidate_id)
          .eq('election_id', election_id);

      ///Log
      LocalStorageService localStorageService = LocalStorageServiceImpl();
      final Admin currentUser = await localStorageService.getCurrentUser();
      SecurityLog securityLog = SecurityLog(
          user_id: currentUser.user_id!,
          action_description:
              'Refused Candidate($candidate_id) in Election($election_id)',
          log_date: DateTime.now());
      await client.from('security_logs').insert(securityLog.toMap());

      return const Right(unit);
    } catch (e) {
      debugPrint('refuseCandidateToElection ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> changeCandidateInElection(
      {required String candidate_id,
      required String election_id,
      required String status}) async {
    try {
      await client
          .from('candidates_elections')
          .update({'is_verified': status})
          .eq('candidate_id', candidate_id)
          .eq('election_id', election_id);

      ///Log
      LocalStorageService localStorageService = LocalStorageServiceImpl();
      final Admin currentUser = await localStorageService.getCurrentUser();
      SecurityLog securityLog = SecurityLog(
          user_id: currentUser.user_id!,
          action_description:
              'Changed Candidate($candidate_id) status to $status in Election($election_id)',
          log_date: DateTime.now());
      await client.from('security_logs').insert(securityLog.toMap());

      return const Right(unit);
    } catch (e) {
      debugPrint('changeCandidateInElection ERROR = $e');
      return Left(ServerFailure());
    }
  }
}
