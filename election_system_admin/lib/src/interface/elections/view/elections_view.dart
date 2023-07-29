import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/widgets/loading_widget.dart';
import '../../../services/election_service.dart';
import '../controller/election_controller.dart';
import 'add_election/add_election_view.dart';
import 'election_drawer.dart';

class ElectionView extends StatelessWidget {
  const ElectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final ElectionController controller = Get.put(ElectionController(
        electionService:
            ElectionServiceImpl(client: Supabase.instance.client)));
    return Obx(
      () => Scaffold(
        key: controller.scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(Icons.add),
          onPressed: () {
            Get.to(const AddElectionView());
          },
          label: const Text('Create Election'),
        ),
        endDrawer: controller.electionOrCandidate.value ==
                ElectionOrCandidate.candidate
            ? ElectionCandidate(controller: controller)
            : ElectionDarwer(controller: controller),
        body: FutureBuilder(
          future: controller.getAllElection(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List list = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        controller.setCurrentId = list[index].election_id;
                        controller.openDrawer();
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          list[index].election_image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image);
                          },
                        ),
                      ),
                      title: Text(list[index].election_name),
                      subtitleTextStyle: const TextStyle(color: Colors.grey),
                      subtitle: Text(
                        list[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
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
