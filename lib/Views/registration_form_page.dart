import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/sign_up_form_controller.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_icons.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Widgets/dropdown_widget.dart';

class RegistrationFormPage extends StatelessWidget {
  RegistrationFormPage({super.key});

  final SignUpFormController getxController = Get.put(SignUpFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayWithOpacity1,
      // appBar: AppBar(
      //   title: const Text('Sign Up Form'),
      //   automaticallyImplyLeading: false,
      //   elevation: 4,
      //   centerTitle: true,
      //   backgroundColor: AppColors.white,
      // ),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    _buildLocationDropdown(),
                    _buildCustomTextField(
                      icon: Icons.person,
                      label: "Dealer Name",
                      controller: getxController.dealerNameController,
                      hintText: "e.g. Mukesh Kumar",
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    _buildCustomTextField(
                      icon: Icons.email,
                      label: "Dealer Email",
                      controller: getxController.dealerEmailController,
                      hintText: "e.g. mukeshkumar@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      isRequired: true,
                    ),
                    _buildCustomTextField(
                      icon: Icons.business,
                      label: "Dealership Name",
                      controller: getxController.dealershipNameController,
                      hintText: "e.g. Super Cars Pvt Ltd",
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    _buildEntityTypeDropdown(context),
                    _buildCustomTextField(
                      icon: Icons.person_outline,
                      label: "Primary Contact Person",
                      controller: getxController.primaryContactPersonController,
                      hintText: "e.g. Rajesh Kumar",
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    _buildCustomTextField(
                      icon: Icons.phone_android,
                      label: "Primary Contact Mobile No.",
                      controller: getxController.primaryMobileController,
                      hintText: "e.g. 9876543210",
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                    _buildCustomTextField(
                      icon: Icons.person_outline,
                      label: "Secondary Contact Person (Optional)",
                      controller:
                          getxController.secondaryContactPersonController,
                      hintText: "e.g. Pawan Singh",
                      keyboardType: TextInputType.text,
                    ),
                    _buildCustomTextField(
                      icon: Icons.phone_android,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return GetBuilder<SignUpFormController>(
      builder: (getxController) {
        return DropdownWidget(
          label: "Location (State)",
          isRequired: true,
          selectedValue: getxController.selectedState,
          hintText: "Select State",
          prefixIcon: Icons.location_on,
          items: getxController.indianStates,
          onChanged: (val) {
            getxController.selectedState = val;
            getxController.update();
          },
        );
      },
    );
  }

  Widget _buildEntityTypeDropdown(BuildContext context) {
    return GetBuilder<SignUpFormController>(
      builder: (getxController) {
        return DropdownWidget(
          label: "Entity Type",
          isRequired: true,
          selectedValue: getxController.selectedEntityType,
          hintText: "Select Entity Type",
          prefixIcon: Icons.category,
          items: getxController.entityTypes,
          // useCustomPicker: false,
          onChanged: (val) {
            getxController.selectedEntityType = val;
            getxController.update();
          },
        );
      },
    );
  }

  // void _showStatePicker(SignUpFormController getxController) {
  //   Get.dialog(
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       child: Container(
  //         constraints: BoxConstraints(
  //           maxHeight: 400,
  //           maxWidth: 300, // Controls how “narrow” your dropdown looks
  //         ),
  //         padding: const EdgeInsets.all(16),
  //         child: ListView.separated(
  //           shrinkWrap: true,
  //           itemCount: getxController.indianStates.length,
  //           separatorBuilder: (_, __) => Divider(height: 1),
  //           itemBuilder: (context, index) {
  //             final state = getxController.indianStates[index];
  //             return ListTile(
  //               title: Text(
  //                 state,
  //                 style: TextStyle(color: AppColors.black, fontSize: 14),
  //               ),
  //               onTap: () {
  //                 getxController.selectedState = state;
  //                 getxController.update();
  //                 Get.back();
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLocationDropdown2() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       RichText(
  //         text: TextSpan(
  //           text: 'Location (State)',
  //           style: TextStyle(
  //             color: AppColors.gray,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12,
  //           ),
  //           children: [
  //             TextSpan(
  //               text: ' *',
  //               style: TextStyle(
  //                 color: Colors.red.withOpacity(.5),
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 5),
  //       GetBuilder<SignUpFormController>(
  //         builder: (getxController) {
  //           return GestureDetector(
  //             onTap: () {
  //               _showStatePicker(getxController);
  //             },
  //             child: Container(
  //               height: 40,
  //               padding: const EdgeInsets.symmetric(horizontal: 10),
  //               decoration: BoxDecoration(
  //                 // borderRadius: BorderRadius.circular(8),
  //                 color: Colors.white,
  //                 border: Border(
  //                   bottom: BorderSide(color: AppColors.gray, width: 1.0),
  //                 ),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.location_on,
  //                     size: 15,
  //                     color: AppColors.gray.withOpacity(.5),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: Text(
  //                       getxController.selectedState ?? 'Select State',
  //                       style: TextStyle(
  //                         color:
  //                             getxController.selectedState == null
  //                                 ? AppColors.gray.withOpacity(.5)
  //                                 : AppColors.black,
  //                         fontSize: 12,
  //                       ),
  //                     ),
  //                   ),
  //                   const Icon(
  //                     Icons.arrow_drop_down,
  //                     color: AppColors.gray,
  //                     size: 20,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //       const SizedBox(height: 30),
  //     ],
  //   );
  // }

  // Widget _buildLocationDropdown1() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       RichText(
  //         text: TextSpan(
  //           text: 'Location (State)',
  //           style: TextStyle(
  //             color: AppColors.gray,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12,
  //           ),
  //           children: [
  //             TextSpan(
  //               text: ' *',
  //               style: TextStyle(
  //                 color: Colors.red.withValues(alpha: .5),
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),

  //       // const SizedBox(height: 5),
  //       GetBuilder<SignUpFormController>(
  //         builder: (getxController) {
  //           return SizedBox(
  //             height: 40,
  //             child: DropdownButtonFormField<String>(
  //               borderRadius: BorderRadius.circular(15),
  //               menuMaxHeight: 500,
  //               value: getxController.selectedState,
  //               items:
  //                   getxController.indianStates
  //                       .map(
  //                         (e) => DropdownMenuItem(
  //                           value: e,
  //                           child: Text(
  //                             e,
  //                             style: TextStyle(
  //                               color: AppColors.black,
  //                               fontSize: 12,
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                       .toList(),
  //               onChanged: (val) {
  //                 getxController.selectedState = val;
  //               },
  //               style: TextStyle(
  //                 color: AppColors.gray.withValues(alpha: .5),
  //                 fontSize: 12,
  //               ),
  //               decoration: InputDecoration(
  //                 prefixIcon: Icon(
  //                   Icons.location_on,
  //                   color: AppColors.gray.withValues(alpha: .5),
  //                   size: 15,
  //                 ),
  //                 prefixIconConstraints: BoxConstraints(
  //                   minWidth: 20,
  //                   minHeight: 20,
  //                 ),
  //                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
  //                 // border: OutlineInputBorder(),
  //                 hintText: "Select State",
  //                 hintStyle: TextStyle(
  //                   color: AppColors.gray.withValues(alpha: .5),
  //                   fontSize: 12,
  //                 ),
  //                 labelStyle: TextStyle(
  //                   color: AppColors.gray.withValues(alpha: .5),
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //       const SizedBox(height: 30),
  //     ],
  //   );
  // }

  // Widget _buildEntityTypeDropdown(BuildContext parentContext) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       RichText(
  //         text: TextSpan(
  //           text: 'Entity Type',
  //           style: TextStyle(
  //             color: AppColors.gray,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12,
  //           ),
  //           children: [
  //             TextSpan(
  //               text: ' *',
  //               style: TextStyle(
  //                 color: Colors.red.withValues(alpha: .5),
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),

  //       // const SizedBox(height: 5),
  //       GetBuilder<SignUpFormController>(
  //         builder: (getxController) {
  //           return SizedBox(
  //             height: 40,

  //             child: DropdownButtonFormField<String>(
  //               value: getxController.selectedEntityType,
  //               borderRadius: BorderRadius.circular(15),
  //               menuMaxHeight: 300,
  //               items:
  //                   getxController.entityTypes
  //                       .map(
  //                         (e) => DropdownMenuItem(
  //                           value: e,
  //                           child: Text(
  //                             e,
  //                             style: TextStyle(
  //                               color: AppColors.black,
  //                               fontSize: 12,
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                       .toList(),
  //               onChanged: (val) {
  //                 getxController.selectedEntityType = val;
  //               },

  //               style: TextStyle(
  //                 color: AppColors.gray.withValues(alpha: .5),
  //                 fontSize: 12,
  //               ),
  //               decoration: InputDecoration(
  //                 prefixIcon: Icon(
  //                   Icons.category,
  //                   color: AppColors.gray.withValues(alpha: .5),
  //                   size: 15,
  //                 ),
  //                 prefixIconConstraints: BoxConstraints(
  //                   minWidth: 20,
  //                   minHeight: 20,
  //                 ),
  //                 contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  //                 // border: const OutlineInputBorder(),
  //                 hintText: "Select Entity Type",
  //                 hintStyle: TextStyle(
  //                   color: AppColors.gray.withValues(alpha: .5),
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //       const SizedBox(height: 30),
  //     ],
  //   );
  // }

  Widget _buildAddressFields() {
    return GetBuilder<SignUpFormController>(
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
                          child: SizedBox(
                            height: 40,
                            child: TextField(
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
                        ),

                        // Show delete button only if not first field
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
    required IconData icon,
    bool isRequired = false,
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
                          color: Colors.red.withValues(alpha: .5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ]
                    : [],
          ),
        ),
        // const SizedBox(height: 5),
        TextField(
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
            // border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
