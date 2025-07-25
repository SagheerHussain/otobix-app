import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Controllers/home_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/place_bid_button_for_live_bids_section.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Controllers/car_details_controller.dart';
import 'package:otobix/Widgets/place_bid_button_for_ocb70_section.dart';
import 'package:otobix/Widgets/place_bid_button_for_upcoming_section.dart';

class PlaceBidButtonWidget extends StatelessWidget {
  PlaceBidButtonWidget({
    super.key,
    required this.type,
    required this.getxController,
  });

  final String type;
  final CarDetailsController getxController;

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text:
          type == homeController.liveBidsSectionScreen
              ? 'Place Bid'
              : type == homeController.upcomingSectionScreen
              ? 'Pre-Bid'
              : type == homeController.ocb70SectionScreen
              ? 'Buy Now'
              : type == homeController.marketplaceSectionScreen
              ? 'Place Bid'
              : 'Place Bid',
      onTap: () {
        if (type == homeController.liveBidsSectionScreen) {
          placeBidButtonForLiveBidsSection(context, getxController.carId);
        } else if (type == homeController.upcomingSectionScreen) {
          placeBidButtonForUpcomingSection(context, getxController.carId);
        } else if (type == homeController.ocb70SectionScreen) {
          placeBidButtonForOcb70Section(context, getxController.carId);
        } else if (type == homeController.marketplaceSectionScreen) {
          defaultPlaceBidButton(context, getxController.carId);
        } else {
          defaultPlaceBidButton(context, getxController.carId);
        }
      },
      isLoading: getxController.isLoading,
      height: 30,
      fontSize: 10,
      elevation: 10,
    );
  }

  void defaultPlaceBidButton(BuildContext context, String carId) {
    final CarDetailsController bidController = Get.put(
      CarDetailsController(carId),
    );
    bidController.resetBidIncrement();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Top Row: Title + Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Place Your Bid",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.red,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Obx(
                            () => Text(
                              bidController.remainingTime.value,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Bids Box
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Starting Bid
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Bid",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Rs. ${NumberFormat.decimalPattern('en_IN').format(bidController.currentHighestBidAmount)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 30, color: AppColors.grey),
                        // Last Bid
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Your Bid",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(
                              () => Text(
                                "Rs. ${NumberFormat.decimalPattern('en_IN').format(bidController.yourOfferAmount.value)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Bid Controller
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minus
                        GestureDetector(
                          onTap: () {
                            bidController.decreaseBid();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.red),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: AppColors.red,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        // Bid Value
                        Obx(
                          () => Column(
                            children: [
                              Text(
                                "Rs. ${NumberFormat.decimalPattern('en_IN').format(bidController.yourOfferAmount.value)}",
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Bid increase by ${NumberFormat.decimalPattern('en_IN').format(bidController.yourOfferAmount.value - bidController.currentHighestBidAmount)}",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        // Plus
                        GestureDetector(
                          onTap: () {
                            bidController.increaseBid();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.green),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: AppColors.green,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Bid Button
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          text: "Place Bid",
                          isLoading: bidController.isLoading,
                          onTap: () {
                            Get.back();
                          },
                          height: 35,
                          fontSize: 12,
                          elevation: 10,
                          backgroundColor: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
