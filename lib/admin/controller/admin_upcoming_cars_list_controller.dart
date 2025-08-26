import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';

class AdminUpcomingCarsListController extends GetxController {
  RxInt upcomingCarsCount = 0.obs;
  List<CarsListModel> upcomingCarsList = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchUpcomingCarsList();
  }

  final RxList<CarsListModel> filteredUpcomingCarsList = <CarsListModel>[].obs;

  // Live Cars List
  Future<void> fetchUpcomingCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus: AppConstants.auctionStatuses.upcoming,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // final currentTime = DateTime.now();

        upcomingCarsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        upcomingCarsCount.value = upcomingCarsList.length;

        // Only keep cars with future auctionEndTime
        filteredUpcomingCarsList.value = upcomingCarsList;

        // for (var car in upcomingCarsList) {
        //   await startAuctionCountdown(car);
        // }
      } else {
        filteredUpcomingCarsList.clear();
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredUpcomingCarsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Auction Timer
  // Future<void> startAuctionCountdown(CarsListModel car) async {
  //   DateTime getAuctionEndTime() {
  //     final startTime = car.auctionStartTime ?? DateTime.now();
  //     final duration = Duration(
  //       hours: car.auctionDuration > 0 ? car.auctionDuration : 12,
  //       // hours: car.defaultAuctionTime,
  //     );
  //     return startTime.add(duration);
  //   }

  //   car.auctionTimer?.cancel(); // cancel previous

  //   car.auctionTimer = Timer.periodic(Duration(seconds: 1), (_) {
  //     final now = DateTime.now();
  //     final diff = getAuctionEndTime().difference(now);

  //     if (diff.isNegative) {
  //       // 🟥 Timer expired — reset startTime and countdown to now + 12 hours
  //       car.auctionStartTime = DateTime.now();
  //       car.auctionDuration = 12;

  //       final newDiff = Duration(hours: 12);
  //       // final newDiff = Duration(hours: 0);

  //       final hours = newDiff.inHours.toString().padLeft(2, '0');
  //       final minutes = (newDiff.inMinutes % 60).toString().padLeft(2, '0');
  //       final seconds = (newDiff.inSeconds % 60).toString().padLeft(2, '0');
  //       car.remainingAuctionTime.value =
  //           '${hours}h : ${minutes}m : ${seconds}s';
  //     } else {
  //       final hours = diff.inHours.toString().padLeft(2, '0');
  //       final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
  //       final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
  //       car.remainingAuctionTime.value =
  //           '${hours}h : ${minutes}m : ${seconds}s';
  //     }
  //   });
  // }

  @override
  void onClose() {
    // for (var car in upcomingCarsList) {
    //   car.auctionTimer?.cancel();
    // }
    super.onClose();
  }
}
