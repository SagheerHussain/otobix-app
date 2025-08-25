import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Controllers/upcoming_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Utils/global_functions.dart';
import 'package:otobix/Views/Dealer%20Panel/car_details_page.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Widgets/empty_data_widget.dart';
import 'package:otobix/Widgets/shimmer_widget.dart';

class UpcomingPage extends StatelessWidget {
  UpcomingPage({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final UpcomingController upcomingController = Get.find<UpcomingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),

          Obx(() {
            if (upcomingController.isLoading.value) {
              return _buildLoadingWidget();
            } else if (upcomingController.upcomingCarsList.isEmpty) {
              return Expanded(
                child: Center(
                  child: const EmptyDataWidget(
                    icon: Icons.car_rental,
                    message: 'No Cars Found',
                  ),
                ),
              );
            } else {
              return _buildCarsList();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildCarsList() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: upcomingController.upcomingCarsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final car = upcomingController.upcomingCarsList[index];
          // InkWell for car card
          return InkWell(
            onTap: () {
              Get.to(
                () => CarDetailsPage(
                  carId: car.id,
                  car: car,
                  currentOpenSection: homeController.upcomingSectionScreen,
                ),
              );
            },
            child: Card(
              elevation: 4,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Car Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: car.imageUrl,
                                width: 120,
                                height: 90,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      height: 90,
                                      width: 120,
                                      color: AppColors.grey.withValues(
                                        alpha: .3,
                                      ),
                                      child: const Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: AppColors.green,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.carAlternateImage,
                                    width: 120,
                                    height: 90,
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
                                    '${car.make} ${car.model} ${car.variant}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Auction Starts at:',

                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',

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
                                        GlobalFunctions.getFormattedDate(
                                              date: car.yearMonthOfManufacture,
                                              type: GlobalFunctions.monthYear,
                                            ) ??
                                            'N/A',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.speed,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
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
                                        car.inspectionLocation,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // // Watchlist button
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.only(right: 10),
                            //       child: InkWell(
                            //         onTap: () {},
                            //         child: const Icon(
                            //           Icons.favorite_outline,
                            //           color: AppColors.gray,
                            //           size: 22,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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

                  Obx(() {
                    final isThisCarFav = upcomingController.wishlistCarsIds
                        .contains(car.id);
                    return Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () => upcomingController.toggleFavorite(car),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isThisCarFav
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color:
                                isThisCarFav ? AppColors.red : AppColors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
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
                    children: const [
                      // Image shimmer
                      ShimmerWidget(height: 90, width: 120, borderRadius: 8),
                      SizedBox(width: 12),

                      // Right column content shimmer
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(height: 14, width: 150),
                            SizedBox(height: 6),
                            ShimmerWidget(height: 10, width: 80),
                            SizedBox(height: 4),
                            ShimmerWidget(height: 12, width: 100),
                            SizedBox(height: 8),

                            // Year & KM Row
                            Row(
                              children: [
                                ShimmerWidget(height: 10, width: 60),
                                SizedBox(width: 10),
                                ShimmerWidget(height: 10, width: 80),
                              ],
                            ),
                            SizedBox(height: 6),

                            // Fuel & Location Row
                            Row(
                              children: [
                                ShimmerWidget(height: 10, width: 60),
                                SizedBox(width: 10),
                                ShimmerWidget(height: 10, width: 80),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Optional Inspected badge
                  Row(children: const [ShimmerWidget(height: 10, width: 120)]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
