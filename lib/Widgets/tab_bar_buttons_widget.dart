import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';

class TabBarButtonsWidget extends StatelessWidget {
  final List<String> titles;
  final List<int> counts;
  final double titleSize;
  final double countSize;
  final double tabsHeight;
  final double spaceFromSides;
  final TabController controller;
  final RxInt selectedIndex;

  const TabBarButtonsWidget({
    super.key,
    required this.titles,
    required this.counts,
    required this.controller,
    required this.selectedIndex,
    this.titleSize = 12,
    this.countSize = 10,
    this.tabsHeight = 35,
    this.spaceFromSides = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: Container(
          height: tabsHeight,
          margin: EdgeInsets.symmetric(horizontal: spaceFromSides),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: AppColors.grey.withValues(alpha: .2),
          ),
          child: TabBar(
            controller: controller,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: const BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            tabs: List.generate(
              titles.length,
              (index) => TabItem(
                title: titles[index],
                count: counts[index],
                selected: selectedIndex.value == index,
                titleSize: titleSize,
                countSize: countSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
