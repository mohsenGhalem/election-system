import 'package:election_system_admin/src/common/widgets/empty_widget.dart';
import 'package:intl/intl.dart';

import '../../../models/election.dart';
import '../controller/candidates_controller.dart';
import '../../../models/candidate.dart';
import 'package:flutter/material.dart';

import '../../../common/theme/app_theme.dart';
import '../../../common/widgets/loading_widget.dart';

class CandidateDarwer extends StatelessWidget {
  final CandidateController controller;
  const CandidateDarwer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 500,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: TextButton.icon(
            onPressed: () {
              controller.closeDrawer();
            },
            icon: const Icon(Icons.close),
            label: const Text('close'),
          ),
        ),
        body: FutureBuilder(
          future:
              controller.getCandidate(id: controller.currentCandidateId.value),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final Candidate candidate = snapshot.data;

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue)),
                    child: ClipOval(
                      child: Image.network(
                        candidate.candidate_image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      ),
                    ),
                  ),
                  Text(
                    candidate.full_name,
                    style: AppTheme.titleStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Text(
                    candidate.candidate_statement,
                    style: AppTheme.bodyStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Candidate Elections',
                      style: AppTheme.bodyStyle,
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  FutureBuilder(
                    future: controller.getCandidateElections(
                        id: controller.currentCandidateId.value),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<ElectionCandidate> list = snapshot.data ?? [];

                        if (list.isEmpty) {
                          return const EmptyWidget();
                        }

                        return Column(
                          children: List.generate(
                            list.length,
                            (index) {
                              return Card(
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      list[index].election_image ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.image);
                                      },
                                    ),
                                  ),
                                  trailing:
                                      Text('status : ${list[index].status}'),
                                  title: Text(list[index].election_name),
                                  subtitleTextStyle:
                                      const TextStyle(color: Colors.grey),
                                  subtitle: Text(
                                    'Start date :${DateFormat.yMMMd().format(list[index].start_date)}\nEnd date :${DateFormat.yMMMd().format(list[index].end_date)}',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const LoadingWidget();
                    },
                  ),
                ],
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
