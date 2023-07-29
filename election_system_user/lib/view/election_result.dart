import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/candidate.dart';

class ElectionResult extends StatelessWidget {
  final Future<List<CandidateElectionVoteCount>> getVoteCount;
  const ElectionResult({super.key, required this.getVoteCount});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return FutureBuilder(
          future: getVoteCount,
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

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            }
            return const EmptyWidget();
          },
        );
      },
    );
  }
}
