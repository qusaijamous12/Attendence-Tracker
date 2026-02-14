import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/splash.dart';
import '../../config/app_theme.dart';
import '../controller/initial_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      home: const Splash(),
    );
  }
}