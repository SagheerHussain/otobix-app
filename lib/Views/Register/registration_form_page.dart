import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/registration_form_controller.dart';
import 'package:otobix/Models/user_model.dart';
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      _buildLocationDropdown(),
                      SizedBox(height: 20),
                      _buildCustomTextField(
                        icon: Icons.person,
                        label: "User Name / User ID",
                        // userRole == UserModel.dealer
                        //     ? "Dealer Name"
                        //     : userRole == UserModel.customer
                        //     ? "Customer Name"
                        //     : "Sales Manager Name",
                        controller: getxController.dealerNameController,
                        hintText: "e.g. Mukesh Kumar",
                        keyboardType: TextInputType.text,
                        isRequired: true,
                        isUserName: true,

                        onChanged: (val) {
                          getxController.validateUsername();
                        },
                      ),
                      _buildCustomTextField(
                        icon: Icons.email,
                        label: "Email",
                        controller: getxController.dealerEmailController,
                        hintText: "e.g. mukeshkumar@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
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
                          maxLengthTen: true,
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
                          maxLengthTen: true,
                        ),
                      _buildCustomTextField(
                        icon: Icons.lock,
                        label: "Password",
                        controller: getxController.passwordController,
                        hintText: "Enter Password",
                        keyboardType: TextInputType.visiblePassword,
                        isRequired: true,
                        isPassword: true,
                        obscureText: getxController.obscurePassword,
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
          height: 40,
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
                  hintStyle: TextStyle(
                    color: AppColors.grey.withValues(alpha: .5),
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppColors.grey.withValues(alpha: .5),
                    size: 15,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.grey,
                      size: 15,
                    ),
                    onPressed: () {
                      fieldFocusNode.requestFocus();
                    },
                  ),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey.withValues(alpha: .5),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.green, width: 1.5),
                  ),
                  // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                style: TextStyle(fontSize: 12),
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
                          title: Text(option, style: TextStyle(fontSize: 12)),
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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Entity Type is required';
            }
            return null;
          },
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
    bool isUserName = false,
    RxBool? obscureText,
    Function(String?)? validator,
    Function(String)? onChanged,
    bool maxLengthTen = false,
  }) {
    Widget buildField({required bool obscure}) {
      return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && obscureText != null ? obscure : false,
        maxLength: maxLengthTen ? 10 : null,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppColors.grey.withValues(alpha: .5),
            size: 15,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 20,
          ),
          suffixIcon:
              isPassword && obscureText != null
                  ? GestureDetector(
                    child: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.grey,
                      size: 15,
                    ),
                    onTap: () {
                      obscureText.value = !obscureText.value;
                    },
                  )
                  : null,
          suffixIconConstraints:
              isPassword && obscureText != null
                  ? const BoxConstraints(minWidth: 30, minHeight: 20)
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 10,
          ),
          hintStyle: TextStyle(
            color: AppColors.grey.withValues(alpha: .5),
            fontSize: 12,
          ),
          hintText: hintText,
        ),
        onChanged: onChanged,
        validator: (value) {
          if (isRequired &&
              !isUserName &&
              (value == null || value.trim().isEmpty)) {
            return 'This field is required';
          }
          if (validator != null) {
            return validator(value);
          }
          return null;
        },

        // validator:  (value) {
        //   if (isRequired && (value == null || value.trim().isEmpty)) {
        //     return 'This field is required';
        //   }
        //   return null;
        // },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.grey,
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

        isPassword && obscureText != null
            ? Obx(() => buildField(obscure: obscureText.value))
            : buildField(obscure: false),

        // show error manually
        isUserName
            ? Obx(() {
              final error = getxController.usernameValidationError.value;
              if (error.isEmpty) return SizedBox.shrink();

              final isAvailable = error.toLowerCase().contains('available');
              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 3),
                child: Row(
                  children: [
                    Text(
                      error,
                      style: TextStyle(
                        color: isAvailable ? AppColors.green : AppColors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    isAvailable
                        ? Icon(
                          Icons.check_circle,
                          color: AppColors.green,
                          size: 15,
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              );
            })
            : SizedBox.shrink(),

        const SizedBox(height: 30),
      ],
    );
  }

  // Widget _buildCustomTextField1({
  //   required String label,
  //   required TextEditingController controller,
  //   required String hintText,
  //   required TextInputType keyboardType,
  //   required IconData icon,
  //   bool isRequired = false,
  //   bool isPassword = false,
  //   RxBool? obscureText,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       RichText(
  //         text: TextSpan(
  //           text: label,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12,
  //             color: AppColors.grey,
  //           ),
  //           children:
  //               isRequired
  //                   ? [
  //                     TextSpan(
  //                       text: ' *',
  //                       style: TextStyle(
  //                         color: AppColors.red,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 12,
  //                       ),
  //                     ),
  //                   ]
  //                   : [],
  //         ),
  //       ),
  //       Obx(
  //         () => TextFormField(
  //           controller: controller,
  //           keyboardType: keyboardType,
  //           decoration: InputDecoration(
  //             prefixIcon: Icon(
  //               icon,
  //               color: AppColors.grey.withValues(alpha: .5),
  //               size: 15,
  //             ),
  //             prefixIconConstraints: BoxConstraints(
  //               minWidth: 30,
  //               minHeight: 20,
  //             ),
  //             suffixIcon:
  //                 isPassword
  //                     ? IconButton(
  //                       icon: Icon(
  //                         obscureText!.value
  //                             ? Icons.visibility_off
  //                             : Icons.visibility,
  //                         color: AppColors.grey.withValues(alpha: .5),
  //                         size: 15,
  //                       ),
  //                       onPressed: () {
  //                         obscureText.value = !obscureText.value;
  //                       },
  //                     )
  //                     : null,
  //             suffixIconConstraints:
  //                 isPassword
  //                     ? BoxConstraints(minWidth: 30, minHeight: 20)
  //                     : null,

  //             contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
  //             hintStyle: TextStyle(
  //               color: AppColors.grey.withValues(alpha: .5),
  //               fontSize: 12,
  //             ),
  //             hintText: hintText,
  //           ),
  //           obscureText: isPassword ? obscureText!.value : false,

  //           validator: (value) {
  //             if (isRequired && (value == null || value.trim().isEmpty)) {
  //               return 'This field is required';
  //             }
  //             return null;
  //           },
  //         ),
  //       ),
  //       const SizedBox(height: 30),
  //     ],
  //   );
  // }

  Widget _buildAddressFields() {
    return GetBuilder<RegistrationFormController>(
      builder: (getxController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Addresses',
              style: TextStyle(
                color: AppColors.grey,
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
                                color: AppColors.grey.withOpacity(.5),
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
                                color: AppColors.grey.withOpacity(.5),
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
