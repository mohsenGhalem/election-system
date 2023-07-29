import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/candidate.dart';
import '../models/election.dart';
import '../models/voter.dart';
import '../common/errors/failures.dart';

abstract class DashboardService {
  ///[getElectionCount] to get the number of elections
  Future<Either<Failure, List<ElectionCount>>> getElectionCount();

  ///[getCandidateCount] to get the number of candidates
  Future<Either<Failure, List<CandidateCount>>> getCandidateCount();

  ///[getVotersCount] to get the number of voters
  Future<Either<Failure, List<VoterCount>>> getVotersCount();

  ///[getNewElections] to get all the new elections
  Future<Either<Failure, List<Election>>> getNewElections();

  ///[getNewCandidates] to get all the new candidates
  Future<Either<Failure, List<Candidate>>> getNewCandidates();

  ///[getNewVoters] to get all the new voters
  Future<Either<Failure, List<Voter>>> getNewVoters();
}

class DashboardServiceImpl implements DashboardService {
  final SupabaseClient client;

  const DashboardServiceImpl({required this.client});
  @override
  Future<Either<Failure, List<CandidateCount>>> getCandidateCount() async {
    try {
      PostgrestResponse candidateCount = await client
          .from('candidates')
          .select('*', const FetchOptions(count: CountOption.exact));

      List<CandidateCount> candidatesList = [
        CandidateCount(
            title: 'total candidates', count: candidateCount.count ?? 0),
        CandidateCount(
            title: 'total candidates', count: candidateCount.count ?? 0),
        CandidateCount(
            title: 'total candidates', count: candidateCount.count ?? 0),
      ];
      return Right(candidatesList);
    } catch (e) {
      debugPrint('getCandidateCount ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ElectionCount>>> getElectionCount() async {
    try {
      PostgrestResponse electionCount = await client
          .from('elections')
          .select('*', const FetchOptions(count: CountOption.exact));
      PostgrestResponse inActiveElectionCount = await client
          .from('elections')
          .select(
            '*',
            const FetchOptions(count: CountOption.exact),
          )
          .eq('is_active', false);
      int totalCount = electionCount.count ?? 0;
      int inActivveElection = inActiveElectionCount.count ?? 0;
      int activeElection = totalCount - inActivveElection;

      List<ElectionCount> electionsList = [
        ElectionCount(title: 'all elections', count: totalCount),
        ElectionCount(title: 'inactive elections', count: inActivveElection),
        ElectionCount(
            title: 'active elections',
            count: activeElection < 0 ? 0 : activeElection),
      ];
      return Right(electionsList);
    } catch (e) {
      debugPrint('getElectionCount ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Candidate>>> getNewCandidates() async {
    try {
      final List<dynamic> data =
          await client.from('candidates').select('*').limit(5);

      final List<Candidate> list =
          data.map((e) => Candidate.fromMap(e)).toList();

      return Right(list);
    } catch (e) {
      debugPrint('getElectionCount ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Election>>> getNewElections() async {
    try {
      final data =
          await client.from('elections').select().limit(5) as List<dynamic>;

      final list = data.map((e) => Election.fromMap(e)).toList();

      return Right(list);
    } catch (e) {
      debugPrint('getNewElections ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Voter>>> getNewVoters() async {
    try {
      final List<dynamic> data = await client.from('voters').select().limit(5);
      final List<Voter> list = data.map((e) => Voter.fromMap(e)).toList();

      return Right(list);
    } catch (e) {
      debugPrint('getNewVoters ERROR = $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<VoterCount>>> getVotersCount() async {
    try {
      PostgrestResponse voterCount = await client
          .from('voters')
          .select('*', const FetchOptions(count: CountOption.exact));
      List<VoterCount> candidatesList = [
        VoterCount(title: 'total voters', count: voterCount.count ?? 0),
        VoterCount(title: 'total voters', count: voterCount.count ?? 0),
        VoterCount(title: 'total voters', count: voterCount.count ?? 0),
      ];
      return Right(candidatesList);
    } catch (e) {
      debugPrint('getVotersCount ERROR = $e');

      return Left(ServerFailure());
    }
  }
}
