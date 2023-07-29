import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/election_controller.dart';
import '../models/candidate.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/loading_widget.dart';
import '../widgets/snack_bar.dart';

class ElectionVote extends StatelessWidget {
  final ElectionCotroller electionCotroller;

  final String election_id;
  final String voter_id;
  const ElectionVote({
    super.key,
    required this.electionCotroller,
    required this.election_id,
    required this.voter_id,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return FutureBuilder(
          future: electionCotroller.getAcceptedCandidate(election_id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<Candidate> candidates = snapshot.data ?? [];

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
                      trailing: const Text('vote'),
                      onTap: () async {
                        Get.dialog(
                          LoadingDialog(
                            future: electionCotroller.voteForCandidate(
                                election_id,
                                candidates[index].candidate_id!,
                                voter_id),
                          ),
                          //barrierDismissible: false
                        ).then(
                          (value) {
                            if (value == true) {
                              Get.showSnackbar(
                                buildSnackBar(
                                    title: 'Success',
                                    color: Colors.green,
                                    message: 'vote successfully'),
                              );
                            } else {
                              Get.showSnackbar(
                                buildSnackBar(
                                    title: 'Error',
                                    color: Colors.red,
                                    message: 'try again later'),
                              );
                            }
                            Get.offNamedUntil('/home', (route) => false);
                          },
                        );
                      },
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
