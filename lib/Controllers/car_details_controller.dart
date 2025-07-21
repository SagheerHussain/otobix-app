import 'dart:async';
import 'package:get/get.dart';
import 'package:otobix/Widgets/offering_bid_sheet.dart';

class CarDetailsController extends GetxController {
  final currentIndex = 0.obs;
  final imageUrls = <String>[].obs;
  final isLoading = false.obs;

  final remainingTime = ''.obs;
  Timer? _timer;

  RxInt yourOfferAmount = 54000.obs;
  final int currentBidAmount = 54000;

  /// NEW: keep track of first click
  bool isFirstClick = true;

  ////////////////////////////////////////////////
  // Offering your bid progress
  Timer? _offeringYourBidTimer;
  RxDouble offeringYourBidProgress = 1.0.obs;
  RxInt offeringYourBidCountdown = 30.obs;
  void startOfferingBidTimer({required int seconds}) {
    _offeringYourBidTimer?.cancel();
    offeringYourBidProgress.value = 1.0;
    offeringYourBidCountdown.value = seconds;

    const tickInterval = Duration(milliseconds: 100);
    int ticks = 0;
    int totalTicks = seconds * 10;

    _offeringYourBidTimer = Timer.periodic(tickInterval, (timer) {
      ticks++;
      offeringYourBidProgress.value = 1.0 - (ticks / totalTicks);
      offeringYourBidCountdown.value = seconds - (ticks ~/ 10);

      if (ticks >= totalTicks) {
        timer.cancel();
        _offeringYourBidTimer = null;
        Get.back(); // auto close bottom sheet
        Future.delayed(Duration(milliseconds: 300), () {
          showWinDialog(); // Call your dialog
        });
      }
    });
  }

  void cancelOfferingBid() {
    _offeringYourBidTimer?.cancel();
    _offeringYourBidTimer = null;
    Get.back(); // auto close bottom sheet
  }

  ////////////////////////////////////////

  /// increase bid logic
  void increaseBid() {
    int increment = isFirstClick ? 4000 : 1000;
    yourOfferAmount.value += increment;

    // After first click, switch to 1000 increment
    if (isFirstClick) {
      isFirstClick = false;
    }
  }

  void decreaseBid() {
    int decrement = isFirstClick ? 4000 : 1000;
    if (yourOfferAmount.value - decrement >= currentBidAmount) {
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
