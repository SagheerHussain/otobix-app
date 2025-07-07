import 'package:get/get.dart';

class SignUpController extends GetxController {
  RxInt selectedRole = 1.obs;

  void setSelectedRole(int index) {
    selectedRole.value = index;
  }
}
