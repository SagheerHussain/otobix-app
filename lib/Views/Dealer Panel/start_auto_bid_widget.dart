import 'package:flutter/material.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/car_details_controller.dart';
import 'package:otobix/Widgets/toast_widget.dart';

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
    final TextEditingController bidAmountController = TextEditingController();

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.35,
          minChildSize: 0.35,
          maxChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
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
                  const Text(
                    "Place Auto Bid",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Bid Increment Amount",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: bidAmountController,
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'e.g. 5000',
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: AppColors.grey),
                      ),
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          isLoading: false.obs,
                          text: 'Cancel',
                          backgroundColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          height: 30,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ButtonWidget(
                          text: 'Start Auto Bid',
                          onTap: () {
                            Get.back();
                            ToastWidget.show(
                              context: Get.context!,
                              message: "Auto Bid Started",
                              type: ToastType.success,
                            );
                          },
                          height: 30,
                          backgroundColor: AppColors.green,
                          isLoading: false.obs,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
