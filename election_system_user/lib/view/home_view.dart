import '../services/local_storage_service.dart';
import 'election_view.dart';

import '../controller/home_controller.dart';
import '../models/election.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Elections"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              LocalStorageService localStorageService =
                  LocalStorageServiceImpl();
              await localStorageService.clearCurrentUser();
            },
            label: const Icon(Icons.logout),
            icon: const Text("Logout"),
          )
        ],
      ),
      body: FutureBuilder(
        future: homeController.getActiveElection(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final List<Election> elections = snapshot.data ?? [];

            if (elections.isEmpty) {
              return const EmptyWidget();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: elections.length,
              itemBuilder: (BuildContext context, int index) {
                final Election election = elections[index];
                return InkWell(
                  onTap: () {
                    Get.to(
                      ElectionView(
                        electionId: election.election_id ?? '',
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 5),
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
}
