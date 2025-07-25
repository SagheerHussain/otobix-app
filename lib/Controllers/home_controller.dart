import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Widgets/toast_widget.dart';

import '../Network/api_service.dart';

class HomeController extends GetxController {
  List<CarModel> carsList = [];
  RxBool isLoading = false.obs;

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
  final RxList<CarModel> favorites = <CarModel>[].obs;

  final RxList<CarModel> marketplaceCars = <CarModel>[].obs;

  void changeFavoriteCars(CarModel car) {
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
  RxInt liveCarsCount = 23.obs;
  RxInt upcomingCarsCount = 8.obs;
  RxInt otoBuyCarsCount = 70.obs;
  RxInt marketplaceCarsCount = 5.obs;

  final selectedSegmentNotifier = ValueNotifier<String>('live');

  // final segments =
  //     {'live': 'Live (23)', 'ocb': 'OCB (10)', 'marketplace': 'Marketplace (5)'}.obs;

  RxString selectedSegment = 'live'.obs;

  RxString selectedCity = 'All States'.obs;

  final List<String> cities = ['All States', ...AppConstants.indianStates];

  @override
  void onInit() {
    super.onInit();
    fetchCarsList();
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

  final RxList<CarModel> filteredCars = <CarModel>[].obs;
  Future<void> fetchCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList;
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        carsList = List<CarModel>.from(
          (data as List).map(
            (car) => CarModel.fromJson(data: car, id: car['id']),
          ),
        );
        filteredCars.value = carsList;
        debugPrint('Cars List Fetched Successfully');
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

  final List<CarModel> carsList1 = [
    CarModel(
      imageUrl: AppImages.tataNexon1,
      name: 'Tata Nexon',
      price: 1200000,
      year: 2021,
      kmDriven: 15000,
      fuelType: 'Petrol',
      location: 'Mumbai',
      isInspected: true,
      imageUrls: [
        AppImages.tataNexon1,
        AppImages.tataNexon2,
        AppImages.tataNexon3,
      ],
    ),
    CarModel(
      imageUrl: AppImages.marutiSuzukiBaleno1,
      name: 'Maruti Suzuki Baleno',
      price: 850000,
      year: 2020,
      kmDriven: 22000,
      fuelType: 'Petrol',
      location: 'Delhi',
      imageUrls: [
        AppImages.marutiSuzukiBaleno1,
        AppImages.marutiSuzukiBaleno2,
        AppImages.marutiSuzukiBaleno3,
      ],
    ),
    CarModel(
      imageUrl: AppImages.hyundaiCreta1,
      name: 'Hyundai Creta',
      price: 1600000,
      year: 2022,
      kmDriven: 8000,
      fuelType: 'Diesel',
      location: 'Bengaluru',
      isInspected: true,
      imageUrls: [
        AppImages.hyundaiCreta1,
        AppImages.hyundaiCreta2,
        AppImages.hyundaiCreta3,
      ],
    ),
    CarModel(
      imageUrl: AppImages.marutiSuzukiSwift1,
      name: 'Maruti Suzuki Swift',
      price: 700000,
      year: 2019,
      kmDriven: 30000,
      fuelType: 'Petrol',
      location: 'Pune',
      isInspected: true,
      imageUrls: [AppImages.marutiSuzukiSwift1],
    ),
    CarModel(
      imageUrl: AppImages.mahindraThar1,
      name: 'Mahindra Thar',
      price: 1450000,
      year: 2021,
      kmDriven: 12000,
      fuelType: 'Diesel',
      location: 'Chandigarh',
      imageUrls: [
        AppImages.mahindraThar1,
        AppImages.mahindraThar2,
        AppImages.mahindraThar3,
      ],
    ),
    CarModel(
      imageUrl: AppImages.tataHarrier1,
      name: 'Tata Harrier',
      price: 1750000,
      year: 2022,
      kmDriven: 5000,
      fuelType: 'Diesel',
      location: 'Hyderabad',
      imageUrls: [AppImages.tataHarrier1],
    ),
    CarModel(
      imageUrl: AppImages.kiaSeltos1,
      name: 'Kia Seltos',
      price: 1400000,
      year: 2020,
      kmDriven: 18000,
      fuelType: 'Petrol',
      location: 'Ahmedabad',
      isInspected: true,
      imageUrls: [
        AppImages.kiaSeltos1,
        AppImages.kiaSeltos2,
        AppImages.kiaSeltos3,
      ],
    ),
    CarModel(
      imageUrl: AppImages.hondaCity1,
      name: 'Honda City',
      price: 1100000,
      year: 2019,
      kmDriven: 35000,
      fuelType: 'Petrol',
      location: 'Kolkata',
      imageUrls: [AppImages.hondaCity1],
    ),
    CarModel(
      imageUrl: AppImages.jeepCompass1,
      name: 'Jeep Compass',
      price: 1850000,
      year: 2021,
      kmDriven: 10000,
      fuelType: 'Diesel',
      location: 'Jaipur',
      isInspected: true,
      imageUrls: [AppImages.jeepCompass1],
    ),
    CarModel(
      imageUrl: AppImages.renaultKwid1,
      name: 'Renault Kwid',
      price: 450000,
      year: 2018,
      kmDriven: 42000,
      fuelType: 'Petrol',
      location: 'Surat',
      isInspected: true,
      imageUrls: [AppImages.renaultKwid1],
    ),
  ];
}
