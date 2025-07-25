import 'dart:ui';

import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Models/car_model2.dart';
import 'package:otobix/Utils/global_functions.dart';
import 'package:otobix/Views/Dealer%20Panel/place_bid_button_widget.dart';
import 'package:otobix/Views/Dealer%20Panel/start_auto_bid_button_widget.dart';
import 'package:otobix/Views/Dealer%20Panel/car_images_page.dart';
import 'package:otobix/Widgets/accordion_widget.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/congratulations_dialog_widget.dart';
import 'package:otobix/Widgets/shimmer_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Controllers/car_details_controller.dart';

class CarDetailsPage extends StatelessWidget {
  final String carId;
  final CarModel car;
  final String type;

  const CarDetailsPage({
    super.key,
    required this.carId,
    required this.car,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final getxController = Get.put(CarDetailsController(carId));
    final homeController = Get.put(HomeController());
    final imageUrls = car.imageUrls ?? [car.imageUrl];
    getxController.setImageUrls(imageUrls);
    getxController.startCountdown(DateTime.now().add(const Duration(days: 1)));

    final pageController = PageController();

    // Set current bid amount
    getxController.currentHighestBidAmount = car.price.toInt();
    // Set one click price amount
    getxController.oneClickPriceAmount.value =
        getxController.currentHighestBidAmount + 10000;
    // Set your offer amount
    type != homeController.ocb70SectionScreen
        ? getxController.yourOfferAmount.value =
            getxController.currentHighestBidAmount + 4000
        : getxController.yourOfferAmount.value =
            getxController.oneClickPriceAmount.value;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Obx(
              () =>
                  getxController.isLoading.value
                      ? Center(child: _buildLoading())
                      : Stack(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 120),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                children: [
                                  _buildCarImagesList(
                                    imageUrls: imageUrls,
                                    pageController: pageController,
                                    getxController: getxController,
                                    carDetails: getxController.carDetails!,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildCarDetails(
                                    carDetails: getxController.carDetails!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildBidButton(
                              getxController,
                              homeController,
                              context,
                              type,
                            ),
                          ),
                        ],
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCarImagesList({
    required List<String> imageUrls,
    required PageController pageController,
    required CarDetailsController getxController,
    required CarModel2 carDetails,
  }) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () => CarImagesPage(
                imageUrls: imageUrls,
                initialIndex: getxController.currentIndex.value,
              ),
            );
          },
          child: SizedBox(
            height: 250,
            child: PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              pageController: pageController,
              onPageChanged: (index) => getxController.updateIndex(index),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: 'image-$index',
                    transitionOnUserGestures: true,
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Image(
                        image: AssetImage(AppImages.carAlternateImage),
                      ),
                    );
                  },
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: AppColors.white),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 16,
          child: Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${getxController.currentIndex.value + 1} / ${imageUrls.length}',
                style: const TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ),
          ),
        ),
        _buildAppbar(getxController: getxController, carDetails: carDetails),
      ],
    );
  }

  Widget _buildAppbar({
    required CarDetailsController getxController,
    required CarModel2 carDetails,
  }) {
    return Positioned(
      top: 12,
      left: 16,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: 12,
              ),
              const SizedBox(width: 10),
              Text(
                '${carDetails.make} ${carDetails.model}',
                style: const TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarDetails({required CarModel2 carDetails}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMainDetails(carDetails: carDetails),
          const SizedBox(height: 20),
          _buildIconAndTextDetails(carDetails: carDetails),
          const SizedBox(height: 20),
          _buildBasicDetails(carDetails: carDetails),
          const SizedBox(height: 10),
          _buildRcAndLegalDocuments(carDetails: carDetails),
          const SizedBox(height: 5),
          _buildEngineMechanicalInfo(carDetails: carDetails),
          const SizedBox(height: 5),
          _buildSafetyAndAirbags(carDetails: carDetails),
          const SizedBox(height: 10),
          _buildInteriorFeatures(carDetails: carDetails),
          const SizedBox(height: 5),
          _buildExteriorCondition(carDetails: carDetails),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMainDetails({required CarModel2 carDetails}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${carDetails.make} ${carDetails.model}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Text(
              'Highest Bid: ',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${NumberFormat.decimalPattern('en_IN').format(car.price)}/-',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.grey, size: 15),
            const SizedBox(width: 5),
            Text(carDetails.city, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildIconAndTextDetails({
    // required CarModel car,
    required CarModel2 carDetails,
  }) {
    // Helper Function
    Widget item({required IconData icon, required String text}) => Column(
      children: [
        Icon(icon, color: AppColors.grey, size: 20),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );

    // Actual Widget
    return Row(
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 10,
            runSpacing: 5,
            children: [
              item(
                icon: Icons.speed,
                text:
                    '${NumberFormat.decimalPattern('en_IN').format(carDetails.odometerReadingInKms)} kms',
              ),
              item(icon: Icons.local_gas_station, text: carDetails.fuelType),
              item(icon: Icons.settings, text: carDetails.variant),
              // _buildIconAndTextWidget(icon: Icons.color_lens, text: carDetails.color),
              item(
                icon: Icons.event,
                text: GlobalFunctions.getFormattedDate(
                  carDetails.yearMonthOfManufacture,
                  GlobalFunctions.year,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicDetails({required CarModel2 carDetails}) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.directions_car_filled_outlined,
              color: AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              'Basic Details',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Divider(color: AppColors.grey.withValues(alpha: 0.5)),
        const SizedBox(height: 3),
        _buildDetailRowForOtherDetails('Make', carDetails.make),
        _buildDetailRowForOtherDetails('Model', carDetails.model),
        _buildDetailRowForOtherDetails('Variant', carDetails.variant),
        _buildDetailRowForOtherDetails(
          'Registration Number',
          carDetails.registrationNumber,
        ),
        _buildDetailRowForOtherDetails(
          'Registration Date',
          GlobalFunctions.getFormattedDate(
            carDetails.registrationDate,
            GlobalFunctions.date,
          ),
        ),
        _buildDetailRowForOtherDetails(
          'Manufacture Year',
          GlobalFunctions.getFormattedDate(
            carDetails.yearMonthOfManufacture,
            GlobalFunctions.year,
          ),
        ),
        _buildDetailRowForOtherDetails(
          'Odometer Reading',
          '${NumberFormat.decimalPattern('en_IN').format(carDetails.odometerReadingInKms)} kms',
        ),
        _buildDetailRowForOtherDetails('Fuel Type', carDetails.fuelType),
        _buildDetailRowForOtherDetails(
          'Cubic Capacity',
          '${carDetails.cubicCapacity} cc',
        ),
        _buildDetailRowForOtherDetails('City', carDetails.city),
        _buildDetailRowForOtherDetails('Status', carDetails.status),
        _buildDetailRowForOtherDetails('Budget', carDetails.budgetCar),
      ],
    );
  }

  Widget _buildDetailRowForOtherDetails(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 12)),
          ],
        ),
        Divider(color: AppColors.grey.withValues(alpha: 0.1)),
      ],
    );
  }

  Widget _buildRcAndLegalDocuments({required CarModel2 carDetails}) {
    Widget buildRow(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '-',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return AccordionWidget(
      title: 'RC, Insurance & Legal Details',
      contentSize: 300,
      icon: Icons.article_outlined,
      content: Column(
        children: [
          buildRow('RC Book Availability', carDetails.rcBookAvailability),
          buildRow('RC Condition', carDetails.rcCondition),
          buildRow('Registered Owner', carDetails.registeredOwner),
          buildRow('Registered Address', carDetails.registeredAddressAsPerRc),
          buildRow('To Be Scrapped', carDetails.toBeScrapped),
          buildRow('Road Tax Validity', carDetails.roadTaxValidity),
          buildRow('RTO NOC', carDetails.rtoNoc),
          buildRow('RTO Form 28 (2 Nos)', carDetails.rtoForm282Nos),
          buildRow('Hypothecation Details', carDetails.hypothecationDetails),
          buildRow('Mismatch In RC', carDetails.mismatchInRc),
          buildRow('Duplicate Key', carDetails.duplicateKey),
          buildRow('Party Peshi', carDetails.partyPeshi),
          const Divider(height: 20),
          buildRow('Insurance', carDetails.insurance),
          // buildRow('Insurance Copy', carDetails.insuranceCopy),
          // buildRow('Insurance Copy 1', carDetails.insuranceCopy1),
          // const Divider(height: 20),
          // buildRow('RC Tax Token', carDetails.rcTaxToken),
          // buildRow('RC Token 1', carDetails.rcToken1),
          // buildRow('RC Token 2', carDetails.rcToken2),
          // buildRow('RC Token 3', carDetails.rcToken3),
          // buildRow('RC Token 4', carDetails.rcToken4),
        ],
      ),
    );
  }

  Widget _buildEngineMechanicalInfo({required CarModel2 carDetails}) {
    // Helper: builds each labeled box
    Widget infoCard({
      required IconData icon,
      required String label,
      required String value,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon badge
                Container(
                  width: 28,
                  height: 28,
                  // margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: AppColors.green),
                ),
                // Label + Value
                // Flexible(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [SizedBox(height: 7)],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    value.isNotEmpty ? value : '—',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Field Map: Label and matching value from carDetails
    final fields = [
      {"label": "Engine", "value": carDetails.engine, "icon": Icons.settings},
      {
        "label": "Engine Number",
        "value": carDetails.engineNumber,
        "icon": Icons.confirmation_number,
      },
      {
        "label": "Chassis Number",
        "value": carDetails.chassisNumber,
        "icon": Icons.car_repair,
      },
      {
        "label": "Cubic Capacity",
        "value": '${carDetails.cubicCapacity} cc',
        "icon": Icons.compress,
      },
      {
        "label": "Fuel Type",
        "value": carDetails.fuelType,
        "icon": Icons.local_gas_station,
      },
      {
        "label": "Hypothecation",
        "value": carDetails.hypothecationDetails,
        "icon": Icons.verified_user,
      },
      {
        "label": "Engine Mount",
        "value": carDetails.engineMount,
        "icon": Icons.engineering,
      },
      // {
      //   "label": "Engine Sound",
      //   "value": carDetails.engineSound,
      //   "icon": Icons.volume_up,
      // },
      // {
      //   "label": "Engine Bay",
      //   "value": carDetails.engineBay,
      //   "icon": Icons.build_circle,
      // },
      {
        "label": "Dipstick Oil Level",
        "value": carDetails.engineOilLevelDipstick,
        "icon": Icons.water_drop,
      },
      {
        "label": "Engine Oil",
        "value": carDetails.engineOil,
        "icon": Icons.oil_barrel,
      },
      {
        "label": "Permissible Blow By",
        "value": carDetails.enginePermisableBlowBy,
        "icon": Icons.air,
      },
      {
        "label": "Exhaust Smoke",
        "value": carDetails.exhaustSmoke,
        "icon": Icons.smoke_free,
      },
      // {
      //   "label": "Exhaust Smoke 2",
      //   "value": carDetails.exhaustSmoke1,
      //   "icon": Icons.smoke_free_outlined,
      // },
      {"label": "Coolant", "value": carDetails.coolant, "icon": Icons.ac_unit},
      {
        "label": "Battery",
        "value": carDetails.battery,
        "icon": Icons.battery_full,
      },
      // {
      //   "label": "Battery 2",
      //   "value": carDetails.battery1,
      //   "icon": Icons.battery_std,
      // },
      {"label": "Clutch", "value": carDetails.clutch, "icon": Icons.sync},
      {
        "label": "Gear Shift",
        "value": carDetails.gearShift,
        "icon": Icons.settings_suggest,
      },
      {
        "label": "Oil Comments",
        "value": carDetails.commentsOnEngineOil,
        "icon": Icons.comment,
      },
      {
        "label": "Transmission Comments",
        "value": carDetails.commentsOnTransmission,
        "icon": Icons.notes,
      },
    ];

    return AccordionWidget(
      title: 'Engine & Mechanical Info',
      contentSize: 400,
      icon: Icons.engineering,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
        child: Column(
          children: [
            LayoutGrid(
              columnSizes: [1.fr, 1.fr],
              rowGap: 12,
              columnGap: 16,
              rowSizes: List.generate((fields.length / 2).ceil(), (_) => auto),
              children:
                  fields.map((item) {
                    return infoCard(
                      icon: item['icon'] as IconData,
                      label: item['label'] as String,
                      value: item['value'] as String? ?? '',
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyAndAirbags({required CarModel2 carDetails}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield,
                size: 20,
                color: AppColors.blue.withValues(alpha: 0.7),
              ),
              SizedBox(width: 8),
              Text(
                'Safety & Airbags',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          Divider(color: AppColors.grey.withValues(alpha: 0.5)),
          SizedBox(height: 5),
          _buildDetailRowForInspectionReport(
            Icons.date_range,
            'No. of Airbags',
            carDetails.noOfAirBags016.toString(),
          ),
          Divider(color: AppColors.grey.withValues(alpha: 0.1)),
          const SizedBox(height: 5),
          _buildDetailRowForInspectionReport(
            Icons.description_outlined,
            'Airbag Features',
            carDetails.airbagFeaturesDriverSide.toString(),
          ),
          Divider(color: AppColors.grey.withValues(alpha: 0.1)),
          const SizedBox(height: 5),
          _buildDetailRowForInspectionReport(
            Icons.shield,
            'ABS',
            carDetails.abs,
          ),

          Divider(color: AppColors.grey.withValues(alpha: 0.1)),
          const SizedBox(height: 5),
          _buildDetailRowForInspectionReport(
            Icons.speed,
            'Odometer Reading',
            '${NumberFormat.decimalPattern().format(carDetails.odometerReadingInKms)} km',
          ),
          Divider(color: AppColors.grey.withValues(alpha: 0.1)),
          const SizedBox(height: 5),
          _buildDetailRowForInspectionReport(
            Icons.local_gas_station,
            'Fuel Level',
            carDetails.fuelLevel,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowForInspectionReport(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
            ],
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInteriorFeatures({required CarModel2 carDetails}) {
    Widget item({
      required IconData icon,
      required String label,
      required Widget trailing,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
            trailing,
          ],
        ),
      );
    }

    Widget interiorFeatureValue(String? value) {
      final status = value?.toLowerCase();

      if (status == 'available' || status == 'yes') {
        return Icon(Icons.check_circle, color: AppColors.green, size: 20);
      } else if (status == 'not applicable' || status == 'not available') {
        return Icon(Icons.cancel, color: AppColors.red, size: 20);
      } else {
        return Text(value.toString(), style: const TextStyle(fontSize: 13));
      }
    }

    // Widget powerWindowChips() {
    //   if (carDetails.powerWindowConditionLhsFront == null || carDetails.powerWindowConditionLhsRear == null) {
    //     return const Text('No info');
    //   }
    //   return Wrap(
    //     spacing: 6,
    //     runSpacing: 6,
    //     children: carDetails.powerWindowCondition!
    //         .map((e) => Chip(
    //               label: Text(e, style: const TextStyle(fontSize: 12)),
    //               backgroundColor: Colors.blue.shade50,
    //             ))
    //         .toList(),
    //   );
    // }

    return AccordionWidget(
      title: 'Interior Features',
      icon: Icons.chair_alt_outlined,
      contentSize: 300,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Steering & Drive
          item(
            icon: Icons.settings,
            label: 'Steering',
            trailing: interiorFeatureValue(carDetails.steering),
          ),
          item(
            icon: Icons.speed,
            label: 'Brakes',
            trailing: interiorFeatureValue(carDetails.brakes),
          ),
          item(
            icon: Icons.directions_car,
            label: 'Suspension',
            trailing: interiorFeatureValue(carDetails.suspension),
          ),

          const SizedBox(height: 10),

          /// AC Features
          item(
            icon: Icons.ac_unit,
            label: 'Manual AC',
            trailing: interiorFeatureValue(carDetails.airConditioningManual),
          ),
          item(
            icon: Icons.ac_unit_outlined,
            label: 'Climate Control',
            trailing: interiorFeatureValue(
              carDetails.airConditioningClimateControl,
            ),
          ),

          const SizedBox(height: 10),

          /// Music System
          item(
            icon: Icons.music_note,
            label: 'Music System',
            trailing: interiorFeatureValue(carDetails.musicSystem),
          ),
          item(
            icon: Icons.speaker,
            label: 'Stereo',
            trailing: interiorFeatureValue(carDetails.stereo),
          ),
          item(
            icon: Icons.speaker_group,
            label: 'Inbuilt Speaker',
            trailing: interiorFeatureValue(carDetails.inbuiltSpeaker),
          ),
          item(
            icon: Icons.speaker_outlined,
            label: 'External Speaker',
            trailing: interiorFeatureValue(carDetails.externalSpeaker),
          ),

          const SizedBox(height: 10),

          /// Reverse & Seats
          item(
            icon: Icons.videocam,
            label: 'Reverse Camera',
            trailing: interiorFeatureValue(carDetails.reverseCamera),
          ),
          item(
            icon: Icons.event_seat,
            label: 'Leather Seats',
            trailing: interiorFeatureValue(carDetails.leatherSeats),
          ),
          item(
            icon: Icons.event_seat_outlined,
            label: 'Fabric Seats',
            trailing: interiorFeatureValue(carDetails.fabricSeats),
          ),
          item(
            icon: Icons.roofing,
            label: 'Sunroof',
            trailing: interiorFeatureValue(carDetails.sunroof),
          ),

          const SizedBox(height: 10),

          /// Power Windows
          item(
            icon: Icons.window,
            label: 'No. of Power Windows',
            trailing: interiorFeatureValue(carDetails.noOfPowerWindows),
          ),
          const SizedBox(height: 6),

          // _powerWindowChips(),
          const SizedBox(height: 10),

          /// Steering-mounted audio
          item(
            icon: Icons.volume_up,
            label: 'Steering Mounted Audio Control',
            trailing: interiorFeatureValue(
              carDetails.steeringMountedAudioControl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExteriorCondition({required CarModel2 carDetails}) {
    Widget buildExteriorItem(
      String title,
      String value, {
      bool isLast = false,
    }) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 12)),
              ),
              Expanded(
                child: Text(value, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
          if (!isLast) Divider(color: AppColors.grey.withValues(alpha: 0.1)),
        ],
      );
    }

    return AccordionWidget(
      title: 'Exterior Condition',
      icon: Icons.car_rental,
      contentSize: 400,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildExteriorItem('Bonnet', carDetails.bonnet),
          buildExteriorItem('Front Windshield', carDetails.frontWindshield),
          buildExteriorItem('Roof', carDetails.roof),
          buildExteriorItem('Front Bumper', carDetails.frontBumper),
          buildExteriorItem('LHS Headlamp', carDetails.lhsHeadlamp),
          buildExteriorItem('LHS Foglamp', carDetails.lhsFoglamp),
          buildExteriorItem('RHS Headlamp', carDetails.rhsHeadlamp),
          buildExteriorItem('RHS Foglamp', carDetails.rhsFoglamp),
          buildExteriorItem('LHS Fender', carDetails.lhsFender),
          buildExteriorItem('LHS ORVM', carDetails.lhsOrvm),
          buildExteriorItem('LHS A Pillar', carDetails.lhsAPillar),
          buildExteriorItem('LHS B Pillar', carDetails.lhsBPillar),
          buildExteriorItem('LHS C Pillar', carDetails.lhsCPillar),
          buildExteriorItem('LHS Front Alloy', carDetails.lhsFrontAlloy),
          buildExteriorItem('LHS Front Tyre', carDetails.lhsFrontTyre),
          buildExteriorItem('LHS Rear Alloy', carDetails.lhsRearAlloy),
          buildExteriorItem('LHS Rear Tyre', carDetails.lhsRearTyre),
          buildExteriorItem('LHS Front Door', carDetails.lhsFrontDoor),
          buildExteriorItem('LHS Rear Door', carDetails.lhsRearDoor),
          buildExteriorItem('LHS Running Border', carDetails.lhsRunningBorder),
          buildExteriorItem('LHS Quarter Panel', carDetails.lhsQuarterPanel),
          buildExteriorItem('Rear Bumper', carDetails.rearBumper),
          buildExteriorItem('LHS Tail Lamp', carDetails.lhsTailLamp),
          buildExteriorItem('RHS Tail Lamp', carDetails.rhsTailLamp),
          buildExteriorItem('Rear Windshield', carDetails.rearWindshield),
          buildExteriorItem('Boot Door', carDetails.bootDoor),
          buildExteriorItem('Spare Tyre', carDetails.spareTyre),
          buildExteriorItem('Boot Floor', carDetails.bootFloor),
          buildExteriorItem('RHS Rear Alloy', carDetails.rhsRearAlloy),
          buildExteriorItem('RHS Rear Tyre', carDetails.rhsRearTyre),
          buildExteriorItem('RHS Front Alloy', carDetails.rhsFrontAlloy),
          buildExteriorItem('RHS Front Tyre', carDetails.rhsFrontTyre),
          buildExteriorItem('RHS Quarter Panel', carDetails.rhsQuarterPanel),
          buildExteriorItem('RHS A Pillar', carDetails.rhsAPillar),
          buildExteriorItem('RHS B Pillar', carDetails.rhsBPillar),
          buildExteriorItem('RHS C Pillar', carDetails.rhsCPillar),
          buildExteriorItem('RHS Running Border', carDetails.rhsRunningBorder),
          buildExteriorItem('RHS Rear Door', carDetails.rhsRearDoor),
          buildExteriorItem('RHS Front Door', carDetails.rhsFrontDoor),
          buildExteriorItem('RHS ORVM', carDetails.rhsOrvm),
          buildExteriorItem('RHS Fender', carDetails.rhsFender, isLast: true),
        ],
      ),
    );
  }

  Widget _buildBidButton(
    CarDetailsController getxController,
    HomeController homeController,
    BuildContext context,
    String type,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              top: BorderSide(color: AppColors.green.withValues(alpha: 0.5)),
              left: BorderSide(color: AppColors.green.withValues(alpha: 0.5)),
              right: BorderSide(color: AppColors.green.withValues(alpha: 0.5)),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(5, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  getxController.remainingTime.value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// LOGIC: check if type is marketplace
              if (type == homeController.marketplaceSectionScreen)
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    text: 'Request for Auction',
                    onTap: () {
                      Get.dialog(
                        CongratulationsDialogWidget(
                          icon: Icons.assignment_turned_in_outlined,
                          iconSize: 25,
                          title: "Request Sent!",
                          message:
                              "Your request to list this car in auction has been submitted.",
                          buttonText: "OK",
                          onButtonTap: () => Get.back(),
                        ),
                      );
                    },
                    isLoading: false.obs,
                    height: 35,
                    fontSize: 12,
                    elevation: 10,
                    backgroundColor: AppColors.blue,
                  ),
                )
              else
                /// Show normal two buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlaceBidButtonWidget(
                      type: type,
                      getxController: getxController,
                    ),
                    StartAutoBidButtonWidget(
                      type: type,
                      carId: getxController.carId,
                    ),
                  ],
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ShimmerWidget(height: 200, width: double.infinity),
          ),
          const SizedBox(height: 20),

          // Title
          const ShimmerWidget(height: 16, width: 180),
          const SizedBox(height: 10),

          // Price + City
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerWidget(height: 14, width: 100),
              ShimmerWidget(height: 14, width: 80),
            ],
          ),
          const SizedBox(height: 20),

          // Icon and text rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerWidget(height: 12, width: 60),
              ShimmerWidget(height: 12, width: 60),
              ShimmerWidget(height: 12, width: 60),
              ShimmerWidget(height: 12, width: 60),
            ],
          ),
          const SizedBox(height: 30),

          // Section headers and content placeholders
          for (int i = 0; i < 3; i++) ...[
            const ShimmerWidget(height: 14, width: 120),
            const SizedBox(height: 10),
            const ShimmerWidget(height: 12, width: double.infinity),
            const SizedBox(height: 6),
            const ShimmerWidget(height: 12, width: double.infinity),
            const SizedBox(height: 6),
            const ShimmerWidget(height: 12, width: double.infinity),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
