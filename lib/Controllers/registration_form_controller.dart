import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/user_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Views/Login/login_page.dart';
import 'package:otobix/Views/Register/waiting_for_approval_page.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'dart:convert';

class RegistrationFormController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    clearFields();
    filteredStates = List.from(indianStates);

    // Ensure at least one address exists
    if (addressControllers.isEmpty) {
      addressControllers.add(TextEditingController());
    }

    // // Add listener for username change
    // dealerNameController.addListener(() {
    //   validateUsername();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    dealerNameController.dispose();
    dealerEmailController.dispose();
    dealershipNameController.dispose();
    primaryContactPersonController.dispose();
    primaryMobileController.dispose();
    secondaryContactPersonController.dispose();
    secondaryMobileController.dispose();
    passwordController.dispose();
    for (var controller in addressControllers) {
      controller.dispose();
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Track touched fields
  final Set<String> touchedFields = {};

  void markFieldTouched(String fieldKey) {
    touchedFields.add(fieldKey);
    update();
  }

  RxString usernameValidationError = ''.obs;

  RxBool isLoading = false.obs;
  String? selectedState;
  String? selectedEntityType;

  List<String> filteredStates = [];
  List<String> indianStates = AppConstants.indianStates;

  final RxBool obscurePassword = true.obs;

  final TextEditingController passwordController = TextEditingController();
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

  void filterStates(String query) {
    if (query.isEmpty) {
      filteredStates = List.from(indianStates);
    } else {
      filteredStates =
          indianStates
              .where(
                (state) => state.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    update();
  }

  void selectState(String state) {
    selectedState = state;
    update();
  }

  final List<String> entityTypes = [
    'Individual',
    'Proprietary',
    'HUF',
    'Partnership',
    'LLP',
    'Ltd/Private Limited',
    'One person Company',
  ];

  void addAddressField() {
    addressControllers.add(TextEditingController());
    update();
  }

  void removeAddressField(int index) {
    addressControllers.removeAt(index);
    update();
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

  Future<void> submitForm({
    required String userRole,
    required String contactNumber,
  }) async {
    try {
      // Trigger username check
      bool isUsernameValid = await validateUsername();

      // Validate form
      bool isFormValid = formKey.currentState!.validate();

      if (!isUsernameValid || !isFormValid) {
        // Show toast
        ToastWidget.show(
          context: Get.context!,
          message: "Please fill all required fields",
          type: ToastType.error,
        );

        // Mark all required fields as touched so errors show
        touchedFields.addAll([
          "State",
          "Dealer Name",
          "Dealer Email",
          "Dealership Name",
          "Entity Type",
          "Primary Contact Person",
          "Primary Contact Mobile No.",
          "Password",
        ]);

        update();
        return;
      }

      isLoading.value = true;

      final userModel = UserModel(
        userRole: userRole,
        location: selectedState ?? "",
        userName: dealerNameController.text,
        email: dealerEmailController.text,
        dealershipName: dealershipNameController.text,
        entityType: selectedEntityType ?? "",
        primaryContactPerson: primaryContactPersonController.text,
        primaryContactNumber: primaryMobileController.text,
        password: passwordController.text,
        phoneNumber: contactNumber,
        secondaryContactPerson:
            secondaryContactPersonController.text.isEmpty
                ? null
                : secondaryContactPersonController.text,
        secondaryContactNumber:
            secondaryMobileController.text.isEmpty
                ? null
                : secondaryMobileController.text,
        addressList: addressControllers.map((e) => e.text).toList(),
        id: '',
        approvalStatus: 'Pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      debugPrint("Sending payload → ${userModel.toJson()}");

      final response = await ApiService.post(
        endpoint: AppUrls.register,
        body: userModel.toJson(),
      );

      debugPrint("Status Code → ${response.statusCode}");
      debugPrint("Response → ${response.body}");

      if (response.statusCode == 201) {
        ToastWidget.show(
          context: Get.context!,
          message: "registered successfully!",
          type: ToastType.success,
        );
        Get.to(() => LoginPage());
      } else {
        ToastWidget.show(
          context: Get.context!,
          message: "Failed to register user",
          type: ToastType.error,
        );
      }
    } catch (e, stacktrace) {
      debugPrint("Error → $e");
      debugPrint("Stacktrace → $stacktrace");
      ToastWidget.show(
        context: Get.context!,
        message: e.toString(),
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> dummySubmitForm({required String userRole}) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.to(
        () => WaitingForApprovalPage(
          documents:
              entityDocuments[selectedEntityType ?? 'Individual'] ??
              entityDocuments['Individual']!,
          userRole: userRole,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> validateUsername() async {
    String userName = dealerNameController.text.trim();

    // ✅ Only if valid format, then check API for availability
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.checkUsernameExists(userName),
        body: {},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final bool isAvailable = data['available'] == true;

        if (isAvailable) {
          usernameValidationError.value = "Username is available ";
          return true;
        } else {
          usernameValidationError.value = "Username already exists";
          return false;
        }
      } else {
        usernameValidationError.value = "Error checking username";
        return false;
      }
    } catch (e) {
      debugPrint("Username validation error → $e");
      usernameValidationError.value = "Error checking username";
      return false;
    }
  }

  // Clear fields
  void clearFields() {
    dealerNameController.clear();
    dealerEmailController.clear();
    dealershipNameController.clear();
    primaryContactPersonController.clear();
    primaryMobileController.clear();
    secondaryContactPersonController.clear();
    secondaryMobileController.clear();
    passwordController.clear();

    obscurePassword.value = true;
    selectedEntityType = null;
    selectedState = null;

    addressControllers.clear();
    addressControllers.add(TextEditingController());

    // 🔁 Reset validation-related data
    formKey.currentState?.reset();
    usernameValidationError.value = '';
    touchedFields.clear();

    // 🔁 Reset state filtering if needed
    filteredStates = List.from(indianStates);

    update();
  }
}
