import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page_conttroller.dart';
import 'widgets/header_widget.dart';
import 'widgets/side_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.put(HomePageController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Obx(() {
          return Row(
            children: [
              SideBarWidget(size: size, controller: controller),
              Expanded(
                child: Column(
                  children: [
                    HeaderWidget(
                      size: size,
                      url: controller.admin.value != null
                          ? controller.admin.value!.admin_image
                          : '',
                    ),
                    Expanded(
                        child: controller.pages[controller.pageIndex.value]
                            ['page'])
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
