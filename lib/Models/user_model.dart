class UserModel {
  String? id;
  String dealerName;
  String dealerEmail;
  String dealershipName;
  String primaryContactPerson;
  String primaryMobile;
  String? secondaryContactPerson;
  String? secondaryMobile;
  String selectedState;
  String selectedEntityType;
  List<String>? addresses;

  UserModel({
    this.id,
    required this.dealerName,
    required this.dealerEmail,
    required this.dealershipName,
    required this.primaryContactPerson,
    required this.primaryMobile,
    this.secondaryContactPerson,
    this.secondaryMobile,
    required this.selectedState,
    required this.selectedEntityType,
    this.addresses,
  });

  factory UserModel.fromJson({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return UserModel(
      id: id,
      dealerName: data['dealerName'] as String,
      dealerEmail: data['dealerEmail'] as String,
      dealershipName: data['dealershipName'] as String,
      primaryContactPerson: data['primaryContactPerson'] as String,
      primaryMobile: data['primaryMobile'] as String,
      secondaryContactPerson: data['secondaryContactPerson'] as String,
      secondaryMobile: data['secondaryMobile'] as String,
      selectedState: data['selectedState'] as String,
      selectedEntityType: data['selectedEntityType'] as String,
      addresses:
          (data['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dealerName': dealerName,
      'dealerEmail': dealerEmail,
      'dealershipName': dealershipName,
      'primaryContactPerson': primaryContactPerson,
      'primaryMobile': primaryMobile,
      'secondaryContactPerson': secondaryContactPerson,
      'secondaryMobile': secondaryMobile,
      'selectedState': selectedState,
      'selectedEntityType': selectedEntityType,
      'addresses': addresses,
    };
  }
}
