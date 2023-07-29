import 'package:election_system_admin/src/interface/admin_profile/admin_profile_view.dart';
import 'package:election_system_admin/src/models/security_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/admin.dart';
import '../../../services/local_storage_service.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.size,
    required this.url,
  });

  final Size size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.78,
      height: 50,
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              LocalStorageService localStorageService =
                  LocalStorageServiceImpl();
              Admin admin = await localStorageService.getCurrentUser();
              Get.to(AdminProfileView(userData: admin.toMap()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              final LocalStorageService localStorageService =
                  LocalStorageServiceImpl();
              await localStorageService.clearCurrentUser();
              final client = Supabase.instance.client;
              SecurityLog securityLog = SecurityLog(
                  user_id: client.auth.currentUser!.id,
                  action_description: 'Logout from the system',
                  log_date: DateTime.now());

              await client.from('security_log').insert(securityLog.toMap());
              await client.auth.signOut();
              Get.offAllNamed('/auth');
            },
          ),
        ],
      ),
    );
  }
}
