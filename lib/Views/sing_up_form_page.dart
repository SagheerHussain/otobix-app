import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/sign_up_form_controller.dart';

class SingUpFormPage extends StatelessWidget {
  SingUpFormPage({super.key});

  final SignUpFormController getxController = Get.put(SignUpFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLocationField(),
            _buildDealershipNameField(),
            _buildEntityTypeField(),
            _buildPrimaryContactPersonField(),
            _buildPrimaryMobileField(),
            _buildSecondaryContactPersonField(),
            _buildSecondaryMobileField(),
            _buildAddressFields(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location (State)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        GetBuilder<SignUpFormController>(
          builder: (getxController) {
            return DropdownButtonFormField<String>(
              value: getxController.selectedState,
              items:
                  getxController.indianStates
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) {
                getxController.selectedState = val;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select State",
              ),
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDealershipNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dealership Name",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: getxController.dealershipNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "e.g. Super Cars Pvt Ltd",
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildEntityTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Entity Type",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        GetBuilder<SignUpFormController>(
          builder: (getxController) {
            return DropdownButtonFormField<String>(
              value: getxController.selectedEntityType,
              items:
                  getxController.entityTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) {
                getxController.selectedEntityType = val;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select Entity Type",
              ),
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPrimaryContactPersonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Primary Contact Person",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: getxController.primaryContactPersonController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "e.g. Rajesh Kumar",
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPrimaryMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Primary Contact Mobile No.",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: getxController.primaryMobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "e.g. 9876543210",
            prefixText: "+91 ",
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSecondaryContactPersonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Secondary Contact Person (Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: getxController.secondaryContactPersonController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "e.g. Pawan Singh",
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSecondaryMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Secondary Contact Mobile No. (Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: getxController.secondaryMobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "e.g. 9123456789",
            prefixText: "+91 ",
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildAddressFields() {
    return GetBuilder<SignUpFormController>(
      builder: (getxController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Addresses",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...getxController.addressControllers.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Enter Address ${entry.key + 1}",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
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
              label: const Text("Add Another Address"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // Here you can handle submit logic
        debugPrint("Selected State: ${getxController.selectedState}");
        debugPrint(
          "Dealership Name: ${getxController.dealershipNameController.text}",
        );
        debugPrint(
          "Selected Entity Type: ${getxController.selectedEntityType}",
        );
        debugPrint(
          "Primary Contact Person: ${getxController.primaryContactPersonController.text}",
        );
        debugPrint(
          "Primary Mobile: ${getxController.primaryMobileController.text}",
        );
        debugPrint(
          "Secondary Contact Person: ${getxController.secondaryContactPersonController.text}",
        );
        debugPrint(
          "Secondary Mobile: ${getxController.secondaryMobileController.text}",
        );
        debugPrint(
          "Addresses: ${getxController.addressControllers.map((e) => e.text).toList()}",
        );
        debugPrint("Form submitted!");
      },
      child: const Text("Submit"),
    );
  }
}
