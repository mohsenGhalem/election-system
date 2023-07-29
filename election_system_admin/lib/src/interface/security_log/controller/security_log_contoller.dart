import 'package:get/get.dart';

import '../../../models/security_log.dart';
import '../../../services/security_log_service.dart';

class SecurityLogController extends GetxController {
  SecurityLogService securityLogService;

  SecurityLogController({required this.securityLogService});
  Future<List<SecurityLog>> getAllSecuirtyLogs() async {
    List<SecurityLog> securityLog = [];
    final result = await securityLogService.getAllSecurityLog();
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => securityLog = data,
    );
    return securityLog;
  }
}
