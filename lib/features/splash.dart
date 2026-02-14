import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app/controller/app_controller.dart';
import '../core/config/app_images.dart';
import 'auth/controller/login_controller.dart';
import 'home/controller/home_binding.dart';
import 'home/views/doctor_dashboard.dart';
import 'home/views/students_dashboard.dart';
import 'on_board/views/on_board_view.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _app=Get.find<AppController>(tag: 'app_controller');
  final _user=Get.find<LoginController>(tag: 'login_controller');

  Timer ?_timer;


  @override
  void initState() {
    _timer=Timer(const Duration(seconds: 3),_onFinish);
    super.initState();
  }

  void _onFinish(){
    if(_app.isLoggedIn){
      if(_user.userModel.value?.role=='student')
        Get.offAll(()=>const StudentsDashboard(),binding: HomeBinding());
      else
        Get.offAll(()=>const DoctorDashboard(),binding: HomeBinding());
    }
    else
      Get.offAll(const OnBoardView());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset(AppImages.appLogo)),
    );
  }
}
