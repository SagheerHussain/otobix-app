import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/global_functions.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/empty_data_widget.dart';
import 'package:otobix/Widgets/shimmer_widget.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/admin/controller/admin_upcoming_cars_list_controller.dart';

class AdminUpcomingCarsListPage extends StatelessWidget {
  AdminUpcomingCarsListPage({super.key});

  // Initialized in my cars page
  final AdminUpcomingCarsListController upcomingController =
      Get.find<AdminUpcomingCarsListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(() {
            if (upcomingController.isLoading.value) {
              return _buildLoadingWidget();
            } else if (upcomingController.filteredUpcomingCarsList.isEmpty) {
              return Expanded(
                child: Center(
                  child: const EmptyDataWidget(
                    icon: Icons.local_car_wash,
                    message: 'No Cars in Upcoming',
                  ),
                ),
              );
            } else {
              return _buildUpcomingCarsList();
            }
          }),
        ],
      ),
    );
  }

  // Wishlist List
  Widget _buildUpcomingCarsList() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: upcomingController.filteredUpcomingCarsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          final car = upcomingController.filteredUpcomingCarsList[index];
          // InkWell for car card
          return GestureDetector(
            onTap: () => _showAuctionBottomSheet(car),
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
                            // Car details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Car Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: car.imageUrl,
                                          width: 120,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Container(
                                                height: 80,
                                                width: 120,
                                                color: AppColors.grey
                                                    .withValues(alpha: .3),
                                                child: const Center(
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color:
                                                              AppColors.green,
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                          errorWidget: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              AppImages.carAlternateImage,
                                              width: 120,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${car.make} ${car.model} ${car.variant}',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'FMV: ',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Go Live In: ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.green,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          upcomingController.remainingTimes[car
                                                  .id] ??
                                              "--",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(),
                                  const SizedBox(height: 5),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildIconAndTextWidget(
                                            icon: Icons.calendar_today,
                                            text:
                                                GlobalFunctions.getFormattedDate(
                                                  date:
                                                      car.yearMonthOfManufacture,
                                                  type:
                                                      GlobalFunctions.monthYear,
                                                ) ??
                                                'N/A',
                                          ),

                                          _buildIconAndTextWidget(
                                            icon: Icons.local_gas_station,
                                            text: car.fuelType,
                                          ),
                                        ],
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildIconAndTextWidget(
                                            icon: Icons.speed,
                                            text:
                                                '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
                                          ),

                                          _buildIconAndTextWidget(
                                            icon: Icons.location_on,
                                            text: car.inspectionLocation,
                                          ),
                                        ],
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildIconAndTextWidget(
                                            icon: Icons.receipt_long,
                                            text:
                                                GlobalFunctions.getFormattedDate(
                                                  date: car.taxValidTill,
                                                  type:
                                                      GlobalFunctions.monthYear,
                                                ) ??
                                                'N/A',
                                          ),
                                          _buildIconAndTextWidget(
                                            icon: Icons.person,
                                            text:
                                                car.ownerSerialNumber == 1
                                                    ? 'First Owner'
                                                    : '${car.ownerSerialNumber} Owners',
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
                        const SizedBox(height: 5),
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

  // Bottom sheet

  void _showAuctionBottomSheet(final car) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        // Local sheet state
        int mode = 0; // 0 = Go Live Now, 1 = Schedule
        DateTime now = DateTime.now();
        DateTime? startAt = (car.auctionStartTime ?? now);
        int durationHrs =
            (car.auctionDuration is int && car.auctionDuration > 0)
                ? car.auctionDuration
                : 2;

        DateTime getEnd(DateTime s, int h) => s.add(Duration(hours: h));

        Future<void> _pickDateTime() async {
          final date = await showDatePicker(
            context: context,
            initialDate: startAt!,
            firstDate: DateTime(now.year - 1),
            lastDate: DateTime(now.year + 2),
          );
          if (date == null) return;

          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(startAt!),
          );
          if (time == null) return;

          startAt = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        }

        Future<void> _submit() async {
          try {
            final pickedStart = (mode == 0 ? DateTime.now() : startAt)!.toUtc();
            final body = {
              'carId': car.id,
              'auctionStartTime': pickedStart.toIso8601String(),
              'auctionDuration': durationHrs,
            };

            final response = await ApiService.post(
              endpoint: AppUrls.updateCarAuctionTime,
              body: body,
            );

            if (response.statusCode == 200) {
              ToastWidget.show(
                context: Get.context!,
                title: mode == 0 ? 'Car is live now' : 'Auction time updated',
                type: ToastType.success,
              );
              Get.back(); // close sheet
            } else {
              ToastWidget.show(
                context: Get.context!,
                title: 'Failed to update',
                type: ToastType.error,
              );
            }
          } catch (e) {
            ToastWidget.show(
              context: Get.context!,
              title: 'Something went wrong',
              type: ToastType.error,
            );
          }
        }

        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.95,
          minChildSize: 0.55,
          initialChildSize: 0.7,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                final effectiveStart = (mode == 0 ? now : startAt!);
                final endAt = getEnd(effectiveStart, durationHrs);

                Widget _chip(String label, int value) {
                  final selected = mode == value;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => setState(() => mode = value),
                    backgroundColor: AppColors.grey.withValues(alpha: .1),
                    selectedColor: AppColors.green.withValues(alpha: .15),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.green : AppColors.black,
                    ),
                    // shape & border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // radius
                      side: BorderSide.none, // no border
                    ),

                    side: BorderSide.none,
                  );
                }

                Widget _tile({
                  required IconData icon,
                  required String title,
                  required String subtitle,
                  Widget? trailing,
                  VoidCallback? onTap,
                  bool enabled = true,
                }) {
                  return InkWell(
                    onTap: enabled ? onTap : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: .2),
                        ),
                        color:
                            enabled
                                ? Colors.white
                                : Colors.grey.withValues(alpha: .05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, size: 18, color: AppColors.grey),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (trailing != null) trailing,
                        ],
                      ),
                    ),
                  );
                }

                String fmt(DateTime d) => DateFormat(
                  'EEE, dd MMM yyyy • hh:mm a',
                ).format(d.toLocal());

                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grab handle
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Header
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: car.imageUrl,
                              width: 64,
                              height: 48,
                              fit: BoxFit.cover,
                              errorWidget:
                                  (_, __, ___) =>
                                      const Icon(Icons.directions_car),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${car.make} ${car.model} ${car.variant}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'FMV: Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go Live In: ',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.green,
                            ),
                          ),
                          Obx(
                            () => Text(
                              upcomingController.remainingTimes[car.id] ?? "--",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Mode switch
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.grey.withValues(alpha: .1),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: _chip('Go live now', 0)),
                            const SizedBox(width: 10), // space between
                            Expanded(child: _chip('Schedule', 1)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Start time
                      _tile(
                        icon: Icons.access_time,
                        title: mode == 0 ? 'Live start' : 'Scheduled start',
                        subtitle: fmt(effectiveStart),
                        onTap:
                            mode == 1
                                ? () async {
                                  await _pickDateTime();
                                  setState(() {});
                                }
                                : null,
                        enabled: mode == 1,
                        trailing: Icon(
                          mode == 1 ? Icons.edit_calendar : Icons.lock_clock,
                          color: AppColors.grey,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Duration picker
                      _tile(
                        icon: Icons.timer,
                        title: 'Duration (hours)',
                        subtitle:
                            '$durationHrs hour${durationHrs == 1 ? '' : 's'}',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed:
                                  () => setState(() {
                                    if (durationHrs > 1) durationHrs--;
                                  }),
                              icon: const Icon(Icons.remove),
                              splashRadius: 18,
                            ),
                            Text(
                              '$durationHrs',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => durationHrs++),
                              icon: const Icon(Icons.add),
                              splashRadius: 18,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // End time (computed)
                      _tile(
                        icon: Icons.flag,
                        title: 'Ends at',
                        subtitle: fmt(endAt),
                        trailing: const Icon(
                          Icons.info_outline,
                          color: AppColors.grey,
                        ),
                        enabled: false,
                      ),

                      const SizedBox(height: 20),

                      const SizedBox(height: 10),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              text: 'Cancel',
                              isLoading: false.obs,
                              backgroundColor: AppColors.grey.withValues(
                                alpha: .1,
                              ),
                              textColor: AppColors.black,
                              fontSize: 13,

                              onTap: () => Get.back(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ButtonWidget(
                              text:
                                  mode == 0 ? 'Make Live Now' : 'Save Schedule',
                              isLoading: false.obs,
                              fontSize: 13,
                              onTap: _submit,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Loading widget
  Widget _buildLoadingWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
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

  // Icon and text widget
  Widget _buildIconAndTextWidget({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
