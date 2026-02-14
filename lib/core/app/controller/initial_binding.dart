import 'package:get/get.dart';

import '../../../features/auth/controller/login_controller.dart';
import 'app_controller.dart';

class InitialBinding extends Bindings{


  @override
  void dependencies() {
    Get.put<AppController>(AppController(),tag: 'app_controller');
    Get.put<LoginController>(LoginController(),tag: 'login_controller');
  }

}