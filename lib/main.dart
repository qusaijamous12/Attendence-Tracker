import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app/views/app.dart';
import 'core/helper/shared_pref_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefHelper.init();
  runApp(const MyApp());
}


