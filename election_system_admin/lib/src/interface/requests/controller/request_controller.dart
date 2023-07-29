import 'dart:io';

import 'package:get/get.dart';

import '../../../models/admin.dart';
import '../../../services/admin_services.dart';

class RequestController extends GetxController {
  final AdminService adminService;

  RequestController({required this.adminService});

  Future<bool> changeStatusOfAdmin(
      {required String id, required String status}) async {
    final result =
        await adminService.changeTheStatusOfAdmin(id: id, status: status);
    return result.fold((l) => false, (r) => true);
  }

  Future<List<Admin>> getAdminRequets() async {
    final result = await adminService.getAdminsRequests();
    return result.fold((l) => [], (r) => r);
  }

  Future<List<Admin>> getBlockedAdmins() async {
    final result = await adminService.getBlockedAdmins();
    return result.fold((l) => [], (r) => r);
  }

  Future<bool> changePassword({required String password}) async {
    final result = await adminService.changePassword(password: password);
    return result.fold((l) => false, (r) => true);
  }

  Future<bool> updateEmail({required String email}) async {
    final result = await adminService.updateEmail(email: email);
    return result.fold((l) => false, (r) => true);
  }

  Future<bool> updatePersonalInfo(
      {required String id, required Admin admin, File? image}) async {
    bool op1 = true;
    bool op2 = true;
    bool op3 = true;

    if (image != null && (admin.admin_image != null)) {
      final response1 = await adminService.updateProfileImage(
          admin: admin, image: image, update: true);
      response1.fold((l) => op1 = false, (r) => op1 = true);
    } else if (image != null && (admin.admin_image == null)) {
      final response2 = await adminService.updateProfileImage(
          admin: admin, image: image, update: false);
      response2.fold((l) => op2 = false, (r) => op2 = true);
    } else {
      final response3 = await adminService.updatePersonalInfo(admin: admin);

      response3.fold((l) => op3 = false, (r) => op3 = true);
    }
    return op1 && op2 && op3;
  }
}
