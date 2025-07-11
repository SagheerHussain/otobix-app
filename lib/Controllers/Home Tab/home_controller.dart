import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/Home%20Tab/car_model.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_images.dart';
import 'package:otobix/Widgets/toast_widget.dart';

class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  // dummy add/remove cars to favorite
  final RxList<CarModel> favorites = <CarModel>[].obs;
  void changeFavoriteCars(CarModel car) {
    car.isFavorite.value = !car.isFavorite.value;

    if (car.isFavorite.value) {
      favorites.add(car);
      ToastWidget.show(
        context: Get.context!,
        message: 'Added to wishlist',
        type: ToastType.success,
      );
    } else {
      favorites.remove(car);
      ToastWidget.show(
        context: Get.context!,
        message: 'Removed from wishlist',
        type: ToastType.error,
      );
    }
  }

  // single instance of ValueNotifier
  RxInt liveCarsCount = 23.obs;

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

  final List<CarModel> cars = [
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

  // final List<CarModel> cars = [
  //   CarModel(
  //     imageUrl:
  //         'https://www.financialexpress.com/wp-content/uploads/2024/09/Tata-Nexon-CNG.jpg',
  //     name: 'Tata Nexon',
  //     price: 1200000,
  //     year: 2021,
  //     kmDriven: 15000,
  //     fuelType: 'Petrol',
  //     location: 'Mumbai',
  //     isInspected: true,
  //     imageUrls: [
  //       'https://www.financialexpress.com/wp-content/uploads/2024/09/Tata-Nexon-CNG.jpg',
  //       'https://stimg.cardekho.com/images/carexteriorimages/630x420/Tata/Nexon/9675/1751559838445/front-left-side-47.jpg',
  //       'https://img.autocarindia.com/ExtraImages/20240511115937_IMG_20240511_WA0003_01.jpeg',
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2015/01/19/13/51/car-604019_1280.jpg',
  //     name: 'Maruti Suzuki Baleno',
  //     price: 850000,
  //     year: 2020,
  //     kmDriven: 22000,
  //     fuelType: 'Petrol',
  //     location: 'Delhi',
  //     imageUrls: [
  //       'https://cdn.pixabay.com/photo/2015/01/19/13/51/car-604019_1280.jpg',
  //       'https://www.financialexpress.com/wp-content/uploads/2022/02/2022-Maruti-Suzuki-Baleno-Facelift-1-1.jpg',
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzrSIsq6KxwpSGmyHSxjxfcf8ziHI2F_8FLA&s',
  //     name: 'Hyundai Creta',
  //     price: 1600000,
  //     year: 2022,
  //     kmDriven: 8000,
  //     fuelType: 'Diesel',
  //     location: 'Bengaluru',
  //     isInspected: true,
  //     imageUrls: [
  //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzrSIsq6KxwpSGmyHSxjxfcf8ziHI2F_8FLA&s',
  //       'https://spn-sta.spinny.com/blog/20220228144639/Spinny-Assured-2021-Hyundai-Creta.jpg',
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://imgd.aeplcdn.com/664x374/n/cw/ec/159231/swift-right-front-three-quarter.jpeg?isig=0&q=80',
  //     name: 'Maruti Suzuki Swift',
  //     price: 700000,
  //     year: 2019,
  //     kmDriven: 30000,
  //     fuelType: 'Petrol',
  //     location: 'Pune',
  //     isInspected: true,
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvKMeQAUM9EKCh9MPoy9r3-BUVWd-9bS5l-w&s',
  //     name: 'Mahindra Thar',
  //     price: 1450000,
  //     year: 2021,
  //     kmDriven: 12000,
  //     fuelType: 'Diesel',
  //     location: 'Chandigarh',
  //     imageUrls: [
  //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvKMeQAUM9EKCh9MPoy9r3-BUVWd-9bS5l-w&s',
  //       'https://images.livemint.com/img/2020/10/02/1600x900/Thar_1601615282959_1601615288316.jpg',
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://imgd.aeplcdn.com/664x374/n/cw/ec/139139/harrier-exterior-right-front-three-quarter-6.jpeg?isig=0&q=80',
  //     name: 'Tata Harrier',
  //     price: 1750000,
  //     year: 2022,
  //     kmDriven: 5000,
  //     fuelType: 'Diesel',
  //     location: 'Hyderabad',
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Kia_Seltos_SP2_PE_Snow_White_Pearl_%286%29_%28cropped%29.jpg/960px-Kia_Seltos_SP2_PE_Snow_White_Pearl_%286%29_%28cropped%29.jpg',
  //     name: 'Kia Seltos',
  //     price: 1400000,
  //     year: 2020,
  //     kmDriven: 18000,
  //     fuelType: 'Petrol',
  //     location: 'Ahmedabad',
  //     isInspected: true,
  //     imageUrls: [
  //       'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Kia_Seltos_SP2_PE_Snow_White_Pearl_%286%29_%28cropped%29.jpg/960px-Kia_Seltos_SP2_PE_Snow_White_Pearl_%286%29_%28cropped%29.jpg',
  //       'https://motorsactu.com/wp-content/uploads/2019/06/cropped-Kia-Seltos-2020-1280-01.jpg',
  //     ],
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://global.honda/content/dam/site/global-en/newsroom-new/cq_img/news/2019/11/dl/c191125_001H.jpg',
  //     name: 'Honda City',
  //     price: 1100000,
  //     year: 2019,
  //     kmDriven: 35000,
  //     fuelType: 'Petrol',
  //     location: 'Kolkata',
  //   ),
  //   CarModel(
  //     imageUrl:
  //         'https://www.jeep.co.uk/content/dam/jeep/crossmarket/compass-my-25/mhev/06-defining-your-style/summit/figurines/JEEP-COMPASS-SUMMIT-MHEV-MY25-565x330-SOLID-BLACK-FIGURINE.png',
  //     name: 'Jeep Compass',
  //     price: 1850000,
  //     year: 2021,
  //     kmDriven: 10000,
  //     fuelType: 'Diesel',
  //     location: 'Jaipur',
  //     isInspected: true,
  //   ),
  //   CarModel(
  //     imageUrl: 'https://i.cdn.newsbytesapp.com/images/l7320220416122307.jpeg',
  //     name: 'Renault Kwid',
  //     price: 450000,
  //     year: 2018,
  //     kmDriven: 42000,
  //     fuelType: 'Petrol',
  //     location: 'Surat',
  //     isInspected: true,
  //   ),
  // ];
}
