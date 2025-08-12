import 'dart:async';
import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/socket_events.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/helpers/Preferences_helper.dart';
import '../Network/api_service.dart';

class HomeController extends GetxController {
  List<CarsListModel> carsList = [];
  RxBool isLoading = false.obs;
  final RxInt unreadNotificationsCount = 0.obs;
  // RxString remainingAuctionTime = '00h : 00m : 00s'.obs;
  // Timer? _auctionTimer;

  TextEditingController searchController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController searchStateController = TextEditingController();

  // Screen types
  final String liveBidsSectionScreen = 'live_bids';
  final String upcomingSectionScreen = 'upcoming';
  final String ocb70SectionScreen = 'ocb70';
  final String marketplaceSectionScreen = 'marketplace';

  // dummy add/remove cars to favorite
  final RxList<CarsListModel> favorites = <CarsListModel>[].obs;

  final RxList<CarsListModel> marketplaceCars = <CarsListModel>[].obs;

  void changeFavoriteCars(CarsListModel car) {
    car.isFavorite.value = !car.isFavorite.value;

    if (car.isFavorite.value) {
      favorites.add(car);
      ToastWidget.show(
        context: Get.context!,
        title: 'Added to wishlist',
        type: ToastType.success,
      );
    } else {
      favorites.remove(car);
      ToastWidget.show(
        context: Get.context!,
        title: 'Removed from wishlist',
        type: ToastType.error,
      );
    }
  }

  // single instance of ValueNotifier
  RxInt liveCarsCount = 0.obs;
  RxInt upcomingCarsCount = 0.obs;
  RxInt otoBuyCarsCount = 0.obs;
  RxInt marketplaceCarsCount = 0.obs;

  final selectedSegmentNotifier = ValueNotifier<String>('live');

  // final segments =
  //     {'live': 'Live (23)', 'ocb': 'OCB (10)', 'marketplace': 'Marketplace (5)'}.obs;

  RxString selectedSegment = 'live'.obs;

  RxString selectedCity = 'All States'.obs;

  final List<String> cities = ['All States', ...AppConstants.indianStates];

  @override
  void onInit() async {
    super.onInit();
    await getUnreadNotificationsCount();
    await fetchCarsList();
    listenUpdatedBidAndChangeHighestBidLocally();
    listenToAuctionWonEvent();
    // filteredCars.value = carsList;
    // Listen to changes in ValueNotifier
    selectedSegmentNotifier.addListener(() {
      selectedSegment.value = selectedSegmentNotifier.value;
    });

    // Initialize controllers with default values
    minPriceController.text = selectedPriceRange.value.start.toInt().toString();
    maxPriceController.text = selectedPriceRange.value.end.toInt().toString();
  }

  var selectedMakeFilter = Rx<String?>(null);
  var selectedModelFilter = Rx<String?>(null);
  var selectedVariantFilter = Rx<String?>(null);
  var selectedYearFilter = Rx<int?>(null);

  final RxList<String> selectedFuelTypesFilter = <String>[].obs;

  final Rx<RangeValues> selectedPriceRange = RangeValues(0, 20).obs; // in Lacs
  final double minPrice = 0;
  final double maxPrice = 50; // Lacs

  final List<String> makesListFilter = ['Toyota', 'Honda', 'Hyundai'];

  final Map<String, List<String>> modelsListFilter = {
    'Toyota': ['Corolla', 'Yaris'],
    'Honda': ['Civic', 'City'],
    'Hyundai': ['i20', 'Creta'],
  };

  final Map<String, List<String>> variantsListFilter = {
    'Corolla': ['XLi', 'GLi'],
    'Yaris': ['1.3L', '1.5L'],
    'Civic': ['Oriel', 'Turbo'],
    'City': ['Aspire', 'i-VTEC'],
    'i20': ['Sportz', 'Asta'],
    'Creta': ['EX', 'SX'],
  };

  final RxList<CarsListModel> filteredCars = <CarsListModel>[].obs;

  Future<void> fetchCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList;
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final currentTime = DateTime.now();

        carsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        liveCarsCount.value = carsList.length;
        // Temp for now
        upcomingCarsCount.value = carsList.length;
        otoBuyCarsCount.value = carsList.length;
        marketplaceCarsCount.value = carsList.length;
        ///////////////

        // filteredCars.value = carsList;
        // Only keep cars with future auctionEndTime
        filteredCars.value =
            carsList.where((car) {
              return car.auctionEndTime != null &&
                  // car.auctionStatus == AppConstants.auctionStatuses.live &&
                  car.auctionEndTime!.isAfter(currentTime);
            }).toList();

        for (var car in carsList) {
          await startAuctionCountdown(car);
        }

