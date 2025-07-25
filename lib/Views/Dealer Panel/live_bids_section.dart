import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Views/Dealer%20Panel/car_details_page.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Widgets/empty_data_widget.dart';

class LiveBidsSection extends StatelessWidget {
  LiveBidsSection({super.key});

  final HomeController getxController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Obx(
            () =>
                getxController.filteredCars.isEmpty
                    ? Expanded(
                      child: Center(
                        child: const EmptyDataWidget(
                          icon: Icons.car_rental,
                          message: 'No Cars Found',
                        ),
                      ),
                    )
                    : Expanded(
                      child: ListView.separated(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: getxController.filteredCars.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          final car = getxController.filteredCars[index];

                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => CarDetailsPage(
                                  carId: car.id!,
                                  car: car,
                                  type: getxController.liveBidsSectionScreen,
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Car image
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: Image.asset(
                                          car.imageUrl,
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
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
                                        child: Obx(
                                          () => InkWell(
                                            onTap:
                                                () => getxController
                                                    .changeFavoriteCars(car),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: AppColors.white
                                                    .withValues(alpha: .8),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                car.isFavorite.value
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                color:
                                                    car.isFavorite.value
                                                        ? AppColors.red
                                                        : AppColors.grey,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Car details
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                            Text(
                                              'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.price)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
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
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Icon(
                                              Icons.speed,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${NumberFormat.decimalPattern('en_IN').format(car.kmDriven)} km',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
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
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              car.location,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        if (car.isInspected == true)
                                          Column(
                                            children: [
                                              Divider(),
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
                                                      color: AppColors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
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
  }
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
