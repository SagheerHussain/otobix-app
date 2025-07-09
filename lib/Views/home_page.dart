import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Widgets/button_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController getxController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withValues(alpha: .1),
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 5),
                  //   ),
                  // ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Search bar + city filter
                    _buildSearchBar(context),
                    const SizedBox(height: 10),

                    _buildSegments(),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Filter 1 Text
                        GestureDetector(
                          onTap:
                              () => _showFilterDialog(
                                context: Get.context!,
                                title: 'Filter Cars',
                              ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Filter',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '|',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Filter 2 Text
                        GestureDetector(
                          onTap:
                              () => _showFilterDialog(
                                context: Get.context!,
                                title: 'Sort by',
                              ),
                          child: Row(
                            children: [
                              Text(
                                'Sort',
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.sort, size: 14, color: Colors.grey),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Divider(color: AppColors.gray.withValues(alpha: .5)),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 10),

            // const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(
                      () =>
                          getxController.selectedSegment.value != 'live'
                              ? _buildOcb70Screen()
                              : _buildLiveCarsScreen(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: getxController.searchController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: AppColors.gray.withValues(alpha: .5),
            fontSize: 12,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: AppColors.green, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 10,
          ),
          suffixIcon: Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  alignment: Alignment.centerRight,
                  value: getxController.selectedCity.value,

                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      getxController.selectedCity.value = value;
                    }
                  },
                  items:
                      getxController.cities
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(
                                city,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegments() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        // color: AppColors.gray.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: AdvancedSegment(
        controller: getxController.selectedSegmentNotifier,
        segments: getxController.segments,
        activeStyle: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        inactiveStyle: const TextStyle(color: AppColors.black),
        backgroundColor: AppColors.gray.withValues(alpha: .1),
        sliderDecoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(50),
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget _buildLiveCarsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cars List
        _buildCarsList(),
      ],
    );
  }

  void _showFilterDialog({
    required BuildContext context,
    required String title,
  }) {
    if (title == 'Filter Cars') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _buildFilterSheet(),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _buildSortSheet(),
      );
    }
  }

  Widget _buildFilterSheet() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Filter Cars',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Fuel Type checkboxes
          Text('Fuel Type', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text('Petrol'),
                selected: false,
                onSelected: (val) {},
              ),
              FilterChip(
                label: Text('Diesel'),
                selected: false,
                onSelected: (val) {},
              ),
              FilterChip(
                label: Text('CNG'),
                selected: false,
                onSelected: (val) {},
              ),
              FilterChip(
                label: Text('Electric'),
                selected: false,
                onSelected: (val) {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Range Slider
          Text(
            'Price Range (INR Lakhs)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Min Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Max Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Year
          Text(
            'Manufacturing Year',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            isExpanded: true,
            value: 2022,
            items: [
              for (var year in List.generate(10, (i) => 2025 - i))
                DropdownMenuItem(value: year, child: Text(year.toString())),
            ],
            onChanged: (val) {},
          ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  text: 'Reset',
                  textColor: AppColors.white,
                  backgroundColor: AppColors.red,
                  isLoading: false.obs,
                  onTap: () {
                    Navigator.pop(Get.context!);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ButtonWidget(
                  text: 'Apply',
                  isLoading: false.obs,
                  onTap: () {
                    Navigator.pop(Get.context!);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortSheet() {
    RxString selectedSort = 'Price Low to High'.obs;

    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...[
              'Price Low to High',
              'Price High to Low',
              'Newest First',
              'Oldest First',
            ].map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedSort.value,
                onChanged: (value) {
                  if (value != null) {
                    selectedSort.value = value;
                  }
                },
              );
            }),
            const SizedBox(height: 16),
            ButtonWidget(
              text: 'Apply',
              width: double.infinity,
              isLoading: false.obs,
              onTap: () {
                Navigator.pop(Get.context!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: getxController.cars.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final car = getxController.cars[index];
        return Card(
          elevation: 4,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Car Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        car.imageUrl,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.carImage,
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Car details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'INR ${NumberFormat.decimalPattern('en_IN').format(car.price)}/-',

                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                car.year.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.speed, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${NumberFormat.decimalPattern('en_IN').format(car.kmDriven)} km',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.local_gas_station,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                car.fuelType,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                car.location,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                car.isInspected == true
                    ? Column(
                      children: [
                        Divider(),
                        // const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 14,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Inspected 8.2/10',
                              style: TextStyle(
                                fontSize: 10,
                                // fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildCarsList() {
  //   // Example dummy cars
  //   final cars = [
  //     'Toyota Corolla',
  //     'Honda Civic',
  //     'Suzuki Swift',
  //     'Hyundai Elantra',
  //   ];

  //   return ListView.separated(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: cars.length,
  //     separatorBuilder: (_, __) => Divider(),
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.directions_car),
  //         title: Text(cars[index]),
  //       );
  //     },
  //   );
  // }

  // Widget _buildLiveCarsScreen1() {
  //   return Column(
  //     children: [
  //       Obx(
  //         () => DropdownButton<String>(
  //           value: getxController.liveFilter1.value,
  //           onChanged: (val) {
  //             if (val != null) {
  //               getxController.liveFilter1.value = val;
  //             }
  //           },
  //           items:
  //               getxController.liveFilters1
  //                   .map((f) => DropdownMenuItem(value: f, child: Text(f)))
  //                   .toList(),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Obx(
  //         () => DropdownButton<String>(
  //           value: getxController.liveFilter2.value,
  //           onChanged: (val) {
  //             if (val != null) {
  //               getxController.liveFilter2.value = val;
  //             }
  //           },
  //           items:
  //               getxController.liveFilters2
  //                   .map((f) => DropdownMenuItem(value: f, child: Text(f)))
  //                   .toList(),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildOcb70Screen() {
    return Center(child: Text('OCB 70 Screen'));
    //   return Obx(
    //     () => DropdownButton<String>(
    //       value: getxController.ocbFilter.value,
    //       onChanged: (val) {
    //         if (val != null) {
    //           getxController.ocbFilter.value = val;
    //         }
    //       },
    //       items:
    //           getxController.ocbFilters
    //               .map((f) => DropdownMenuItem(value: f, child: Text(f)))
    //               .toList(),
    //     ),
    //   );
  }
}
