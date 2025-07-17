class UserModel {
  final String id;
  final String userType;
  final String location;
  final String dealerName;
  final String dealerEmail;
  final String dealershipName;
  final String entityType;
  final String primaryContactPerson;
  final String primaryContactNumber;
  final String? secondaryContactPerson;
  final String? secondaryContactNumber;
  final List<String> addressList;
  final String? image;
  final String password;
  final String? contactNumber;
  final String approvalStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.userType,
    required this.location,
    required this.dealerName,
    required this.dealerEmail,
    required this.dealershipName,
    required this.entityType,
    required this.primaryContactPerson,
    required this.primaryContactNumber,
    this.secondaryContactPerson,
    this.secondaryContactNumber,
    required this.addressList,
    this.image,
    required this.password,
    this.contactNumber,
    required this.approvalStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      userType: json['userType'] ?? '',
      location: json['location'] ?? '',
      dealerName: json['dealerName'] ?? '',
      dealerEmail: json['dealerEmail'] ?? '',
      dealershipName: json['dealershipName'] ?? '',
      entityType: json['entityType'] ?? '',
      primaryContactPerson: json['primaryContactPerson'] ?? '',
      primaryContactNumber: json['primaryContactNumber'] ?? '',
      secondaryContactPerson: json['secondaryContactPerson'],
      secondaryContactNumber: json['secondaryContactNumber'],
      addressList: List<String>.from(json['addressList'] ?? []),
      image: json['image'],
      password: json['password'] ?? '',
      contactNumber: json['contactNumber'],
      approvalStatus: json['approvalStatus'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userType': userType,
      'location': location,
      'dealerName': dealerName,
      'dealerEmail': dealerEmail,
      'dealershipName': dealershipName,
      'entityType': entityType,
      'primaryContactPerson': primaryContactPerson,
      'primaryContactNumber': primaryContactNumber,
      'secondaryContactPerson': secondaryContactPerson,
      'secondaryContactNumber': secondaryContactNumber,
      'addressList': addressList,
      'image': image,
      'password': password,
      'contactNumber': contactNumber,
      'approvalStatus': approvalStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
