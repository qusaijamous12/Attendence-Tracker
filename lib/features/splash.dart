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
      body: Center(child: Image.asset(AppImages.onBoardThree)),
    );
  }
}


// git log --oneline عشان تشوف تايخ كل ال commits على المشروع
//git status بجبلك كل التعديلات الي عملتها بس لسا انت ما عملت الها commit
//git add . (بضيف كل الاشياء الي تغيرت في المجلد الي انت فيه بس )
//git add -A (الاشمل بضيف كلشي تغير بالمشروع كامل)

//الفكرة الي بدنا نحكي عنها اليوم هي برانشز شغلنا القديم كان كله يكون على الماستر بس الاشي ها غلط
//لازم مثلا بدي اضيف اشي جديد اعمل برانش جديدة واشتغل عليها زبس ينعمل عليها تست وتكون تمام بنعمل اشي اسمه ميرج
//to create branch => git branch feature-1    => more quickly (git checkout -b feature-1 this will create a new brach and move to it)
//to get all branches in the app => git branch -a
//to move from branch to another branch => git checkout feature-1

//مثلا انت كنت شغال ع برانش معينة اذا رجعت ع البرانش الرئيسي رح يروح كل الاشياء الي عملتها على البرانش اذا ما عملت ميرج

// to delete a branch first we have to return to the main branch then we will write git branch  -d  feature-1
// هون باخر ملاحظة اذا جيبت اعمل حذف لبرانش وانا لسا مش عامل ميرج الموند هاد ما رح يشتغل ورح يقلك لازم تعمل ميرج اذا قررت تحذفه لازم تستعمل -D
///Merging branches
///1)First thing you must to switch to main branch.
///2)git merge (name of branch).
///Conflicts happen when for example User is work in main branch and make edit and another developer is working on feature c branch and make edit in main file when you want to make merge
///for feature -c conflict will happen to solve it you must checkout to master and make git add -A and them commit and them write wq and enter.