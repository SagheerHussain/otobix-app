import 'package:otobix/Models/car_model.dart';

class WishlistCarsListModel {
  final String? id;
  final String imageUrl;
  final String make;
  final String model;
  final String variant;
  final double priceDiscovery;
  final DateTime? yearMonthOfManufacture;
  final int odometerReadingInKms;
  final String fuelType;
  final String inspectionLocation;
  final bool isInspected;
  final String roadTaxValidity;
  final DateTime? taxValidTill;
  final int ownerSerialNumber;

  WishlistCarsListModel({
    this.id,
    required this.imageUrl,
    required this.make,
    required this.model,
    required this.variant,
    required this.priceDiscovery,
    required this.yearMonthOfManufacture,
    required this.odometerReadingInKms,
    required this.fuelType,
    required this.inspectionLocation,
    required this.isInspected,
    required this.roadTaxValidity,
    required this.taxValidTill,
    required this.ownerSerialNumber,
  });

  // Factory constructor to create a Car from JSON map
  factory WishlistCarsListModel.fromJson({
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    return WishlistCarsListModel(
      id: documentId,
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
      fuelType: data['fuelType'] ?? '',
      inspectionLocation: data['inspectionLocation'],
      isInspected: data['isInspected'] ?? false,
      roadTaxValidity: data['roadTaxValidity'] ?? '',
      taxValidTill: parseMongoDbDate(data["taxValidTill"]),
      ownerSerialNumber:
          data['ownerSerialNumber'] is int
              ? data['ownerSerialNumber']
              : int.tryParse(data['ownerSerialNumber']?.toString() ?? ''),
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
      'fuelType': fuelType,
      'inspectionLocation': inspectionLocation,
      'isInspected': isInspected,
      'roadTaxValidity': roadTaxValidity,
      'taxValidTill': taxValidTill,
      'ownerSerialNumber': ownerSerialNumber,
    };
  }
}
