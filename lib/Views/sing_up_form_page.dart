import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/sign_up_form_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Widgets/button_widget.dart';

class SingUpFormPage extends StatelessWidget {
  SingUpFormPage({super.key});

  final SignUpFormController getxController = Get.put(SignUpFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Sign Up Form'),
        automaticallyImplyLeading: false,
        elevation: 4,
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLocationDropdown(),
            _buildCustomTextField(
              label: "Dealer Name",
              controller: getxController.dealerNameController,
              hintText: "e.g. Mukesh Kumar",
              keyboardType: TextInputType.text,
            ),
            _buildCustomTextField(
              label: "Dealer Email",
              controller: getxController.dealerEmailController,
              hintText: "e.g. mukeshkumar@gmail.com",
              keyboardType: TextInputType.emailAddress,
            ),
            _buildCustomTextField(
              label: "Dealership Name",
              controller: getxController.dealershipNameController,
              hintText: "e.g. Super Cars Pvt Ltd",
              keyboardType: TextInputType.text,
            ),
            _buildEntityTypeDropdown(),
            _buildCustomTextField(
              label: "Primary Contact Person",
              controller: getxController.primaryContactPersonController,
              hintText: "e.g. Rajesh Kumar",
              keyboardType: TextInputType.text,
            ),
            _buildCustomTextField(
              label: "Primary Contact Mobile No.",
              controller: getxController.primaryMobileController,
              hintText: "e.g. 9876543210",
              keyboardType: TextInputType.phone,
            ),
            _buildCustomTextField(
              label: "Secondary Contact Person (Optional)",
              controller: getxController.secondaryContactPersonController,
              hintText: "e.g. Pawan Singh",
              keyboardType: TextInputType.text,
            ),
            _buildCustomTextField(
              label: "Secondary Contact Mobile No. (Optional)",
              controller: getxController.secondaryMobileController,
              hintText: "e.g. 9123456789",
              keyboardType: TextInputType.phone,
            ),
            _buildAddressFields(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location (State)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
        // const SizedBox(height: 5),
        GetBuilder<SignUpFormController>(
          builder: (getxController) {
            return SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: getxController.selectedState,
                items:
                    getxController.indianStates
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  getxController.selectedState = val;
                },
                style: TextStyle(
                  color: AppColors.gray.withValues(alpha: .5),
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  // border: OutlineInputBorder(),
                  hintText: "Select State",
                  hintStyle: TextStyle(
                    color: AppColors.gray.withValues(alpha: .5),
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.gray.withValues(alpha: .5),
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildEntityTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Entity Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
        // const SizedBox(height: 5),
        GetBuilder<SignUpFormController>(
          builder: (getxController) {
            return SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: getxController.selectedEntityType,
                items:
                    getxController.entityTypes
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  getxController.selectedEntityType = val;
                },
                style: TextStyle(
                  color: AppColors.gray.withValues(alpha: .5),
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  // border: const OutlineInputBorder(),
                  hintText: "Select Entity Type",
                  hintStyle: TextStyle(
                    color: AppColors.gray.withValues(alpha: .5),
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildAddressFields() {
    return GetBuilder<SignUpFormController>(
      builder: (getxController) {
        return Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: const Text(
                "Addresses",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ),
            ),
            // const SizedBox(height: 5),
            ...getxController.addressControllers.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            // border: const OutlineInputBorder(),
                            hintText: "Enter Address ${entry.key + 1}",
                            hintStyle: TextStyle(
                              color: AppColors.gray.withValues(alpha: .5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
                        getxController.removeAddressField(entry.key);
                      },
                    ),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                getxController.addAddressField();
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Another Address",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() => ButtonWidget(
    text: 'Submit',
    isLoading: getxController.isLoading,
    onTap: () => getxController.dummySubmitForm(),
    height: 40,
    width: 150,
    backgroundColor: AppColors.green,
    textColor: AppColors.white,
    loaderSize: 15,
    loaderStrokeWidth: 1,
    loaderColor: AppColors.white,
  );

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
        // const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintStyle: TextStyle(
                color: AppColors.gray.withValues(alpha: .5),
                fontSize: 12,
              ),
              // border: const OutlineInputBorder(),
              hintText: hintText,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
