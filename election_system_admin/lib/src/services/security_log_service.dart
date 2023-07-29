import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/errors/failures.dart';
import '../models/security_log.dart';

abstract class SecurityLogService {
  ///[getAllSecurityLog] to get all security logs
  Future<Either<Failure, List<SecurityLog>>> getAllSecurityLog();

  ///[insertSecurityLog] to insert a security log
  Future<Either<Failure, Unit>> insertSecurityLog(
      {required SecurityLog securityLog});
}

class SecurityLogServiceImpl implements SecurityLogService {
  final SupabaseClient client;

  const SecurityLogServiceImpl({required this.client});
  @override
  Future<Either<Failure, List<SecurityLog>>> getAllSecurityLog() async {
    try {
      final List<dynamic> data = await client.from('security_logs').select();

      final List<SecurityLog> list = data
          .map((dynamic e) => SecurityLog.fromMap(e as Map<String, dynamic>))
          .toList();

      return Right(list);
    } catch (e) {
      debugPrint("getAllSecurityLog ERROR =  $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> insertSecurityLog(
      {required SecurityLog securityLog}) async {
    try {
      await client.from('security_log').insert(securityLog.toMap());

      return const Right(unit);
    } catch (e) {
      debugPrint("insertSecurityLog ERROR =  $e");
      return Left(ServerFailure());
    }
  }
}
