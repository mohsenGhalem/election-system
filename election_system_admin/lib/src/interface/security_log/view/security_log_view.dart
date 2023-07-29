import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../models/security_log.dart';
import '../../../services/security_log_service.dart';
import '../controller/security_log_contoller.dart';

class SecurityLogView extends StatelessWidget {
  const SecurityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    final SecurityLogController controller = Get.put(
      SecurityLogController(
        securityLogService: SecurityLogServiceImpl(
          client: Supabase.instance.client,
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Security Log'),
        ),
        body: FutureBuilder(
          future: controller.getAllSecuirtyLogs(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<SecurityLog> list = snapshot.data;

              if (list.isEmpty) {
                return const EmptyWidget();
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: Icon(Icons.bar_chart),
                      ),
                      title: Text(list[index].action_description),
                      subtitle: Text('done by user :${list[index].user_id}'),
                    ),
                  );
                },
              );
            } else {
              return const LoadingWidget();
            }
          },
        ));
  }
}

