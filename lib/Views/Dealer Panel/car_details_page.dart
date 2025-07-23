import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Views/Dealer%20Panel/place_bid_button_widget.dart';
import 'package:otobix/Views/Dealer%20Panel/start_auto_bid_button_widget.dart';
import 'package:otobix/Views/Dealer%20Panel/car_images_page.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/congratulations_dialog_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Controllers/car_details_controller.dart';

class CarDetailsPage extends StatelessWidget {
  final CarModel car;
  final String type;

  const CarDetailsPage({super.key, required this.car, required this.type});

  @override
  Widget build(BuildContext context) {
    final getxController = Get.put(CarDetailsController());
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
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          _buildCarImagesList(
                            imageUrls: imageUrls,
                            pageController: pageController,
                            getxController: getxController,
                          ),
                          const SizedBox(height: 10),
                          _buildCarDetails(car: car),
                        ],
                      ),
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
        _buildAppbar(getxController: getxController, car: car),
      ],
    );
  }

  Widget _buildAppbar({
    required CarDetailsController getxController,
    required CarModel car,
  }) {
    return Positioned(
      top: 12,
      left: 16,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.2),
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
                car.name,
                style: const TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarDetails({required CarModel car}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMainDetails(car: car),
          const SizedBox(height: 20),
          _buildIconAndTextDetails(car: car),
          const SizedBox(height: 20),
          _buildOtherDetails(car: car),
          const SizedBox(height: 10),
          _buildInspectionReport(car: car),
          const SizedBox(height: 10),
          _buildExteriorDetails(car: car),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMainDetails({required CarModel car}) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(car.name, style: const TextStyle(fontSize: 12)),
        ),
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
        Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.grey, size: 15),
            Text(car.location, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildIconAndTextDetails({required CarModel car}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Icon(Icons.speed, color: AppColors.grey, size: 20),
            Text(
              NumberFormat.decimalPattern('en_IN').format(car.kmDriven),
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        Column(
          children: [
            const Icon(
              Icons.local_gas_station,
              color: AppColors.grey,
              size: 20,
            ),
            Text(car.fuelType, style: const TextStyle(fontSize: 10)),
          ],
        ),
        Column(
          children: [
            const Icon(Icons.settings, color: AppColors.grey, size: 20),
            const Text('Automatic', style: TextStyle(fontSize: 10)),
          ],
        ),
        Column(
          children: [
            const Icon(Icons.color_lens, color: AppColors.grey, size: 20),
            const Text('White', style: TextStyle(fontSize: 10)),
          ],
        ),
        Column(
          children: [
            const Icon(Icons.event, color: AppColors.grey, size: 20),
            const Text('Dec 2025', style: TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildOtherDetails({required CarModel car}) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Other Details',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        _buildDetailRowForOtherDetails('Registered in', car.location),
        _buildDetailRowForOtherDetails(
          'Condition',
          car.isInspected ? 'Inspected' : 'Not Inspected',
        ),
        _buildDetailRowForOtherDetails('Type', 'SUV'),
        _buildDetailRowForOtherDetails('Transmission', 'Automatic'),
        _buildDetailRowForOtherDetails('Ownership', 'First Owner'),
        _buildDetailRowForOtherDetails('Insurance Validity', 'Dec 2025'),
        _buildDetailRowForOtherDetails('RC Available', 'Yes'),
      ],
    );
  }

  Widget _buildDetailRowForOtherDetails(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 10)),
            Text(value, style: const TextStyle(fontSize: 10)),
          ],
        ),
        Divider(color: AppColors.grey.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildInspectionReport({required CarModel car}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                size: 15,
                color: AppColors.blue,
              ),
              SizedBox(width: 8),
              Text(
                'Inspection Report',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          Divider(color: AppColors.grey.withOpacity(0.5)),
          _buildDetailRowForInspectionReport(
            Icons.date_range,
            'Inspection Date',
            '12 May 2024',
          ),
          const SizedBox(height: 10),
          _buildDetailRowForInspectionReport(
            Icons.description_outlined,
            'Inspection Result',
            'All systems functional. No faults found.',
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
        Icon(icon, size: 15, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExteriorDetails({required CarModel car}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.directions_car_filled_outlined,
                size: 15,
                color: AppColors.blue,
              ),
              SizedBox(width: 8),
              Text(
                'Exterior',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          Divider(color: AppColors.grey.withOpacity(0.5)),
          _buildExteriorItem(
            'Body Condition',
            'Excellent, no dents or scratches',
          ),
          _buildExteriorItem('Paint Quality', 'Original paint, no touch-ups'),
          _buildExteriorItem('Headlights & Tail Lights', 'Fully functional'),
          _buildExteriorItem('Windshield & Windows', 'No cracks or chips'),
          _buildExteriorItem(
            'Tyres Condition',
            'Front 80%, Rear 70% tread remaining',
          ),
          _buildExteriorItem('Spare Tyre', 'Available and unused'),
        ],
      ),
    );
  }

  Widget _buildExteriorItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 15, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title: ',
                style: const TextStyle(fontSize: 10, color: AppColors.black),
                children: [
                  TextSpan(text: value, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
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
                    isLoading: getxController.isLoading,
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
                    StartAutoBidButtonWidget(type: type),
                  ],
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
