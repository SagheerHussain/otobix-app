import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Utils/app_constants.dart';

class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();

  // single instance of ValueNotifier
  final selectedSegmentNotifier = ValueNotifier<String>('live');

  final segments = {'live': 'Live (23)', 'ocb70': 'OCB 70'}.obs;

  RxString selectedSegment = 'live'.obs;

  RxString selectedCity = 'All States'.obs;

  final List<String> cities = ['All States', ...AppConstants.indianStates];

  @override
  void onInit() {
    super.onInit();

    // Listen to changes in ValueNotifier
    selectedSegmentNotifier.addListener(() {
      selectedSegment.value = selectedSegmentNotifier.value;
    });
  }

  final List<CarModel> cars = [
    CarModel(
      imageUrl:
          'https://www.financialexpress.com/wp-content/uploads/2024/09/Tata-Nexon-CNG.jpg',
      name: 'Tata Nexon',
      price: 1200000,
      year: 2021,
      kmDriven: 15000,
      fuelType: 'Petrol',
      location: 'Mumbai',
      isInspected: true,
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/01/19/13/51/car-604019_1280.jpg',
      name: 'Maruti Suzuki Baleno',
      price: 850000,
      year: 2020,
      kmDriven: 22000,
      fuelType: 'Petrol',
      location: 'Delhi',
    ),
    CarModel(
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzrSIsq6KxwpSGmyHSxjxfcf8ziHI2F_8FLA&s',
      name: 'Hyundai Creta',
      price: 1600000,
      year: 2022,
      kmDriven: 8000,
      fuelType: 'Diesel',
      location: 'Bengaluru',
      isInspected: true,
    ),
    CarModel(
      imageUrl:
          'https://imgd.aeplcdn.com/664x374/n/cw/ec/159231/swift-right-front-three-quarter.jpeg?isig=0&q=80',
      name: 'Maruti Suzuki Swift',
      price: 700000,
      year: 2019,
      kmDriven: 30000,
      fuelType: 'Petrol',
      location: 'Pune',
      isInspected: true,
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/09/22/12/36/mahindra-thar-7471642_1280.jpg',
      name: 'Mahindra Thar',
      price: 1450000,
      year: 2021,
      kmDriven: 12000,
      fuelType: 'Diesel',
      location: 'Chandigarh',
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/01/05/11/53/tata-6916212_1280.jpg',
      name: 'Tata Harrier',
      price: 1750000,
      year: 2022,
      kmDriven: 5000,
      fuelType: 'Diesel',
      location: 'Hyderabad',
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/09/01/15/48/kia-seltos-5534908_1280.jpg',
      name: 'Kia Seltos',
      price: 1400000,
      year: 2020,
      kmDriven: 18000,
      fuelType: 'Petrol',
      location: 'Ahmedabad',
      isInspected: true,
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/02/11/19/56/honda-city-4840545_1280.jpg',
      name: 'Honda City',
      price: 1100000,
      year: 2019,
      kmDriven: 35000,
      fuelType: 'Petrol',
      location: 'Kolkata',
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/06/11/17/56/jeep-compass-3469428_1280.jpg',
      name: 'Jeep Compass',
      price: 1850000,
      year: 2021,
      kmDriven: 10000,
      fuelType: 'Diesel',
      location: 'Jaipur',
      isInspected: true,
    ),
    CarModel(
      imageUrl:
          'https://cdn.pixabay.com/photo/2019/09/04/09/53/renault-4449878_1280.jpg',
      name: 'Renault Kwid',
      price: 450000,
      year: 2018,
      kmDriven: 42000,
      fuelType: 'Petrol',
      location: 'Surat',
      isInspected: true,
    ),
  ];
}
