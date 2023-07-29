import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/errors/failures.dart';
import '../models/candidate.dart';
import '../models/election.dart';

abstract class CandidateService {
  ///[getCandidate] to get an existing candidate
  Future<Either<Failure, Candidate>> getCandidate({required String id});

  ///[getAllCandidates] to get all existing candidates
  Future<Either<Failure, List<Candidate>>> getAllCandidates();

  ///[getCandidateElections] to get all elections of a candidate
  Future<Either<Failure, List<ElectionCandidate>>> getCandidateElections(
      {required String id});
}

class CandidateServiceImple implements CandidateService {
  final SupabaseClient supabase;

  const CandidateServiceImple({required this.supabase});

  @override
  Future<Either<Failure, List<Candidate>>> getAllCandidates() async {
    try {
      final List<dynamic> data = await supabase.from('candidates').select();

      return Right(data.map((e) => Candidate.fromMap(e)).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Candidate>> getCandidate({required String id}) async {
    try {
      final data = await supabase
          .from('candidates')
          .select()
          .eq('candidate_id', id)
          .single();
      return Right(Candidate.fromMap(data));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ElectionCandidate>>> getCandidateElections(
      {required String id}) async {
    try {
      final List<dynamic> data = await supabase
          .from('candidates_elections')
          .select('*,elections(*)')
          .eq('candidate_id', id);

      print(data);

      List<ElectionCandidate> list =
          data.map((e) => ElectionCandidate.fromMap(e)).toList();
      return Right(list);
    } catch (e) {
      debugPrint('getCandidateElections error: $e');
      return Left(ServerFailure());
    }
  }
}
