import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/widgets/loading_widget.dart';
import '../../../models/voter.dart';
import '../../../services/voter_service.dart';
import '../controller/voter_controller.dart';

class VotersView extends StatelessWidget {
  const VotersView({super.key});

  @override
  Widget build(BuildContext context) {
    final VoterController voterController = Get.put(VoterController(
      voterService: VoterServiceImpl(client: Supabase.instance.client),
    ));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: voterController.getAllVoters(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Voter> data = snapshot.data ?? [];
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(data[index].full_name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Birth Date: ${DateFormat.yMMMMd().format(data[index].birth_date)}'),
                          Text('Address: ${data[index].address}'),
                        ],
                      ),
                      leading: CircleAvatar(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            image: data[index].voter_img == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        data[index].voter_img ?? ''),
                                  ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
