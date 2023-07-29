import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/theme/app_theme.dart';
import '../../../common/widgets/empty_widget.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../services/dashboard_services.dart';
import '../controller/dashboard_controller.dart';
import 'election_list_tile.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController(
        dashboardService:
            DashboardServiceImpl(client: Supabase.instance.client)));

    return Scaffold(
      key: controller.scaffoldKey,
      endDrawer: const Drawer(
        width: 500,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child:
                      CardInfoDahsboard(future: controller.getElectionCount())),
              Expanded(
                  child: CardInfoDahsboard(
                      future: controller.getCandidateCount())),
              Expanded(
                  child: CardInfoDahsboard(future: controller.getVoterCount())),
            ],
          ),
          Text(
            'Latest Elections',
            style: AppTheme.titleStyle.copyWith(color: Colors.white),
          ),
          GenerateElectionListTile(controller: controller),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Candidates',
                      style: AppTheme.titleStyle.copyWith(color: Colors.white),
                    ),
                    GeneratePersonListTile(controller: controller),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Voters',
                      style: AppTheme.titleStyle.copyWith(color: Colors.white),
                    ),
                    GeneratePersonListTile(
                        controller: controller, is_voter: true),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class GeneratePersonListTile extends StatelessWidget {
  final bool is_voter;
  const GeneratePersonListTile({
    super.key,
    required this.controller,
    this.is_voter = false,
  });

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Card(
            color: Colors.cyan,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<dynamic>>(
                future: is_voter
                    ? controller.getNewVoters()
                    : controller.getNewCandidates(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final List<dynamic> list = snapshot.data ?? [];

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
                                  is_voter
                                      ? list[index].voter_img ?? ''
                                      : list[index].candidate_image ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image);
                                  },
                                ),
                              ),
                              title: Text(list[index].full_name),
                              subtitleTextStyle:
                                  const TextStyle(color: Colors.grey),
                              subtitle: Text(
                                is_voter
                                    ? list[index].address
                                    : list[index].candidate_statement,
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
          ),
        )
      ],
    );
  }
}

class CardInfoDahsboard extends StatelessWidget {
  const CardInfoDahsboard({super.key, required this.future});

  final Future<dynamic>? future;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<dynamic> list = snapshot.data ?? [];
                if (list.isEmpty) {
                  return const EmptyWidget();
                } else {
                  return Column(
                    children: [
                      Text(
                        list[0].count.toString(),
                        style: AppTheme.headerStyle,
                      ),
                      Text(list[0].title),
                      if (list.length > 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            ...List.generate(
                              list.length - 1,
                              (index) => Text(
                                  "${list[index + 1].count} ${list[index + 1].title}"),
                            )
                          ],
                        )
                    ],
                  );
                }
              }
              return const LoadingWidget();
            }),
      ),
    );
  }
}
