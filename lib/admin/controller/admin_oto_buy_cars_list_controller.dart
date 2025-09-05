import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/socket_events.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class AdminOtoBuyCarsListController extends GetxController {
  RxInt otoBuyCarsCount = 0.obs;
  List<CarsListModel> otoBuyCarsList = [];
  RxBool isLoading = false.obs;

  final RxList<CarsListModel> filteredOtoBuyCarsList = <CarsListModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchOtoBuyCarsList();
    _listenOtoBuyCarsSectionRealtime();
  }

  // Live Cars List
  Future<void> fetchOtoBuyCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus: AppConstants.auctionStatuses.otobuy,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        otoBuyCarsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        otoBuyCarsCount.value = otoBuyCarsList.length;

        filteredOtoBuyCarsList.assignAll(otoBuyCarsList);
      } else {
        filteredOtoBuyCarsList.clear();
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredOtoBuyCarsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Listen to otobuy cars section realtime
  void _listenOtoBuyCarsSectionRealtime() {
    SocketService.instance.joinRoom(SocketEvents.otobuyCarsSectionRoom);

    SocketService.instance.on(SocketEvents.otobuyCarsSectionUpdated, (
      data,
    ) async {
      final String action = '${data['action']}';

      if (action == 'removed') {
        final String id = '${data['id']}';

        // remove from list
        filteredOtoBuyCarsList.removeWhere((c) => c.id == id);

        // update count
        otoBuyCarsCount.value = filteredOtoBuyCarsList.length;
        return;
      }

      if (action == 'added') {
        final String id = '${data['id']}';
        final Map<String, dynamic> carJson = Map<String, dynamic>.from(
          data['car'] ?? const {},
        );
        final incoming = CarsListModel.fromJson(id: id, data: carJson);

        final idx = filteredOtoBuyCarsList.indexWhere((c) => c.id == id);
        if (idx == -1) {
          filteredOtoBuyCarsList.add(incoming);
        } else {
          // replace model (no model timers to cancel anymore)
          filteredOtoBuyCarsList[idx] = incoming;
        }

        // update count
        otoBuyCarsCount.value = filteredOtoBuyCarsList.length;
        return;
      }
    });
  }

  // Future<void> moveCarToOtobuy({
  //   required String carId,
  //   required int? oneClickPrice,
  // }) async {
  //   try {
  //     if (oneClickPrice == null || oneClickPrice <= 0) {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Missing price',
  //         subtitle: 'Please select or enter a valid one-click price.',
  //         type: ToastType.error,
  //       );
  //       return;
  //     }

  //     final body = {'carId': carId, 'oneClickPrice': oneClickPrice};

  //     final response = await ApiService.post(
  //       endpoint: AppUrls.moveCarToOtobuy,
  //       body: body,
  //     );

  //     if (response.statusCode == 200) {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Moved to Otobuy',
  //         subtitle:
  //             'Car moved to otobuy at Rs. ${NumberFormat.decimalPattern('en_IN').format(oneClickPrice.round())}.',
  //         type: ToastType.success,
  //       );
  //       Get.back(); // close sheet
  //     } else {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Failed to move to otobuy',
  //         type: ToastType.error,
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     ToastWidget.show(
  //       context: Get.context!,
  //       title: 'Error moving to otobuy',
  //       type: ToastType.error,
  //     );
  //   }
  // }

  @override
  void onClose() {
    //
    super.onClose();
  }
}
