import 'package:flutter/material.dart';

import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../models/election.dart';
import '../controller/dashboard_controller.dart';

class GenerateElectionListTile extends StatelessWidget {
  const GenerateElectionListTile({
    super.key,
    required this.controller,
  });

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Election>>(
          future: controller.getNewElections(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Election> list = snapshot.data ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
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
              } else {
                return const EmptyWidget();
              }
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
