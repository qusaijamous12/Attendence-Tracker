import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../helper/shared_pref_helper.dart';

class AppController extends GetxController{




  bool get isLoggedIn=>SharedPrefHelper.getBool(key: 'logged_in')??false;


}