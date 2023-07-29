import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:election_system_admin/src/services/local_storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/errors/failures.dart';
import '../models/admin.dart';

abstract class AdminService {
  ///[changeTheStatusOfAdmin] to change the status of an admin
  Future<Either<Failure, Unit>> changeTheStatusOfAdmin(
      {required String id, required String status});

  ///[getBlockedAdmins] to get all blocked admins
  Future<Either<Failure, List<Admin>>> getBlockedAdmins();

  ///[getAdminsRequests] to get all admins requests
  Future<Either<Failure, List<Admin>>> getAdminsRequests();

  ///[changePassword] to change the password of an admin
  Future<Either<Failure, Unit>> changePassword({required String password});

  ///[updateEmail] to update the email of an admin
  Future<Either<Failure, Unit>> updateEmail({required String email});

  ///[updatePersonalInfo] to update the personal info of an admin
  Future<Either<Failure, Unit>> updatePersonalInfo({required Admin admin});

  ///[updateProfileImage] to update the profile image of an admin
  Future<Either<Failure, Unit>> updateProfileImage(
      {required Admin admin, required File image, required bool update});
}

class AdminServiceImple implements AdminService {
  final SupabaseClient supabase;

  const AdminServiceImple({required this.supabase});

  @override
  Future<Either<Failure, Unit>> changeTheStatusOfAdmin(
      {required String id, required String status}) async {
    try {
      await supabase
          .from('admins')
          .update({'admin_status': status}).eq('admin_id', id);
      return const Right(unit);
    } catch (e) {
      debugPrint('changeTheStatusOfAdmin ERROR: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Admin>>> getAdminsRequests() async {
    try {
      final List<dynamic> data =
          await supabase.from('admins').select().eq('admin_status', 'pending');
      final List<Admin> list = data.map((e) => Admin.fromMap(e)).toList();
      return Right(list);
    } catch (e) {
      debugPrint('getAdminsRequests ERROR: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Admin>>> getBlockedAdmins() async {
    try {
      final List<dynamic> data =
          await supabase.from('admins').select().eq('admin_status', 'refused');
      final List<Admin> list = data.map((e) => Admin.fromMap(e)).toList();
      return Right(list);
    } catch (e) {
      debugPrint('getBlockedAdmins ERROR: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(
      {required String password}) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: password),
      );
      return const Right(unit);
    } catch (e) {
      debugPrint('changePassword ERROR: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEmail({required String email}) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(email: email),
      );
      return const Right(unit);
    } catch (e) {
      debugPrint('updateEmail ERROR: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePersonalInfo(
      {required Admin admin}) async {
    try {
      final data = admin.toMap();
      data.remove('admin_id');
      await supabase.from('admins').update(data).eq('admin_id', admin.admin_id);

      LocalStorageService localStorageService = LocalStorageServiceImpl();

      localStorageService.clearCurrentUser();
      localStorageService.saveCurrentUser(admin: admin);

      return const Right(unit);
    } catch (e) {
      debugPrint('updatePersonalInfo ERROR: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfileImage(
      {required Admin admin, required File image, required bool update}) async {
    try {
      final fileName = 'avatars/avatar_${admin.user_id}.jpg';
      if (update) {
        await supabase.storage.from('election-storage').update(fileName, image);
      } else {
        await supabase.storage.from('election-storage').upload(fileName, image);
      }

      final url = await supabase.storage
          .from('election-storage')
          .createSignedUrl(fileName, const Duration(days: 365).inSeconds);

      await updatePersonalInfo(admin: admin.copyWith(admin_image: url));

      return const Right(unit);
    } catch (e) {
      debugPrint('updateProfileImage ERROR: $e');
      return Left(ServerFailure());
    }
  }
}
