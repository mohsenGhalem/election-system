import 'package:flutter/material.dart';

import '../home_page_conttroller.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final HomePageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width * 0.22,
      padding: const EdgeInsets.all(8.0),
      color: Colors.blueGrey,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: Image.asset('assets/images/logo.png'),
          ),
          const SizedBox(height: 8),
          const Text(
            "Election System Adminstration",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 15),
          ...List.generate(
            controller.pages.length,
            (index) {
              final item = controller.pages[index];
              return Card(
                color: index == controller.pageIndex.value
                    ? Colors.cyan
                    : null,
                child: ListTile(
                  title: Text(item['name']),
                  textColor: index == controller.pageIndex.value
                      ? Colors.white
                      : null,
                  iconColor: index == controller.pageIndex.value
                      ? Colors.white
                      : null,
                  leading: item['icon'],
                  onTap: () {
                    controller.setIndex = index;
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}