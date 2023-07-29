import 'package:election_system_admin/src/interface/elections/view/election_stat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/app_theme.dart';
import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/loading_dialog.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/snack_bar.dart';
import '../../../models/candidate.dart';
import '../../../models/election.dart';
import '../controller/election_controller.dart';
import 'add_election/add_election_view.dart';

class ElectionDarwer extends StatelessWidget {
  final ElectionController controller;
  const ElectionDarwer({
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
          actions: [
            IconButton(
              onPressed: () {
                Get.to(AddElectionView(
                  initialData: controller.electionData!.toMap(),
                ));
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      backgroundColor: Colors.white,
                      icon: const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      title: const Text('Warning'),
                      content: const Text('Are you sure about this action !'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('cancel'),
                        ),
                        TextButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text('confirm')),
                      ],
                    ),
                  ).then(
                    (value) {
                      if (value == true) {
                        Get.dialog(
                          LoadingDialog(
                            future: controller.deleteElection(
                                election_id: controller.currentId),
                          ),
                          barrierDismissible: false,
                        ).then(
                          (value) {
                            Get.back();
                            if (value == true) {
                              Get.showSnackbar(buildSnackBar(
                                  title: 'Success',
                                  color: Colors.green,
                                  message: 'Election deleted successfully'));
                            } else {
                              Get.showSnackbar(
                                buildSnackBar(
                                    title: 'Error',
                                    color: Colors.red,
                                    message: 'An error occured try again'),
                              );
                              controller.closeDrawer();
                            }
                          },
                        );
                      }
                    },
                  );
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
        body: FutureBuilder(
          future: controller.getElectionById(id: controller.currentId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final Election election = snapshot.data;

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  SizedBox(
                    height: 200,
                    child: Card(
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          election.election_image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    election.election_name,
                    style: AppTheme.titleStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Text(
                    election.description,
                    style: AppTheme.bodyStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Text(
                    'DEADLINE DATE',
                    style: AppTheme.bodyStyle,
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(election.deadline_date),
                    style: AppTheme.bodyStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Text(
                    'START DATE',
                    style: AppTheme.bodyStyle,
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(election.start_date),
                    style: AppTheme.bodyStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Text(
                    'END DATE',
                    style: AppTheme.bodyStyle,
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(election.end_date),
                    style: AppTheme.bodyStyle,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  Text(
                    "Eection is ${election.isActive ? 'ACTIVE' : 'INACTIVE'}",
                    style: AppTheme.bodyStyle.copyWith(
                        color: election.isActive ? Colors.green : Colors.red),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      controller.setElectionOrCandidate =
                          ElectionOrCandidate.candidate;
                      controller.openDrawer();
                    },
                    child: const Text('Get Candidates Details'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Get.to(
                        ElectionStat(
                            name: election.election_name,
                            id: election.election_id!),
                      );
                    },
                    child: const Text('Get Election Statistics'),
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

class ElectionCandidate extends StatelessWidget {
  final ElectionController controller;
  const ElectionCandidate({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 500,
      child: DefaultTabController(
        length: 3,
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
            bottom: const TabBar(
              dividerColor: Colors.grey,
              tabs: [
                Tab(text: 'requests', icon: Icon(Icons.notification_add)),
                Tab(text: 'accpeted', icon: Icon(Icons.check)),
                Tab(text: 'refused', icon: Icon(Icons.block)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ///Requests
              FutureBuilder(
                future:
                    controller.getElectionRequests(id: controller.currentId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Candidate> list = snapshot.data ?? [];

                    if (list.isEmpty) {
                      return const EmptyWidget();
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: list.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  list[index].candidate_image ?? '',
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        backgroundColor: Colors.white,
                                        icon: const Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                        ),
                                        title: const Text('Warning'),
                                        content: const Text(
                                            'Are you sure about this action !'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('cancel'),
                                          ),
                                          TextButton(
                                              onPressed: () =>
                                                  Get.back(result: true),
                                              child: const Text('confirm')),
                                        ],
                                      ),
                                    ).then(
                                      (value) {
                                        if (value == true) {
                                          Get.dialog(
                                            LoadingDialog(
                                              future: controller
                                                  .refuseCandidateToElection(
                                                candidate_id:
                                                    list[index].candidate_id!,
                                                election_id:
                                                    controller.currentId,
                                              ),
                                            ),
                                            barrierDismissible: false,
                                          ).then(
                                            (value) {
                                              Get.back();
                                              if (value == true) {
                                                Get.showSnackbar(buildSnackBar(
                                                    title: 'Success',
                                                    color: Colors.green,
                                                    message:
                                                        'Request refused successfully'));
                                              } else {
                                                Get.showSnackbar(
                                                  buildSnackBar(
                                                      title: 'Error',
                                                      color: Colors.red,
                                                      message:
                                                          'An error occured try again'),
                                                );
                                                controller.closeDrawer();
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        backgroundColor: Colors.white,
                                        icon: const Icon(
                                          Icons.warning,
                                          color: Colors.green,
                                        ),
                                        title: const Text('Warning'),
                                        content: const Text(
                                            'Are you sure about this action !'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('cancel'),
                                          ),
                                          TextButton(
                                              onPressed: () =>
                                                  Get.back(result: true),
                                              child: const Text('confirm')),
                                        ],
                                      ),
                                    ).then(
                                      (value) {
                                        if (value == true) {
                                          Get.dialog(
                                            LoadingDialog(
                                              future: controller
                                                  .acceptCandidateToElection(
                                                candidate_id:
                                                    list[index].candidate_id!,
                                                election_id:
                                                    controller.currentId,
                                              ),
                                            ),
                                            barrierDismissible: false,
                                          ).then(
                                            (value) {
                                              Get.back();
                                              if (value == true) {
                                                Get.showSnackbar(buildSnackBar(
                                                    title: 'Success',
                                                    color: Colors.green,
                                                    message:
                                                        'Request accepted successfully'));
                                              } else {
                                                Get.showSnackbar(
                                                  buildSnackBar(
                                                      title: 'Error',
                                                      color: Colors.red,
                                                      message:
                                                          'An error occured try again'),
                                                );
                                                controller.closeDrawer();
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                )
                              ],
                            ),
                            title: Text(list[index].full_name),
                            subtitle: Text(
                                'Birth date: ${DateFormat('dd MMM yyyy').format(list[index].birth_date)}'),
                          ),
                        ),
                      );
                    }
                  }
                  return const LoadingWidget();
                },
              ),

              ///Accepted
              FutureBuilder(
                future: controller.getElectionAcceptedCaandidate(
                    id: controller.currentId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Candidate> list = snapshot.data ?? [];

                    if (list.isEmpty) {
                      return const EmptyWidget();
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: list.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  list[index].candidate_image ?? '',
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                            ),
                            title: Text(list[index].full_name),
                            subtitle: Text(
                                'Birth date: ${DateFormat('dd MMM yyyy').format(list[index].birth_date)}'),
                          ),
                        ),
                      );
                    }
                  }
                  return const LoadingWidget();
                },
              ),

              ///Refused
              FutureBuilder(
                future: controller.getElectionRefusedCaandidate(
                    id: controller.currentId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Candidate> list = snapshot.data ?? [];

                    if (list.isEmpty) {
                      return const EmptyWidget();
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: list.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  list[index].candidate_image ?? '',
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                            ),
                            trailing: TextButton.icon(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    actionsAlignment: MainAxisAlignment.center,
                                    backgroundColor: Colors.white,
                                    icon: const Icon(
                                      Icons.warning,
                                      color: Colors.green,
                                    ),
                                    title: const Text('Warning'),
                                    content: const Text(
                                        'Are you sure about this action !'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('cancel'),
                                      ),
                                      TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: const Text('confirm')),
                                    ],
                                  ),
                                ).then(
                                  (value) {
                                    if (value == true) {
                                      Get.dialog(
                                        LoadingDialog(
                                          future: controller
                                              .changeCandidateInElection(
                                            candidate_id:
                                                list[index].candidate_id!,
                                            election_id: controller.currentId,
                                            status: 'accepted',
                                          ),
                                        ),
                                        barrierDismissible: false,
                                      ).then(
                                        (value) {
                                          Get.back();
                                          if (value == true) {
                                            Get.showSnackbar(buildSnackBar(
                                                title: 'Success',
                                                color: Colors.green,
                                                message:
                                                    'Request accepted successfully'));
                                          } else {
                                            Get.showSnackbar(
                                              buildSnackBar(
                                                  title: 'Error',
                                                  color: Colors.red,
                                                  message:
                                                      'An error occured try again'),
                                            );
                                            controller.closeDrawer();
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                              label: const Text('accept'),
                              icon: const Icon(Icons.check),
                            ),
                            title: Text(list[index].full_name),
                            subtitle: Text(
                                'Birth date: ${DateFormat('dd MMM yyyy').format(list[index].birth_date)}'),
                          ),
                        ),
                      );
                    }
                  }
                  return const LoadingWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
