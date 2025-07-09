class CarModel {
  String? id;
  final String imageUrl;
  final String name;
  final double price;
  final int year;
  final int kmDriven;
  final String fuelType;
  final String location;
  final bool isInspected;

  CarModel({
    this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.year,
    required this.kmDriven,
    required this.fuelType,
    required this.location,
    this.isInspected = false,
  });

  // Factory constructor to create a Car from JSON map
  factory CarModel.fromJson({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return CarModel(
      id: id,
      imageUrl: data['imageUrl'] as String,
      name: data['name'] as String,
      price: data['price'] as double,
      year: data['year'] as int,
      kmDriven: data['kmDriven'] as int,
      fuelType: data['fuelType'] as String,
      location: data['location'] as String,
      isInspected: data['isInspected'] as bool? ?? false,
    );
  }

  // Convert Car object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'year': year,
      'kmDriven': kmDriven,
      'fuelType': fuelType,
      'location': location,
      'isInspected': isInspected,
    };
  }
}
