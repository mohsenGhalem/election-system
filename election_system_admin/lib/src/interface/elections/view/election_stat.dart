import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/theme/app_theme.dart';
import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../models/candidate.dart';
import '../../../services/election_service.dart';

class ElectionStat extends StatefulWidget {
  final String name;
  final String id;
  const ElectionStat({super.key, required this.name, required this.id});

  @override
  State<ElectionStat> createState() => _ElectionStatState();
}

class _ElectionStatState extends State<ElectionStat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          '${widget.name} Statistics',
          style: const TextStyle(color: Colors.white),
        ),
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: getVoteCount(id: widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<CandidateElectionVoteCount> candidates = snapshot.data ?? [];

            if (candidates.isEmpty) {
              return const EmptyWidget();
            }

            return ListView.builder(
              itemCount: candidates.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('votes :'),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            candidates[index].vote_count.toString(),
                          ),
                        )
                      ],
                    ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1} ',
                          style: AppTheme.bodyStyle,
                        ),
                        const SizedBox(width: 5),
                        CircleAvatar(
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
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Future<List<CandidateElectionVoteCount>> getVoteCount(
      {required String id}) async {
    final ElectionService electionService =
        ElectionServiceImpl(client: Supabase.instance.client);
    List<CandidateElectionVoteCount> candidates = [];

    final result = await electionService.getVoteCount(id: id);
    result.fold(
      (failure) => Get.snackbar(
        'Error',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (data) => candidates = data,
    );
    return candidates;
  }
}
