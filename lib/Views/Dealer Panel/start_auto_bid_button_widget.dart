import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/car_details_controller.dart';

class StartAutoBidButtonWidget extends StatelessWidget {
  StartAutoBidButtonWidget({super.key});

  final CarDetailsController getxController = Get.put(CarDetailsController());

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text: 'Start Auto Bid',
      onTap: () {
        showAutoBidSheet();
      },
      isLoading: getxController.isLoading,
      height: 30,
      fontSize: 10,
      backgroundColor: AppColors.blue,
      elevation: 10,
    );
  }

  // Auto Bid Sheet
  void showAutoBidSheet() {
    final CarDetailsController bidController = Get.put(CarDetailsController());
    bidController.resetBidIncrement();
    // final TextEditingController bidAmountController = TextEditingController();

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
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
                        "Place Auto Bid",
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
                              getxController.remainingTime.value,
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
                              "Current Bid Amount",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Rs. 54,000",
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
                              "Your Bid Amount",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(
                              () => Text(
                                "Rs. ${NumberFormat.decimalPattern('en_IN').format(bidController.bidAmount.value)}",
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
                               "Rs. ${NumberFormat.decimalPattern('en_IN').format(bidController.bidAmount.value)}",
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Obx(
                                () => Text(
                                  "Bid increase by Rs. ${NumberFormat.decimalPattern('en_IN').format(bidController.bidAmount.value - 54000)}",
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
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
                          text: "Start Auto Bid",
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
