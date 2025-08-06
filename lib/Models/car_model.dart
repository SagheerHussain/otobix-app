import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:otobix/Models/car_model2.dart';

class CarModel {
  RxString remainingAuctionTime = '00h : 00m : 00s'.obs;
  Timer? auctionTimer;

  ///
  final String id;
  final String imageUrl;
  final String make;
  final String model;
  final String variant;
  final double priceDiscovery;
  final DateTime? yearMonthOfManufacture;
  final int odometerReadingInKms;
  final int ownerSerialNumber;
  final String fuelType;
  final String commentsOnTransmission;
  final DateTime? taxValidTill;
  final String registrationNumber;
  final String registeredRto;
  final String inspectionLocation;
  final bool isInspected;
  final RxDouble highestBid;
  DateTime? auctionStartTime;
  int defaultAuctionTime;
  final List<CarsListTitleAndImage>? imageUrls;

  final RxBool isFavorite;

  CarModel({
    required this.id,
    required this.imageUrl,
    required this.make,
    required this.model,
    required this.variant,
    required this.priceDiscovery,
    required this.yearMonthOfManufacture,
    required this.odometerReadingInKms,
    required this.ownerSerialNumber,
    required this.fuelType,
    required this.commentsOnTransmission,
    required this.taxValidTill,
    required this.registrationNumber,
    required this.registeredRto,
    required this.inspectionLocation,
    required this.isInspected,
    required this.highestBid,
    required this.auctionStartTime,
    required this.defaultAuctionTime,
    required this.imageUrls,
    bool isFavorite = false,
  }) : isFavorite = isFavorite.obs;

  // Factory constructor to create a Car from JSON map
  factory CarModel.fromJson({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return CarModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      variant: data['variant'] ?? '',
      priceDiscovery:
          data['priceDiscovery'] is double
              ? data['priceDiscovery']
              : double.tryParse(data['priceDiscovery']?.toString() ?? '0') ??
                  0.0,
      yearMonthOfManufacture: parseMongoDbDate(data["yearMonthOfManufacture"]),
      odometerReadingInKms:
          data['odometerReadingInKms'] is int
              ? data['odometerReadingInKms']
              : int.tryParse(data['odometerReadingInKms']?.toString() ?? ''),
      ownerSerialNumber:
          data['ownerSerialNumber'] is int
              ? data['ownerSerialNumber']
              : int.tryParse(data['ownerSerialNumber']?.toString() ?? ''),
      fuelType: data['fuelType'] ?? '',
      commentsOnTransmission: data['commentsOnTransmission'] ?? '',
      taxValidTill: parseMongoDbDate(data["taxValidTill"]),
      registrationNumber: data['registrationNumber'],
      registeredRto: data['registeredRto'],
      inspectionLocation: data['inspectionLocation'],
      isInspected: data['isInspected'] ?? false,
      highestBid: RxDouble(
        double.tryParse(data['highestBid']?.toString() ?? '0') ?? 0.0,
      ),
      auctionStartTime: parseMongoDbDate(data["auctionStartTime"]),
      defaultAuctionTime: data['defaultAuctionTime'] ?? 0,
      imageUrls:
          (data['imageUrls'] as List<dynamic>?)
              ?.map((e) => CarsListTitleAndImage.fromJson(e))
              .toList(),
    );
  }

  // Convert Car object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'make': make,
      'model': model,
      'variant': variant,
      'priceDiscovery': priceDiscovery,
      'yearMonthOfManufacture': yearMonthOfManufacture,
      'odometerReadingInKms': odometerReadingInKms,
      'ownerSerialNumber': ownerSerialNumber,
      'fuelType': fuelType,
      'commentsOnTransmission': commentsOnTransmission,
      'taxValidTill': taxValidTill,
      'registrationNumber': registrationNumber,
      'registeredRto': registeredRto,
      'inspectionLocation': inspectionLocation,
      'isInspected': isInspected,
      'highestBid': highestBid,
      'auctionStartTime': auctionStartTime,
      'defaultAuctionTime': defaultAuctionTime,
      'imageUrls': imageUrls?.map((e) => e.toJson()).toList(),
    };
  }
}

class CarsListTitleAndImage {
  final String title;
  final String url;

  CarsListTitleAndImage({required this.title, required this.url});

  factory CarsListTitleAndImage.fromJson(Map<String, dynamic> json) {
    return CarsListTitleAndImage(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'url': url};
}
