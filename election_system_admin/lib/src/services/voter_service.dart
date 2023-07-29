import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/errors/failures.dart';
import '../models/voter.dart';

abstract class VoterService {
  ///[getVoter] to get an existing voter
  Future<Either<Failure, Voter>> getVoter({required String id});

  ///[getAllVoters] to get all existing voters
  Future<Either<Failure, List<Voter>>> getAllVoters();
}

class VoterServiceImpl implements VoterService {
  final SupabaseClient client;

  const VoterServiceImpl({required this.client});
  @override
  Future<Either<Failure, List<Voter>>> getAllVoters() async {
    try {
      final List<dynamic> data = await client.from('voters').select();
      List<Voter> list = data.map((e) => Voter.fromMap(e)).toList();

      return Right(list);
    } catch (e) {
      debugPrint('getAllVoters Error : $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Voter>> getVoter({required String id}) async {
    try {
      final data =
          await client.from('voters').select().eq('voter_id', id).single();

      return Right(Voter.fromMap(data));
    } catch (e) {
      debugPrint('getVoter Error : $e');
      return Left(ServerFailure());
    }
  }
}
