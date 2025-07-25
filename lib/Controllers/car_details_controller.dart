import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/car_model2.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/offering_bid_sheet.dart';

class CarDetailsController extends GetxController {
  final currentIndex = 0.obs;
  final imageUrls = <String>[].obs;
  RxBool isLoading = false.obs;

  final remainingTime = ''.obs;
  Timer? _timer;

  int currentHighestBidAmount = 54000;
  RxInt yourOfferAmount = 54000.obs;
  RxInt oneClickPriceAmount = 0.obs;

  /// NEW: keep track of first click
  bool isFirstClick = true;

  CarModel2? carDetails;

  final String carId;

  CarDetailsController(this.carId);

  @override
  void onInit() async {
    super.onInit();
    await fetchCarDetails(carId: carId);
    // await fetchCarDetails(carId: '68821747968635d593293346');
    debugPrint(carDetails?.toJson().toString() ?? 'null');
  }

  Future<void> fetchCarDetails({required String carId}) async {
    // final carId = '68821747968635d593293346';
    isLoading.value = true;
    try {
      final url = AppUrls.getCarDetails(carId);
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        carDetails = CarModel2.fromJson(
          data['carDetails'],
          data['carDetails']['_id'],
        );
        debugPrint('Car Details Fetched Successfully');
      } else {
        debugPrint('Failed to load data ${response.body}');
        carDetails = null;
      }
    } catch (error) {
      debugPrint('Failed to load data: $error');
      carDetails = null;
    } finally {
      isLoading.value = false;
    }
  }

  ////////////////////////////////////////////////
  // Offering your bid progress
  Timer? offeringYourBidTimer;
  RxDouble offeringYourBidProgress = 1.0.obs;
  RxInt offeringYourBidCountdown = 30.obs;
  void startOfferingBidTimer({required int seconds}) {
    offeringYourBidTimer?.cancel();
    offeringYourBidProgress.value = 1.0;
    offeringYourBidCountdown.value = seconds;

    const tickInterval = Duration(milliseconds: 100);
    int ticks = 0;
    int totalTicks = seconds * 10;

    offeringYourBidTimer = Timer.periodic(tickInterval, (timer) {
      ticks++;
      offeringYourBidProgress.value = 1.0 - (ticks / totalTicks);
      offeringYourBidCountdown.value = seconds - (ticks ~/ 10);

      if (ticks >= totalTicks) {
        timer.cancel();
        offeringYourBidTimer = null;
        Get.back(); // auto close bottom sheet
        Future.delayed(Duration(milliseconds: 300), () {
          showWinDialog(); // Call your dialog
        });
      }
    });
  }

  void cancelOfferingBid() {
    offeringYourBidTimer?.cancel();
    offeringYourBidTimer = null;
    Get.back(); // auto close bottom sheet
  }

  ////////////////////////////////////////

  /// increase bid logic
  void increaseBid() {
    int increment = isFirstClick ? 1000 : 1000;
    yourOfferAmount.value += increment;

    // After first click, switch to 1000 increment
    if (isFirstClick) {
      isFirstClick = false;
    }
  }

  void decreaseBid() {
    int decrement = isFirstClick ? 4000 : 1000;
    if (yourOfferAmount.value - decrement >= currentHighestBidAmount) {
      yourOfferAmount.value -= decrement;
    }
  }

  /// Reset increments whenever sheet opens
  void resetBidIncrement() {
    isFirstClick = true;
  }

  void setImageUrls(List<String> urls) {
    imageUrls.assignAll(urls);
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void startCountdown(DateTime endTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = endTime.difference(now);

      if (diff.isNegative) {
        remainingTime.value = "00h : 00m : 00s";
        _timer?.cancel();
      } else {
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
        remainingTime.value = "${hours}h : ${minutes}m : ${seconds}s";
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
