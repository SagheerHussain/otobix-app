import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/socket_events.dart';
import 'package:otobix/Widgets/congratulations_dialog_widget.dart';
import 'package:otobix/Widgets/offering_bid_sheet.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/helpers/Preferences_helper.dart';

class CarDetailsController extends GetxController {
  static const String basicDetailsSectionKey = 'basic';
  static const String documentDetailsSectionKey = 'document';
  static const String exteriorSectionKey = 'exterior';
  static const String engineBaySectionKey = 'engineBay';
  static const String steeringBrakesAndSuspensionSectionKey =
      'steeringBrakesAndSuspension';
  static const String interiorAndElectricalsSectionKey =
      'interiorAndElectricals';
  static const String airConditioningSectionKey = 'airConditioning';

  final sectionKeys = {
    basicDetailsSectionKey: GlobalKey(),
    documentDetailsSectionKey: GlobalKey(),
    exteriorSectionKey: GlobalKey(),
    engineBaySectionKey: GlobalKey(),
    steeringBrakesAndSuspensionSectionKey: GlobalKey(),
    interiorAndElectricalsSectionKey: GlobalKey(),
    airConditioningSectionKey: GlobalKey(),
  };

  final ScrollController scrollController = ScrollController();
  final sectionTabScrollController = ScrollController();
  final sectionTabKeys = <String, GlobalKey>{};
  RxString currentSection = basicDetailsSectionKey.obs;

  final currentIndex = 0.obs;
  // final imageUrls = <String>[].obs;
  final RxList<CarsListTitleAndImage> imageUrls = <CarsListTitleAndImage>[].obs;

  RxBool isLoading = false.obs;
  RxBool isPlaceBidButtonLoading = false.obs;

  final remainingTime = ''.obs;
  Timer? _timer;

  RxDouble currentHighestBidAmount = 0.0.obs;
  RxDouble yourOfferAmount = 0.0.obs;
  RxDouble oneClickPriceAmount = 0.0.obs;

  /// NEW: keep track of first click
  bool isFirstClick = true;

  CarModel? carDetails;

  final String carId;

  CarDetailsController(this.carId);

  @override
  void onInit() async {
    super.onInit();
    await fetchCarDetails(carId: carId);
    listenUpdatedBidAndChangeHighestBidLocally();
    // await fetchCarDetails(carId: '68821747968635d593293346');
    // debugPrint(carDetails?.toJson().toString() ?? 'null');
    // Initialize keys for each tab
    for (var key in sectionKeys.keys) {
      sectionTabKeys[key] = GlobalKey();
    }
    scrollController.addListener(() {
      for (var entry in sectionKeys.entries) {
        final context = entry.value.currentContext;
        if (context != null) {
          final box = context.findRenderObject() as RenderBox;
          final position = box.localToGlobal(Offset.zero, ancestor: null).dy;

          // Adjust 100 based on height of sticky headers
          if (position < MediaQuery.of(Get.context!).padding.top + 210 &&
              position > 0) {
            currentSection.value = entry.key;

            // Scroll horizontal tab bar
            scrollToSectionTab(entry.key);
            break;
          }
        }
      }
    });
  }

