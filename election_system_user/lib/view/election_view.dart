import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/election_controller.dart';
import '../models/election.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/loading_widget.dart';
import '../widgets/snack_bar.dart';
import 'election_result.dart';
import 'election_vote.dart';

class ElectionView extends StatelessWidget {
  final String electionId;
  const ElectionView({super.key, required this.electionId});

  @override
  Widget build(BuildContext context) {
    final ElectionCotroller electionController = Get.put(ElectionCotroller());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Election"),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: electionController.getElection(id: electionId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Election election = snapshot.data;

            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Image.network(
                  election.election_image ?? '',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Center(
                      child: Icon(Icons.image),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        election.election_name,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[800],
                        ),
                      ),
                      Container(height: 10),
                      Text(
                        election.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const Text(
                        'DEADLINE DATE',
                      ),
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(election.deadline_date),
                      ),
                      Divider(color: Colors.grey.withOpacity(0.7)),
                      const Text(
                        'START DATE',
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(election.start_date),
                      ),
                      Divider(color: Colors.grey.withOpacity(0.7)),
                      const Text(
                        'END DATE',
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(election.end_date),
                      ),
                      Divider(color: Colors.grey.withOpacity(0.7)),
                      Text(
                        "Eection is ${election.isActive ? 'ACTIVE' : 'INACTIVE'}",
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: electionController
                                      .user_data['registred'] ==
                                  true
                              ? null
                              : () async {
                                  if (electionController
                                          .user_data['user_type'] ==
                                      'candidate') {
                                    Get.dialog(
                                      LoadingDialog(
                                        future: electionController
                                            .enrollCandidateInElection(
                                          electionController.user_data['id'],
                                          electionId,
                                        ),
                                      ),
                                    ).then(
                                      (value) {
                                        if (value == true) {
                                          Get.showSnackbar(
                                            buildSnackBar(
                                                title: 'Success',
                                                color: Colors.green,
                                                message:
                                                    'Request sent successfully'),
                                          );
                                        } else {
                                          Get.showSnackbar(
                                            buildSnackBar(
                                                title: 'Error',
                                                color: Colors.red,
                                                message:
                                                    'failed to sent request'),
                                          );
                                        }
                                        Get.delete<ElectionCotroller>();
                                        Get.offNamedUntil(
                                            '/home', (route) => false);
                                      },
                                    );
                                  } else {
                                    Get.dialog(
                                      LoadingDialog(
                                        future: electionController
                                            .enrollVoterInElection(
                                                electionController
                                                    .user_data['id'],
                                                electionId),
                                      ),
                                    ).then(
                                      (value) {
                                        if (value == true) {
                                          Get.back();
                                          Get.bottomSheet(
                                            ElectionVote(
                                              electionCotroller:
                                                  electionController,
                                              election_id: electionId,
                                              voter_id: electionController
                                                  .user_data['id'],
                                            ),
                                          );
                                        } else {
                                          Get.showSnackbar(
                                            buildSnackBar(
                                                title: 'Error',
                                                color: Colors.red,
                                                message: 'an error occured !'),
                                          );
                                          Get.delete<ElectionCotroller>();
                                          Get.offNamedUntil(
                                              '/home', (route) => false);
                                        }
                                      },
                                    );
                                  }
                                },
                          child: Text(
                              electionController.user_data['registred'] == true
                                  ? 'Already enrolled'
                                  : 'Enroll'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (election.end_date.isAfter(DateTime.now()))
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () => Get.bottomSheet(
                            ElectionResult(
                              getVoteCount: electionController.getVoteCount(
                                  id: electionId),
                            ),
                          ),
                          child: const Text('View result'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          return const EmptyWidget();
        },
      ),
    );
  }
}
