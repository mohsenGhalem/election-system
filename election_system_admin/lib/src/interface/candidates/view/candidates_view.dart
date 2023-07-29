import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../models/candidate.dart';
import '../../../services/candidate_service.dart';
import '../controller/candidates_controller.dart';
import 'candidate_drawer.dart';

class CandidatesView extends StatelessWidget {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CandidateController candidateController = Get.put(
      CandidateController(
        candidateService: CandidateServiceImple(
          supabase: Supabase.instance.client,
        ),
      ),
    );
    return Scaffold(
      key: candidateController.scaffoldKey,
      endDrawer: CandidateDarwer(controller: candidateController),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: candidateController.getAllCandidates(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Candidate> candidates = snapshot.data ?? [];

              if (candidates.isEmpty) {
                return const EmptyWidget();
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        candidateController.setCurrentId =
                            candidates[index].candidate_id!;
                        candidateController.openDrawer();
                      },
                      title: Text(candidates[index].full_name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Birth Date: ${DateFormat.yMMMMd().format(candidates[index].birth_date)}'),
                          Text(
                              'Statement: ${candidates[index].candidate_statement}'),
                        ],
                      ),
                      leading: CircleAvatar(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            image: candidates[index].candidate_image == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        candidates[index].candidate_image ??
                                            ''),
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