  Future<void> fetchCarDetails({required String carId}) async {
    // final carId = '68821747968635d593293346';
    isLoading.value = true;
    try {
      final url = AppUrls.getCarDetails(carId);
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        carDetails = CarModel.fromJson(
          json: data['carDetails'],
          documentId: data['carDetails']['_id'],
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
    double increment = isFirstClick ? 1000 : 1000;
    yourOfferAmount.value += increment;

    // After first click, switch to 1000 increment
    if (isFirstClick) {
      isFirstClick = false;
    }
  }

  void decreaseBid() {
    double decrement = isFirstClick ? 4000 : 1000;
    if (yourOfferAmount.value - decrement >= currentHighestBidAmount.value) {
      yourOfferAmount.value -= decrement;
    }
  }

  /// Reset increments whenever sheet opens
  void resetBidIncrement() {
    isFirstClick = true;
  }

  // void setImageUrls(List<String> urls) {
  //   imageUrls.assignAll(urls);
  // }
  void setImageUrls(List<CarsListTitleAndImage> urls) {
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

  bool isValidComment(String? comment) {
    final val = comment?.trim().toLowerCase() ?? '';
    return val.isNotEmpty && val != 'n/a';
  }

  void scrollToSection(String key) {
    final context = sectionKeys[key]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
    // Workaround: Scroll again with offset to account for pinned header height
    Future.delayed(const Duration(milliseconds: 450), () {
      scrollController.animateTo(
        scrollController.offset - 10, // Adjust based on your sticky headers
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void scrollToSectionTab(String key) {
    final keyContext = sectionTabKeys[key]?.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: null).dx;

      final screenWidth = Get.context!.size!.width;
      final scrollOffset = sectionTabScrollController.offset;

      // Center the selected tab
      final targetOffset =
          scrollOffset + position - (screenWidth / 2) + (box.size.width / 2);

      sectionTabScrollController.animateTo(
        targetOffset.clamp(
          sectionTabScrollController.position.minScrollExtent,
          sectionTabScrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  //  Listen and Update Bid locally
  void listenUpdatedBidAndChangeHighestBidLocally() {
    SocketService.instance.joinRoom('car-$carId');
    SocketService.instance.on(SocketEvents.bidUpdated, (data) {
      final String incomingCarId = data['carId'];
      final double newBid = (data['highestBid'] as num).toDouble();

      if (carDetails != null && carDetails!.id == incomingCarId) {
        currentHighestBidAmount.value = newBid;
        debugPrint('✅ Updated currentHighestBidAmount to $newBid');
      }
      debugPrint('📢 Bid update received: $data');
    });
  }

  // place bid
  Future<bool> placeBid({
    required String carId,
    required double newBidAmount,
  }) async {
    try {
      isPlaceBidButtonLoading.value = true;

      final currentUserId = await SharedPrefsHelper.getString(
        SharedPrefsHelper.userIdKey,
      );

      final response = await ApiService.post(
        endpoint: AppUrls.updateCarBid,
        body: {
          'carId': carId,
          'newBidAmount': newBidAmount,
          'userId': currentUserId,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Bid updated successfully: $data");
        ToastWidget.show(
          context: Get.context!,
          title: "You're Winning! 🏆",
          subtitle: "Great job! Currently, you're the highest bidder now.",
          toastDuration: 5,
          type: ToastType.success,
        );

        return true;
      } else if (response.statusCode == 403) {
        debugPrint("❌ Failed to update bid: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Bid must be higher than current highest bid.",
          type: ToastType.error,
        );
        return false;
      } else {
        debugPrint("❌ Failed to update bid: ${response.body}");
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to place bid",
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      debugPrint("❗ Exception updating bid: $e");
      return false;
    } finally {
      isPlaceBidButtonLoading.value = false;
    }
  }

  // submit auto bid
  Future<void> submitAutoBidForLiveSection({
    required String carId,
    required int maxAmount,
    int increment = 1000,
  }) async {
    try {
      Get.back();
      final userId = await SharedPrefsHelper.getString(
        SharedPrefsHelper.userIdKey,
      );
      final res = await ApiService.post(
        endpoint: AppUrls.submitAutoBidForLiveSection,
        body: {
          'carId': carId,
          'userId': userId,
          'autoBidAmount': maxAmount,
          'increment': increment,
        },
      );

      if (res.statusCode == 200) {
        Get.dialog(
          CongratulationsDialogWidget(
            icon: Icons.gavel,
            iconSize: 25,
            title: "Auto Bid Submitted!",
            message: "Your auto bid has been set successfully.",
            buttonText: "OK",
            onButtonTap: () => Get.back(),
          ),
        );
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to submit auto bid',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("❗ Exception updating bid: $e");
    }
  }
}
