import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Controllers/live_bids_controller.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Utils/global_functions.dart';
import 'package:otobix/Views/Dealer%20Panel/car_details_page.dart';
import 'package:otobix/Widgets/empty_data_widget.dart';
import 'package:otobix/Widgets/shimmer_widget.dart';

class LiveBidsPage extends StatelessWidget {
  LiveBidsPage({super.key});

  // final HomeController getxController = Get.put(HomeController());
  final LiveBidsController getxController = Get.find<LiveBidsController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),

          Obx(() {
            if (getxController.isLoading.value) {
              return _buildLoadingWidget();
            } else if (getxController.filteredLiveBidsCarsList.isEmpty) {
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
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: getxController.filteredLiveBidsCarsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final car = getxController.filteredLiveBidsCarsList[index];

          return InkWell(
            onTap: () {
              Get.to(
                () => CarDetailsPage(
                  carId: car.id,
                  car: car,
                  currentOpenSection: homeController.liveBidsSectionScreen,
                  remainingAuctionTime: getxController
                      .getCarRemainingTimeForNextScreen(car.id),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),

                        child: CachedNetworkImage(
                          imageUrl: car.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.green,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          errorWidget: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.carAlternateImage,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Obx(() {
                          final isThisCarFav = getxController.wishlistCarsIds
                              .contains(car.id);
                          return InkWell(
                            onTap: () => getxController.toggleFavorite(car),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: .8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isThisCarFav
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color:
                                    isThisCarFav
                                        ? AppColors.red
                                        : AppColors.grey,
                                size: 20,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  // Car details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car.make} ${car.model} ${car.variant}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),
                        _buildOtherDetails(car),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Highest Bid: ',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Obx(
                              () => Text(
                                'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid.value)}/-',
                                key: ValueKey(car.highestBid.value),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Text(
                            //   'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-',
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     color: AppColors.green,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        _buildCarCardFooter(car),
                        // if (car.isInspected == true)
                        //   Column(
                        //     children: [
                        //       Divider(),
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.verified_user,
                        //             size: 14,
                        //             color: AppColors.green,
                        //           ),
                        //           const SizedBox(width: 4),
                        //           Text(
                        //             'Inspected 8.2/10',
                        //             style: TextStyle(
                        //               fontSize: 10,
                        //               color: AppColors.green,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                      ],
                    ),
                  ),
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
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return Card(
            // elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image shimmer
                const ShimmerWidget(height: 160, borderRadius: 12),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Title shimmer
                      ShimmerWidget(height: 14, width: 150),
                      SizedBox(height: 10),

                      // Bid row shimmer
                      ShimmerWidget(height: 12, width: 100),
                      SizedBox(height: 6),

                      // Year and KM
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Fuel and Location
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Inspection badge
                      ShimmerWidget(height: 10, width: 100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtherDetails(CarsListModel car) {
    Widget iconDetail(IconData icon, String label, String value) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: AppColors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Divider(),
          // Text(
          //   label,
          //   style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          // ),
        ],
      );
    }

    String maskRegistrationNumber(String? input) {
      if (input == null || input.length <= 5) return '*****';
      final visible = input.substring(0, input.length - 5);
      return '$visible*****';
    }

    final items = [
      // iconDetail(Icons.factory, 'Make', 'Mahindra'),
      // iconDetail(Icons.directions_car, 'Model', 'Scorpio'),
      // iconDetail(Icons.confirmation_number, 'Variant', '[2014–2017]'),
      iconDetail(
        Icons.speed,
        'Odometer Reading in Kms',
        '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
      ),
      iconDetail(Icons.local_gas_station, 'Fuel Type', car.fuelType),
      iconDetail(
        Icons.calendar_month,
        'Year of Manufacture',
        GlobalFunctions.getFormattedDate(
              date: car.yearMonthOfManufacture,
              type: GlobalFunctions.year,
            ) ??
            'N/A',
      ),

      iconDetail(Icons.settings, 'Transmission', car.commentsOnTransmission),
      iconDetail(
        Icons.receipt_long,
        'Tax Validity',
        GlobalFunctions.getFormattedDate(
              date: car.taxValidTill,
              type: GlobalFunctions.monthYear,
            ) ??
            'N/A',
      ),
      iconDetail(
        Icons.person,
        'Owner Serial Number',
        car.ownerSerialNumber == 1
            ? 'First Owner'
            : '${car.ownerSerialNumber} Owners',
      ),

      iconDetail(
        Icons.location_on,
        'Inspection Location',
        car.inspectionLocation,
      ),
      iconDetail(
        Icons.directions_car_filled,
        'Registration No.',
        maskRegistrationNumber(car.registrationNumber),
      ),
      iconDetail(Icons.apartment, 'Registered RTO', car.registeredRto),
    ];

    return Container(
      // padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap(
          //   spacing: 10,
          //   runSpacing: 5,
          //   alignment: WrapAlignment.start,
          //   children: items,
          // ),
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5, // controls vertical space
            crossAxisSpacing: 10, // controls horizontal space
            childAspectRatio: 4, // width / height ratio — adjust as needed
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildCarCardFooter(CarsListModel car) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fair Market Value: Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Obx(
              () => Text(
                // car.remainingAuctionTime.value,
                getxController.getCarRemainingTimeForNextScreen(car.id).value,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildOtherDetails1(CarsListModel car) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Icon(Icons.calendar_today, size: 14, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(
  //             GlobalFunctions.getFormattedDate(
  //                   date: car.yearMonthOfManufacture,
  //                   type: GlobalFunctions.monthYear,
  //                 ) ??
  //                 'N/A',
  //             style: const TextStyle(fontSize: 12),
  //           ),
  //           const SizedBox(width: 12),
  //           Icon(Icons.speed, size: 14, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(
  //             '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
  //             style: const TextStyle(fontSize: 12),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 6),
  //       Row(
  //         children: [
  //           Icon(Icons.local_gas_station, size: 14, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(car.fuelType, style: const TextStyle(fontSize: 12)),
  //           const SizedBox(width: 12),
  //           Icon(Icons.location_on, size: 14, color: Colors.grey),
  //           const SizedBox(width: 4),
  //           Text(car.inspectionLocation, style: const TextStyle(fontSize: 12)),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:otobix/Utils/app_colors.dart';
// import 'package:otobix/Utils/app_images.dart';
// import 'package:otobix/Views/Dealer%20Panel/car_details_page.dart';
// import 'package:otobix/Controllers/home_controller.dart';

// class LiveBidsSection extends StatelessWidget {
//   LiveBidsSection({super.key});

//   final HomeController getxController = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView.separated(
//               shrinkWrap: true,
//               itemCount: getxController.cars.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 15),
//               itemBuilder: (context, index) {
//                 final car = getxController.cars[index];
//                 // InkWell for car card
//                 return InkWell(
//                   onTap: () {
//                     Get.to(
//                       () => CarDetailsPage(
//                         car: car,
//                         type: getxController.liveBidsSectionScreen,
//                       ),
//                     );
//                   },
//                   child: Card(
//                     elevation: 4,
//                     color: AppColors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Stack(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   // Car Image
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Image.asset(
//                                       car.imageUrl,
//                                       width: 120,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (
//                                         context,
//                                         error,
//                                         stackTrace,
//                                       ) {
//                                         return Image.asset(
//                                           AppImages.carAlternateImage,
//                                           width: 120,
//                                           height: 80,
//                                           fit: BoxFit.cover,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),

//                                   // Car details
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           car.name,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           'HB: ${NumberFormat.decimalPattern('en_IN').format(car.price)}/-',

//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: AppColors.green,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.calendar_today,
//                                               size: 14,
//                                               color: Colors.grey,
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               car.year.toString(),
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10),
//                                             Icon(
//                                               Icons.speed,
//                                               size: 14,
//                                               color: Colors.grey,
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               '${NumberFormat.decimalPattern('en_IN').format(car.kmDriven)} km',
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.local_gas_station,
//                                               size: 14,
//                                               color: Colors.grey,
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               car.fuelType,
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10),
//                                             Icon(
//                                               Icons.location_on,
//                                               size: 14,
//                                               color: Colors.grey,
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               car.location,
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   // // Watchlist button
//                                   // Row(
//                                   //   crossAxisAlignment: CrossAxisAlignment.start,
//                                   //   children: [
//                                   //     Padding(
//                                   //       padding: const EdgeInsets.only(right: 10),
//                                   //       child: InkWell(
//                                   //         onTap: () {},
//                                   //         child: const Icon(
//                                   //           Icons.favorite_outline,
//                                   //           color: AppColors.gray,
//                                   //           size: 22,
//                                   //         ),
//                                   //       ),
//                                   //     ),
//                                   //   ],
//                                   // ),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               car.isInspected == true
//                                   ? Column(
//                                     children: [
//                                       Divider(),
//                                       // const SizedBox(height: 5),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.verified_user,
//                                             size: 14,
//                                             color: AppColors.green,
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             'Inspected 8.2/10',
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               // fontWeight: FontWeight.bold,
//                                               color: AppColors.green,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                   : const SizedBox.shrink(),
//                             ],
//                           ),
//                         ),

//                         Obx(
//                           () => Positioned(
//                             top: 10,
//                             right: 10,
//                             child: InkWell(
//                               onTap:
//                                   () => getxController.changeFavoriteCars(car),
//                               borderRadius: BorderRadius.circular(20),
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   car.isFavorite.value
//                                       ? Icons.favorite
//                                       : Icons.favorite_outline,
//                                   color:
//                                       car.isFavorite.value
//                                           ? AppColors.red
//                                           : AppColors.grey,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
