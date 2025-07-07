import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpFormController extends GetxController {
  String? selectedState;
  String? selectedEntityType;

  final TextEditingController dealershipNameController =
      TextEditingController();
  final TextEditingController primaryContactPersonController =
      TextEditingController();
  final TextEditingController primaryMobileController = TextEditingController();
  final TextEditingController secondaryContactPersonController =
      TextEditingController();
  final TextEditingController secondaryMobileController =
      TextEditingController();

  List<TextEditingController> addressControllers = [];

  final List<String> entityTypes = [
    'Individual',
    'Proprietorship',
    'Partnership',
    'Private Limited Company',
    'Limited Company',
    'LLP (Limited Liability Partnership)',
  ];

  List<String> indianStates = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Delhi",
    "Jammu and Kashmir",
    "Ladakh",
    "Lakshadweep",
    "Puducherry",
  ];

  void addAddressField() {
    addressControllers.add(TextEditingController());
    update(); // Trigger UI update
  }

  void removeAddressField(int index) {
    addressControllers.removeAt(index);
    update(); // Trigger UI update
  }
}
