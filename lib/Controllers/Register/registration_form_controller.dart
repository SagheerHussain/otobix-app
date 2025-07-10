import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/Login%20Register/user_model.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Views/Register/waiting_for_approval_page.dart';

class RegistrationFormController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Ensure at least one address exists
    if (addressControllers.isEmpty) {
      addressControllers.add(TextEditingController());
    }
  }

  RxBool isLoading = false.obs;
  String? selectedState;
  String? selectedEntityType;

  final TextEditingController dealerNameController = TextEditingController();
  final TextEditingController dealerEmailController = TextEditingController();
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
    'Proprietary',
    'HUF',
    'Partnership',
    'LLP',
    'Ltd/Private Limited',
    'One person Company',
  ];

  List<String> indianStates = AppConstants.indianStates;

  void addAddressField() {
    addressControllers.add(TextEditingController());
    update(); // Trigger UI update
  }

  void removeAddressField(int index) {
    addressControllers.removeAt(index);
    update(); // Trigger UI update
  }

  final Map<String, List<String>> entityDocuments = {
    'Individual': [
      'Pan Card (self attested)',
      'Adhar Card (self attested)',
      'GST (individual name, self attested)',
      'Cancelled Cheque',
    ],
    'Proprietary': [
      'Pan Card (self attested)',
      'Adhar Card (self attested)',
      'Trade license (sign & stamp)',
      'GST (sign & stamp)',
      'Cancelled Cheque',
    ],
    'Huf': [
      'Huf Deed (signed & stamped by Karta)',
      'Huf Pan (signed & stamped by Karta)',
      'Pan card of Karta (self attested)',
      'Adhar card of Karta (self attested)',
      'Huf Cancelled Cheque',
    ],
    'Partnership': [
      'Partnership Deed copy (signed & stamped by partner)',
      'Partnership pan card (signed & stamped by partner)',
      'Trade license (signed & stamped by partner)',
      'GST (signed & stamped by partner)',
      'KYC of partners (self attested)',
      'Cancelled cheque',
    ],
    'LLP': [
      'Partnership Deed copy (signed & stamped by partner)',
      'Partnership pan card (signed & stamped by partner)',
      'Trade license (signed & stamped by partner)',
      'GST (signed & stamped by partner)',
      'KYC of partners (self attested)',
      'Cancelled cheque',
    ],
    'Ltd/Private Limited': [
      'Company PAN card (Signed & stamped by authorised director)',
      'Company trade license (Signed & stamped by authorised director)',
      'Company GST (Signed & stamped by authorised director)',
      'Board resolution Original ( To be Signed & stamped by more than 50% director. In case of Ltd companies, Company secretary can sign the board resolution and authorised anyone in the organisation to sign)',
      'KYC of directors (self attested)',
      'List of Directors MCA - (Signed & stamped by authorised director)',
      'Cancelled Cheque',
    ],
    'One person Company': [
      'Company PAN card (Signed & stamped by sole director)',
      'Company trade license (Signed & stamped by sole director)',
      'Company GST (Signed & stamped by sole director)',
      'Board resolution Original (Signed & stamped by sole director)',
      'KYC of director (self attested)',
      'List of Directors MCA (Signed & stamped by sole director)',
      'Cancelled Cheque',
    ],
  };

  Future<void> submitForm() async {
    try {
      isLoading.value = true;
      final userModel = UserModel(
        selectedState: selectedState!,
        dealerName: dealerNameController.text,
        dealerEmail: dealerEmailController.text,
        dealershipName: dealershipNameController.text,
        selectedEntityType: selectedEntityType!,
        primaryContactPerson: primaryContactPersonController.text,
        primaryMobile: primaryMobileController.text,
        secondaryContactPerson: secondaryContactPersonController.text,
        secondaryMobile: secondaryMobileController.text,
        addresses: addressControllers.map((e) => e.text).toList(),
      );

      debugPrint(userModel.toJson().toString());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> dummySubmitForm() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.to(
        () => WaitingForApprovalPage(
          documents:
              entityDocuments[selectedEntityType ?? 'Individual'] ??
              entityDocuments['Individual']!,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
