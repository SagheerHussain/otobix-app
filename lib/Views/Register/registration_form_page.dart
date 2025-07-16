import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/Register/registration_form_controller.dart';
import 'package:otobix/Models/Login%20Register/user_model.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_icons.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/dropdown_widget.dart';

class RegistrationFormPage extends StatelessWidget {
  final String userRole;
  final String phoneNumber;
  RegistrationFormPage({
    super.key,
    required this.userRole,
    required this.phoneNumber,
  });

  final RegistrationFormController getxController = Get.put(
    RegistrationFormController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayWithOpacity1,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grayWithOpacity1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(-20),
                topRight: Radius.circular(-20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Registration Form",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: getxController.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      _buildLocationDropdown(),
                      SizedBox(height: 20),
                      _buildCustomTextField(
                        icon: Icons.person,
                        label:
                            userRole == UserModel.dealer
                                ? "Dealer Name"
                                : userRole == UserModel.customer
                                ? "Customer Name"
                                : "Sales Manager Name",
                        controller: getxController.dealerNameController,
                        hintText: "e.g. Mukesh Kumar",
                        keyboardType: TextInputType.text,
                        isRequired: true,
                      ),
                      _buildCustomTextField(
                        icon: Icons.email,
                        label: "Email",
                        controller: getxController.dealerEmailController,
                        hintText: "e.g. mukeshkumar@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                      ),
                      if (userRole == UserModel.dealer)
                        _buildCustomTextField(
                          icon: Icons.business,
                          label: "Dealership Name",
                          controller: getxController.dealershipNameController,
                          hintText: "e.g. Super Cars Pvt Ltd",
                          keyboardType: TextInputType.text,
                          isRequired: true,
                        ),
                      if (userRole == UserModel.dealer)
                        _buildEntityTypeDropdown(context),

                      if (userRole == UserModel.dealer)
                        _buildCustomTextField(
                          icon: Icons.person_outline,
                          label: "Primary Contact Person",
                          controller:
                              getxController.primaryContactPersonController,
                          hintText: "e.g. Rajesh Kumar",
                          keyboardType: TextInputType.text,
                          isRequired: true,
                        ),
                      if (userRole == UserModel.dealer)
                        _buildCustomTextField(
                          icon: Icons.phone_android,
                          label: "Primary Contact Mobile No.",
                          controller: getxController.primaryMobileController,
                          hintText: "e.g. 9876543210",
                          keyboardType: TextInputType.phone,
                          isRequired: true,
                        ),
                      if (userRole == UserModel.dealer)
                        _buildCustomTextField(
                          icon: Icons.person_outline,
                          label: "Secondary Contact Person (Optional)",
                          controller:
                              getxController.secondaryContactPersonController,
                          hintText: "e.g. Pawan Singh",
                          keyboardType: TextInputType.text,
                          isRequired: false,
                        ),
                      if (userRole == UserModel.dealer)
                        _buildCustomTextField(
                          icon: Icons.phone_android,
                          label: "Secondary Contact Mobile No. (Optional)",
                          controller: getxController.secondaryMobileController,
                          hintText: "e.g. 9123456789",
                          keyboardType: TextInputType.phone,
                          isRequired: false,
                        ),
                      _buildCustomTextField(
                        icon: Icons.lock,
                        label: "Password",
                        controller: getxController.passwordController,
                        hintText: "Enter Password",
                        keyboardType: TextInputType.visiblePassword,
                        isRequired: true,
                        isPassword: true,
                        obscureTextController: getxController.obscurePassword,
                      ),
                      _buildAddressFields(),
                      const SizedBox(height: 20),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return GetBuilder<RegistrationFormController>(
      builder: (getxController) {
        final TextEditingController textController = TextEditingController(
          text: getxController.selectedState,
        );

        return SizedBox(
          height: 30,
          child: RawAutocomplete<String>(
            textEditingController: textController,
            focusNode: FocusNode(),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return getxController.indianStates;
              } else {
                return getxController.indianStates.where(
                  (state) => state.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              }
            },
            displayStringForOption: (String option) => option,
            onSelected: (String selection) {
              getxController.selectedState = selection;
              getxController.update();
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextFormField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  hintText: "Select State",
                  hintStyle: TextStyle(color: AppColors.gray, fontSize: 10),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppColors.gray,
                    size: 15,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.gray,
                      size: 15,
                    ),
                    onPressed: () {
                      fieldFocusNode.requestFocus();
                    },
                  ),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                ),
                style: TextStyle(color: AppColors.gray, fontSize: 10),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'State is required';
                  }
                  return null;
                },
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options,
            ) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          title: Text(option),
                          onTap: () {
                            onSelected(option);
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEntityTypeDropdown(BuildContext context) {
    return GetBuilder<RegistrationFormController>(
      builder: (getxController) {
        return DropdownWidget(
          label: "Entity Type",
          isRequired: true,
          selectedValue: getxController.selectedEntityType,
          hintText: "Select Entity Type",
          prefixIcon: Icons.category,
          items: getxController.entityTypes,
          onChanged: (val) {
            getxController.selectedEntityType = val;
            getxController.update();
          },
          validator: (value) {},
        );
      },
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData icon,
    bool isRequired = false,
    bool isPassword = false,
    RxBool? obscureTextController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.gray,
            ),
            children:
                isRequired
                    ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ]
                    : [],
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: AppColors.gray.withValues(alpha: .5),
              size: 15,
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 20),
            contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            hintStyle: TextStyle(
              color: AppColors.gray.withValues(alpha: .5),
              fontSize: 12,
            ),
            hintText: hintText,
          ),
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildAddressFields() {
    return GetBuilder<RegistrationFormController>(
      builder: (getxController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Addresses',
              style: TextStyle(
                color: AppColors.gray,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            ...getxController.addressControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_city,
                                color: AppColors.gray.withOpacity(.5),
                                size: 15,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              hintText: "Enter Address ${index + 1}",
                              hintStyle: TextStyle(
                                color: AppColors.gray.withOpacity(.5),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        if (index != 0) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                AppIcons.deleteIcon,
                                width: 25,
                                height: 25,
                              ),
                            ),
                            onTap: () {
                              getxController.removeAddressField(index);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    getxController.addAddressField();
                  },
                  icon: const Icon(Icons.add_circle, color: AppColors.green),
                  label: const Text(
                    "Add Another Address",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() => ButtonWidget(
    text: 'Submit',
    isLoading: getxController.isLoading,
    onTap:
        () => getxController.submitForm(
          userRole: userRole,
          contactNumber: phoneNumber,
        ),
    height: 40,
    width: 150,
    backgroundColor: AppColors.green,
    textColor: AppColors.white,
    loaderSize: 15,
    loaderStrokeWidth: 1,
    loaderColor: AppColors.white,
  );
}
