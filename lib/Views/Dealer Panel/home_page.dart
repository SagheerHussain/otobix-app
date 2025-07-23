import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Controllers/tab_bar_buttons_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Views/Dealer%20Panel/live_bids_section.dart';
import 'package:otobix/Views/Dealer%20Panel/marketplace_section.dart';
import 'package:otobix/Views/Dealer%20Panel/oto_buy_section.dart';
import 'package:otobix/Views/Dealer%20Panel/upcoming_section.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/tab_bar_buttons_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController getxController = Get.put(HomeController());
  final tabBarController = Get.put(TabBarButtonsController(tabLength: 4));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            // TabBar Screens / Sections
            Padding(
              padding: const EdgeInsets.only(top: 150, left: 15, right: 15),
              child: TabBarView(
                controller: tabBarController.tabController,
                children: [
                  LiveBidsSection(),
                  UpcomingSection(),
                  OtoBuySection(),
                  MarketplaceSection(),
                ],
              ),
            ),

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
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),

                    // Search bar + city filter
                    _buildSearchBar(context),
                    const SizedBox(height: 15),

                    // TabBar Buttons
                    TabBarButtonsWidget(
                      titles: ['Live', 'Upcoming', 'OtoBuy', 'Marketplace'],
                      counts: [
                        getxController.liveCarsCount.value,
                        getxController.upcomingCarsCount.value,
                        getxController.otoBuyCarsCount.value,
                        getxController.marketplaceCarsCount.value,
                      ],
                      controller: tabBarController.tabController,
                      selectedIndex: tabBarController.selectedIndex,
                      titleSize: 9,
                      countSize: 6,
                      tabsHeight: 30,
                      spaceFromSides: 15,
                    ),

                    const SizedBox(height: 15),

                    // Filter and Sort buttons
                    _buildFilterAndSortButtons(),
                    const SizedBox(height: 20),
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
    return SizedBox(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextFormField(
          controller: getxController.searchController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: AppColors.grey.withValues(alpha: .5),
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
                child: GestureDetector(
                  onTap: () => _buildStateSelector(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getxController.selectedCity.value,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // suffixIcon: Obx(
            //   () => Padding(
            //     padding: const EdgeInsets.only(right: 20),
            //     child: DropdownButtonHideUnderline(
            //       child: DropdownButton<String>(
            //         alignment: Alignment.centerRight,
            //         value: getxController.selectedCity.value,

            //         icon: const Icon(
            //           Icons.keyboard_arrow_down,
            //           color: Colors.grey,
            //           size: 20,
            //         ),
            //         onChanged: (value) {
            //           if (value != null) {
            //             getxController.selectedCity.value = value;
            //           }
            //         },
            //         items:
            //             getxController.cities
            //                 .map(
            //                   (city) => DropdownMenuItem<String>(
            //                     value: city,
            //                     child: Text(
            //                       city,
            //                       style: TextStyle(
            //                         fontSize: 10,
            //                         color: Colors.black,
            //                       ),
            //                     ),
            //                   ),
            //                 )
            //                 .toList(),
            //       ),
            //     ),
            //   ),
            // ),
          ),
          onChanged: (value) {
            getxController.filteredCars.value =
                getxController.cars
                    .where(
                      (car) =>
                          car.name.toLowerCase().contains(value.toLowerCase()),
                    )
                    .toList();
          },
        ),
      ),
    );
  }

  void _buildStateSelector(BuildContext context) {
    final filteredStates = getxController.cities.obs;
    getxController.searchStateController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for full height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      'Select State',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Search Field
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: getxController.searchStateController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Search states...',
                        hintStyle: TextStyle(
                          color: AppColors.grey.withValues(alpha: .5),
                          fontSize: 12,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: AppColors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: AppColors.green,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 10,
                        ),
                      ),
                      onChanged: (value) {
                        filteredStates.value =
                            getxController.cities
                                .where(
                                  (city) => city.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                                )
                                .toList();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // State List
                  Obx(
                    () => Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: filteredStates.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final city = filteredStates[index];
                          return InkWell(
                            onTap: () {
                              getxController.selectedCity.value = city;
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 25,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.grey.withValues(alpha: .1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(city, style: TextStyle(fontSize: 12)),
                                  Icon(
                                    Icons.location_on,
                                    size: 15,
                                    color: AppColors.green,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Widget _buildChangeSegmentsButton() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       // color: AppColors.gray.withValues(alpha: .1),
  //       borderRadius: BorderRadius.circular(50),
  //     ),
  //     child: AdvancedSegment(
  //       controller: getxController.selectedSegmentNotifier,
  //       segments: getxController.segments,
  //       activeStyle: const TextStyle(
  //         color: AppColors.white,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       inactiveStyle: const TextStyle(color: AppColors.black),
  //       backgroundColor: AppColors.gray.withValues(alpha: .1),
  //       sliderDecoration: BoxDecoration(
  //         color: AppColors.green,
  //         borderRadius: BorderRadius.circular(50),
  //       ),
  //       borderRadius: BorderRadius.circular(50),
  //     ),
  //   );
  // }

  // Filter and Sort buttons
  Widget _buildFilterAndSortButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Filter Button
        GestureDetector(
          // onTap:
          //     () => _showFilterDialog(context: Get.context!, title: 'Filter'),
          onTap:
              () => showModalBottomSheet(
                context: Get.context!,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => _buildFilterContent(),
              ),
          child: Row(
            children: [
              Icon(Icons.filter_alt, size: 14, color: Colors.grey),
              SizedBox(width: 5),
              Text('Filter', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '|',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        //Sort Button
        GestureDetector(
          onTap:
              () => showModalBottomSheet(
                context: Get.context!,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => _buildSortContent(),
              ),
          child: Row(
            children: [
              Text(
                getxController.selectedSegment.value != 'live'
                    ? 'Default'
                    : 'Sort',
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(width: 5),
              Icon(
                getxController.selectedSegment.value != 'live'
                    ? Icons.import_export
                    : Icons.sort,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // // Segments Screens
  // Widget _buildSegmentsScreens() {
  //   return Expanded(
  //     child: SingleChildScrollView(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Obx(
  //             () =>
  //                 getxController.selectedSegment.value != 'live'
  //                     ? Ocb70Section()
  //                     : LiveBidsSection(),
  //           ),
  //           const SizedBox(height: 10),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Filter Content
  Widget _buildFilterContent() {
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
                color: AppColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Filter Cars',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Fuel Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Wrap(
            spacing: 8,
            children:
                ['Petrol', 'Diesel', 'CNG', 'Electric'].map((type) {
                  return Obx(() {
                    final isSelected = getxController.selectedFuelTypesFilter
                        .contains(type);
                    return FilterChip(
                      label: Text(
                        type,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.green : AppColors.black,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.green.withValues(alpha: .1),
                      // backgroundColor: AppColors.gray.withValues(alpha: .1),
                      checkmarkColor: AppColors.green,
                      showCheckmark: true,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        // side: BorderSide(
                        //   color:
                        //       isSelected
                        //           ? AppColors.green.withValues(alpha: .1)
                        //           : AppColors.gray.withValues(alpha: .3),
                        // ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          getxController.selectedFuelTypesFilter.add(type);
                        } else {
                          getxController.selectedFuelTypesFilter.remove(type);
                        }
                      },
                    );
                  });
                }).toList(),
          ),

          const SizedBox(height: 15),

          // Price Range Inputs
          const Text(
            'Price Range (Lacs)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSlider(
                  values: getxController.selectedPriceRange.value,
                  min: getxController.minPrice,
                  max: getxController.maxPrice,
                  divisions: 50,
                  labels: RangeLabels(
                    '${getxController.selectedPriceRange.value.start.toStringAsFixed(0)} Lacs',
                    '${getxController.selectedPriceRange.value.end.toStringAsFixed(0)} Lacs',
                  ),
                  onChanged: (RangeValues values) {
                    getxController.selectedPriceRange.value = values;
                    getxController.minPriceController.text =
                        values.start.toInt().toString();
                    getxController.maxPriceController.text =
                        values.end.toInt().toString();
                  },
                  activeColor: AppColors.green,
                  inactiveColor: AppColors.grey.withValues(alpha: .3),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs. ${getxController.selectedPriceRange.value.start.toStringAsFixed(0)}L - Rs. ${getxController.selectedPriceRange.value.end.toStringAsFixed(0)}L',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    ////////////////////////
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: getxController.minPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min (Lacs)',
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.grey,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onChanged: (value) {
                                final min = double.tryParse(value);
                                final currentMax =
                                    getxController.selectedPriceRange.value.end;
                                if (min != null) {
                                  final clampedMin = min.clamp(
                                    getxController.minPrice,
                                    getxController.maxPrice,
                                  );
                                  if (clampedMin <= currentMax) {
                                    getxController.selectedPriceRange.value =
                                        RangeValues(clampedMin, currentMax);
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: getxController.maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Max (Lacs)',
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.grey,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onChanged: (value) {
                                final max = double.tryParse(value);
                                final currentMin =
                                    getxController
                                        .selectedPriceRange
                                        .value
                                        .start;
                                if (max != null) {
                                  final clampedMax = max.clamp(
                                    getxController.minPrice,
                                    getxController.maxPrice,
                                  );
                                  if (clampedMax >= currentMin) {
                                    getxController.selectedPriceRange.value =
                                        RangeValues(currentMin, clampedMax);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Inside _buildFilterContent()
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown<int>(
                  label: 'Manufacturing Year',
                  hintText: 'Select Year',
                  selectedValue: getxController.selectedYearFilter,
                  items: List.generate(10, (i) => 2025 - i),
                  onChanged: (val) {
                    if (val != null) {
                      getxController.selectedYearFilter.value = val;
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFilterDropdown<String>(
                  label: 'Make',
                  hintText: 'Select Make',
                  selectedValue: getxController.selectedMakeFilter,
                  items: getxController.makesListFilter,
                  onChanged: (val) {
                    if (val != null) {
                      getxController.selectedMakeFilter.value = val;
                      getxController.selectedModelFilter.value = '';
                      getxController.selectedVariantFilter.value = '';
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown<String>(
                  label: 'Model',
                  hintText: 'Select Model',
                  selectedValue: getxController.selectedModelFilter,
                  items:
                      getxController.modelsListFilter[getxController
                          .selectedMakeFilter
                          .value] ??
                      [],
                  onChanged: (val) {
                    if (val != null) {
                      getxController.selectedModelFilter.value = val;
                      getxController.selectedVariantFilter.value = '';
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFilterDropdown<String>(
                  label: 'Variant',
                  hintText: 'Select Variant',
                  selectedValue: getxController.selectedVariantFilter,
                  items:
                      getxController.variantsListFilter[getxController
                          .selectedModelFilter
                          .value] ??
                      [],
                  onChanged: (val) {
                    if (val != null) {
                      getxController.selectedVariantFilter.value = val;
                    }
                  },
                ),
              ),
            ],
          ),

          // Manufacturing Year
          // const Text(
          //   'Manufacturing Year',
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          // ),
          // const SizedBox(height: 5),

          // Obx(
          //   () => Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12),
          //     decoration: BoxDecoration(
          //       color: AppColors.white,
          //       border: Border.all(color: AppColors.gray.withValues(alpha: .3)),
          //       borderRadius: BorderRadius.circular(30),
          //       boxShadow: [
          //         BoxShadow(
          //           color: AppColors.black.withValues(alpha: .05),
          //           blurRadius: 5,
          //           offset: Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //     child: DropdownButtonHideUnderline(
          //       child: DropdownButton<int>(
          //         isExpanded: true,
          //         menuMaxHeight: 300,
          //         value: getxController.selectedYearFilter.value,
          //         icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          //         style: const TextStyle(fontSize: 13, color: AppColors.black),
          //         items:
          //             List.generate(10, (i) => 2025 - i)
          //                 .map(
          //                   (year) => DropdownMenuItem(
          //                     value: year,
          //                     child: Text(year.toString()),
          //                   ),
          //                 )
          //                 .toList(),
          //         onChanged: (val) {
          //           getxController.selectedYearFilter.value = val!;
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 16),

          // // Make
          // const Text('Make', style: TextStyle(fontWeight: FontWeight.bold)),
          // Obx(
          //   () => DropdownButton<String>(
          //     isExpanded: true,
          //     value:
          //         getxController.selectedMakeFilter.value.isEmpty
          //             ? null
          //             : getxController.selectedMakeFilter.value,
          //     hint: const Text("Select Make"),
          //     items:
          //         getxController.makesListFilter
          //             .map(
          //               (make) =>
          //                   DropdownMenuItem(value: make, child: Text(make)),
          //             )
          //             .toList(),
          //     onChanged: (val) {
          //       getxController.selectedMakeFilter.value = val!;
          //       getxController.selectedModelFilter.value = '';
          //       getxController.selectedVariantFilter.value = '';
          //     },
          //   ),
          // ),
          // const SizedBox(height: 16),

          // // Model
          // const Text('Model', style: TextStyle(fontWeight: FontWeight.bold)),
          // Obx(
          //   () => DropdownButton<String>(
          //     isExpanded: true,
          //     value:
          //         getxController.selectedModelFilter.value.isEmpty
          //             ? null
          //             : getxController.selectedModelFilter.value,
          //     hint: const Text("Select Model"),
          //     items:
          //         (getxController.modelsListFilter[getxController
          //                     .selectedMakeFilter
          //                     .value] ??
          //                 [])
          //             .map(
          //               (model) =>
          //                   DropdownMenuItem(value: model, child: Text(model)),
          //             )
          //             .toList(),
          //     onChanged: (val) {
          //       getxController.selectedModelFilter.value = val!;
          //       getxController.selectedVariantFilter.value = '';
          //     },
          //   ),
          // ),
          // const SizedBox(height: 16),

          // // Variant
          // const Text('Variant', style: TextStyle(fontWeight: FontWeight.bold)),
          // Obx(
          //   () => DropdownButton<String>(
          //     isExpanded: true,
          //     value:
          //         getxController.selectedVariantFilter.value.isEmpty
          //             ? null
          //             : getxController.selectedVariantFilter.value,
          //     hint: const Text("Select Variant"),
          //     items:
          //         (getxController.variantsListFilter[getxController
          //                     .selectedModelFilter
          //                     .value] ??
          //                 [])
          //             .map(
          //               (variant) => DropdownMenuItem(
          //                 value: variant,
          //                 child: Text(variant),
          //               ),
          //             )
          //             .toList(),
          //     onChanged:
          //         (val) => getxController.selectedVariantFilter.value = val!,
          //   ),
          // ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  text: 'Reset',
                  textColor: AppColors.white,
                  backgroundColor: AppColors.red,
                  height: 35,
                  isLoading: false.obs,
                  elevation: 5,
                  onTap: () {
                    getxController.selectedYearFilter.value = 2022;
                    getxController.selectedMakeFilter.value = '';
                    getxController.selectedModelFilter.value = '';
                    getxController.selectedVariantFilter.value = '';
                    Navigator.pop(Get.context!);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ButtonWidget(
                  text: 'Apply',
                  height: 35,
                  isLoading: false.obs,
                  elevation: 5,
                  onTap: () {
                    // handle apply logic here
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

  // Filter Dropdowns
  Widget _buildFilterDropdown<T>({
    required String label,
    required Rx<T?> selectedValue,
    required List<T> items,
    required Function(T?) onChanged,
    required String hintText,
  }) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.grey.withValues(alpha: .3)),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: .05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                menuMaxHeight: 300,
                value: selectedValue.value,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                style: const TextStyle(fontSize: 13, color: AppColors.black),
                hint: Text(hintText, style: const TextStyle(fontSize: 12)),
                items:
                    items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortContent() {
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
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sort By',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...[
              'Price Low to High',
              'Price High to Low',
              'Newest First',
              'Oldest First',
            ].map((option) {
              return RadioListTile<String>(
                title: Text(option, style: const TextStyle(fontSize: 15)),
                value: option,
                groupValue: selectedSort.value,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                onChanged: (value) {
                  if (value != null) {
                    selectedSort.value = value;
                  }
                },
              );
            }),
            const SizedBox(height: 10),
            ButtonWidget(
              text: 'Apply',
              width: double.infinity,
              isLoading: false.obs,
              elevation: 5,
              onTap: () {
                Navigator.pop(Get.context!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
