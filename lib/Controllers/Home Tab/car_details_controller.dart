import 'dart:async';
import 'package:get/get.dart';

class CarDetailsController extends GetxController {
  final currentIndex = 0.obs;
  final imageUrls = <String>[].obs;
  final isLoading = false.obs;

  final remainingTime = ''.obs;
  Timer? _timer;

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

  void startCountdown1(DateTime endTime) {
    _timer?.cancel(); // clear previous timer if any

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = endTime.difference(now);

      if (diff.isNegative) {
        remainingTime.value = "00h:00m:00s";
        _timer?.cancel();
      } else {
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
        remainingTime.value = "$hours:$minutes:$seconds";
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