        debugPrint('Cars List Fetched Successfully');
        // debugPrint(carsList[1].toJson().toString());
      } else {
        filteredCars.value = [];
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredCars.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Listen and Update Bid locally
  void listenUpdatedBidAndChangeHighestBidLocally() {
    SocketService.instance.on(SocketEvents.bidUpdated, (data) {
      final String carId = data['carId'];
      final int highestBid = data['highestBid'];

      final index = filteredCars.indexWhere((c) => c.id == carId);
      if (index != -1) {
        filteredCars[index].highestBid.value =
            highestBid.toDouble(); // ✅ this is the real-time field
      }
      debugPrint('📢 Bid update received: $data');
    });
  }

  // Auction Timer
  Future<void> startAuctionCountdown(CarsListModel car) async {
    DateTime getAuctionEndTime() {
      final startTime = car.auctionStartTime ?? DateTime.now();
      final duration = Duration(
        hours: car.auctionDuration > 0 ? car.auctionDuration : 12,
        // hours: car.defaultAuctionTime,
      );
      return startTime.add(duration);
    }

    // final String userId =
    //     await SharedPrefsHelper.getString(SharedPrefsHelper.userTypeKey) ?? '';

    car.auctionTimer?.cancel(); // cancel previous

    car.auctionTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = getAuctionEndTime().difference(now);

      if (diff.isNegative) {
        // 🟥 Timer expired — reset startTime and countdown to now + 12 hours
        car.auctionStartTime = DateTime.now();
        car.auctionDuration = 12;

        final newDiff = Duration(hours: 12);
        // final newDiff = Duration(hours: 0);

        final hours = newDiff.inHours.toString().padLeft(2, '0');
        final minutes = (newDiff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (newDiff.inSeconds % 60).toString().padLeft(2, '0');
        car.remainingAuctionTime.value =
            '${hours}h : ${minutes}m : ${seconds}s';
      } else {
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
        car.remainingAuctionTime.value =
            '${hours}h : ${minutes}m : ${seconds}s';
      }
    });
  }

  @override
  void onClose() {
    for (var car in carsList) {
      car.auctionTimer?.cancel();
    }
    super.onClose();
  }

  // // dummy
  // Future<bool> checkIfUserIsHighestBidder({
  //   required String carId,
  //   required String userId,
  // }) async {
  //   try {
  //     final url = AppUrls.checkHighestBidder;
  //     final response = await ApiService.post(
  //       endpoint: url,
  //       body: {'carId': carId, 'userId': userId},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final isHighest = data['isHighestBidder'] as bool;
  //       debugPrint('✅ checkIfUserIsHighestBidder → $isHighest');
  //       return isHighest;
  //     } else {
  //       debugPrint('❌ Failed to check highest bidder: ${response.body}');
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Error checking highest bidder: $e');
  //     return false;
  //   }
  // }

  // Listen to Auction Won Event
  void listenToAuctionWonEvent() async {
    final currentUserId = await SharedPrefsHelper.getString(
      SharedPrefsHelper.userIdKey,
    );
    SocketService.instance.on(SocketEvents.auctionEnded, (data) {
      // Defensive parsing
      final winnerId = '${data['winnerId'] ?? ''}';
      final winnerName = '${data['winnerName'] ?? ''}';
      final carName = '${data['carName'] ?? ''}';
      final carId = '${data['carId'] ?? ''}';
      final num bidAmountNum =
          (data['bidAmount'] is num)
              ? data['bidAmount'] as num
              : num.tryParse('${data['bidAmount']}') ?? 0;
      final biddersList =
          (data['biddersList'] as List? ?? const []).map((e) => '$e').toSet();

      final bool isWinner = winnerId == currentUserId;
      final bool isLoser = !isWinner && biddersList.contains(currentUserId);

      // Format INR nicely
      final amount = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      ).format(bidAmountNum);

      debugPrint(data.toString());

      if (isWinner) {
        // 🎉 Show dialog if the current user won
        showWinDialog();
        return;
      }
      if (isLoser) {
        final ctx = Get.overlayContext ?? Get.context;
        if (ctx != null) {
          ToastWidget.show(
            context: ctx,
            toastDuration: 10,
            title:
                'You didn’t win the auction for ${carName.isEmpty ? 'car $carId' : carName}. '
                'Winning bid: $amount by ${winnerName.isEmpty ? winnerId : winnerName}.',
            type: ToastType.error,
          );
        }
      }
    });
  }

  // Show dialog if the current user won
  void showWinDialog() {
    final ConfettiController confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    confettiController.play(); // Start confetti

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "🎉 You Won the Bid!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Congratulations on your successful offer!",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ButtonWidget(
                    onTap: () => Get.back(),
                    text: "View Details",
                    isLoading: false.obs,
                    height: 40,
                    width: 150,
                    backgroundColor: AppColors.green,
                    textColor: AppColors.white,
                    loaderSize: 15,
                    loaderStrokeWidth: 1,
                    loaderColor: AppColors.white,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -10,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                maxBlastForce: 20,
                minBlastForce: 5,
                gravity: 0.3,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Unread Notifications Count
  Future<void> getUnreadNotificationsCount() async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    try {
      final url = AppUrls.userNotificationsUnreadNotificationsCount(
        userId: userId,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        unreadNotificationsCount.value = data['unreadCount'] ?? 0;
        debugPrint(
          'Unread Notifications Count: ${unreadNotificationsCount.value}',
        );
      } else {
        debugPrint(
          'Failed to fetch unread notifications count ${response.body}',
        );
      }
    } catch (error) {
      debugPrint('Failed to fetch unread notifications count: $error');
    }
  }

  // Add Car To Wishlist
  Future<void> addCarToWishlist({required String carId}) async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    try {
      final url = AppUrls.addToWishlist;
      final response = await ApiService.post(
        endpoint: url,
        body: {'userId': userId, 'carId': carId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Car successfully added to favourites: $data');
        ToastWidget.show(
          context: Get.context!,
          title: 'Car added to favourites',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to add car to favourites ${response.body}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to add car to favourites',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Failed to add car to favourites: $error');
    }
  }

  // final List<CarModel> carsList1 = [
  //   CarModel(
  //     imageUrl: AppImages.tataNexon1,
  //     name: 'Tata Nexon',
  //     price: 1200000,
  //     year: 2021,
  //     kmDriven: 15000,
  //     fuelType: 'Petrol',
  //     location: 'Mumbai',
  //     isInspected: true,
  //     imageUrls: [
  //       AppImages.tataNexon1,
  //       AppImages.tataNexon2,
  //       AppImages.tataNexon3,
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.marutiSuzukiBaleno1,
  //     name: 'Maruti Suzuki Baleno',
  //     price: 850000,
  //     year: 2020,
  //     kmDriven: 22000,
  //     fuelType: 'Petrol',
  //     location: 'Delhi',
  //     imageUrls: [
  //       AppImages.marutiSuzukiBaleno1,
  //       AppImages.marutiSuzukiBaleno2,
  //       AppImages.marutiSuzukiBaleno3,
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.hyundaiCreta1,
  //     name: 'Hyundai Creta',
  //     price: 1600000,
  //     year: 2022,
  //     kmDriven: 8000,
  //     fuelType: 'Diesel',
  //     location: 'Bengaluru',
  //     isInspected: true,
  //     imageUrls: [
  //       AppImages.hyundaiCreta1,
  //       AppImages.hyundaiCreta2,
  //       AppImages.hyundaiCreta3,
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.marutiSuzukiSwift1,
  //     name: 'Maruti Suzuki Swift',
  //     price: 700000,
  //     year: 2019,
  //     kmDriven: 30000,
  //     fuelType: 'Petrol',
  //     location: 'Pune',
  //     isInspected: true,
  //     imageUrls: [AppImages.marutiSuzukiSwift1],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.mahindraThar1,
  //     name: 'Mahindra Thar',
  //     price: 1450000,
  //     year: 2021,
  //     kmDriven: 12000,
  //     fuelType: 'Diesel',
  //     location: 'Chandigarh',
  //     imageUrls: [
  //       AppImages.mahindraThar1,
  //       AppImages.mahindraThar2,
  //       AppImages.mahindraThar3,
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.tataHarrier1,
  //     name: 'Tata Harrier',
  //     price: 1750000,
  //     year: 2022,
  //     kmDriven: 5000,
  //     fuelType: 'Diesel',
  //     location: 'Hyderabad',
  //     imageUrls: [AppImages.tataHarrier1],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.kiaSeltos1,
  //     name: 'Kia Seltos',
  //     price: 1400000,
  //     year: 2020,
  //     kmDriven: 18000,
  //     fuelType: 'Petrol',
  //     location: 'Ahmedabad',
  //     isInspected: true,
  //     imageUrls: [
  //       AppImages.kiaSeltos1,
  //       AppImages.kiaSeltos2,
  //       AppImages.kiaSeltos3,
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.hondaCity1,
  //     name: 'Honda City',
  //     price: 1100000,
  //     year: 2019,
  //     kmDriven: 35000,
  //     fuelType: 'Petrol',
  //     location: 'Kolkata',
  //     imageUrls: [AppImages.hondaCity1],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.jeepCompass1,
  //     name: 'Jeep Compass',
  //     price: 1850000,
  //     year: 2021,
  //     kmDriven: 10000,
  //     fuelType: 'Diesel',
  //     location: 'Jaipur',
  //     isInspected: true,
  //     imageUrls: [AppImages.jeepCompass1],
  //   ),
  //   CarModel(
  //     imageUrl: AppImages.renaultKwid1,
  //     name: 'Renault Kwid',
  //     price: 450000,
  //     year: 2018,
  //     kmDriven: 42000,
  //     fuelType: 'Petrol',
  //     location: 'Surat',
  //     isInspected: true,
  //     imageUrls: [AppImages.renaultKwid1],
  //   ),
  // ];
}
