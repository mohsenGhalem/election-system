import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/widgets/loading_widget.dart';
import '../../../models/admin.dart';
import '../../../services/admin_services.dart';
import '../controller/request_controller.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RequestController(
        adminService: AdminServiceImple(
          supabase: Supabase.instance.client,
        ),
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const TabBar(
          tabs: [
            Tab(
              text: 'Admin Requests',
              icon: Icon(Icons.person_add),
            ),
            Tab(
              icon: Icon(Icons.block),
              text: 'Blokced Admins',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: controller.getAdminRequets(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Admin> list = snapshot.data ?? [];

                  if (list.isEmpty) {
                    return const EmptyWidget();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final Admin admin = list[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(admin.full_name[0]),
                            ),
                            title: Text(admin.full_name),
                            subtitle: Text(admin.admin_status),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final result =
                                        await controller.changeStatusOfAdmin(
                                      id: admin.admin_id!,
                                      status: 'accepted',
                                    );
                                    if (result) {
                                      Get.showSnackbar(buildSnackBar(
                                          title: 'Sucess',
                                          color: Colors.green,
                                          message: 'Admin accepted'));
                                    } else {
                                      Get.showSnackbar(buildSnackBar(
                                          title: 'Error',
                                          color: Colors.green,
                                          message: 'Something went wrong'));
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result =
                                        await controller.changeStatusOfAdmin(
                                      id: admin.admin_id!,
                                      status: 'rejected',
                                    );
                                    if (result) {
                                      Get.snackbar(
                                        'Success',
                                        'Admin rejected',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Something went wrong',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return const LoadingWidget();
              },
            ),
            FutureBuilder(
              future: controller.getBlockedAdmins(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Admin> list = snapshot.data ?? [];

                  if (list.isEmpty) {
                    return const EmptyWidget();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final Admin admin = list[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(admin.full_name[0]),
                            ),
                            title: Text(admin.full_name),
                            subtitle: Text(admin.admin_status),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    final result =
                                        await controller.changeStatusOfAdmin(
                                      id: admin.admin_id!,
                                      status: 'accepted',
                                    );
                                    if (result) {
                                      Get.showSnackbar(buildSnackBar(
                                          title: 'Sucess',
                                          color: Colors.green,
                                          message: 'Admin accepted'));
                                    } else {
                                      Get.showSnackbar(buildSnackBar(
                                          title: 'Error',
                                          color: Colors.green,
                                          message: 'Something went wrong'));
                                    }
                                  },
                                  label: const Text('unblock admin'),
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return const LoadingWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
