import 'dart:async';
import 'package:get/get.dart';

class CarDetailsController extends GetxController {
  final currentIndex = 0.obs;
  final imageUrls = <String>[].obs;
  final isLoading = false.obs;

  final remainingTime = ''.obs;
  Timer? _timer;

  RxInt bidAmount = 56000.obs;
  final int minBid = 54000;

  /// NEW: keep track of first click
  bool isFirstClick = true;

  /// increase bid logic
  void increaseBid() {
    int increment = isFirstClick ? 4000 : 1000;
    bidAmount.value += increment;

    // After first click, switch to 1000 increment
    if (isFirstClick) {
      isFirstClick = false;
    }
  }

  void decreaseBid() {
    int decrement = isFirstClick ? 4000 : 1000;
    if (bidAmount.value - decrement >= minBid) {
      bidAmount.value -= decrement;
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
