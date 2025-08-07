import 'package:get/get.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'dart:convert';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminCarAuctionTimerController extends GetxController {
  final RxList<CarsListModel> cars = <CarsListModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCars();
  }

  Future<void> fetchCars() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(endpoint: AppUrls.getCarsList);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        cars.value = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(id: car['id'], data: car),
          ),
        );
      } else {
        cars.clear();
      }
    } catch (e) {
      cars.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void updateAuctionFields({
    required String carId,
    required DateTime newStartTime,
    required int newDuration,
  }) {
    final index = cars.indexWhere((c) => c.id == carId);
    if (index != -1) {
      cars[index].auctionStartTime = newStartTime;
      cars[index].defaultAuctionTime = newDuration;
      cars.refresh();
    }
  }

  Future<void> updateAuctionTime({
    required String carId,
    DateTime? newStartTime,
    int? newDuration,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'carId': carId,
        if (newStartTime != null)
          'auctionStartTime': newStartTime.toIso8601String(),
        if (newDuration != null) 'defaultAuctionTime': newDuration,
      };

      final response = await ApiService.post(
        endpoint: AppUrls.updateCarAuctionTime,
        body: body,
      );

      if (response.statusCode == 200) {
        // Update local model too
        final index = cars.indexWhere((c) => c.id == carId);
        if (index != -1) {
          if (newStartTime != null) {
            cars[index].auctionStartTime = newStartTime;
          }
          if (newDuration != null) {
            cars[index].defaultAuctionTime = newDuration;
          }
        }
        ToastWidget.show(
          context: Get.context!,
          title: 'Auction time updated successfully',
          type: ToastType.success,
        );
        fetchCars();
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to update auction time',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Failed to update auction time',
        type: ToastType.error,
      );
    }
  }
}
