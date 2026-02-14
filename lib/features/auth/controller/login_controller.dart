import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../home/controller/home_binding.dart';
import '../../home/views/doctor_dashboard.dart';
import '../../home/views/students_dashboard.dart';
import '../data/user_model.dart';
import '../views/login_view.dart';

enum RequestStatus {
  initial,
  loading,
  success,
  error,
}

class LoginController extends GetxController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseInstance = FirebaseFirestore.instance;

  final registerStatus = Rx<RequestStatus>(RequestStatus.initial);
  final loginStatus = Rx<RequestStatus>(RequestStatus.initial);


  final userModel=Rxn<UserModel>();


  @override
  void onInit() {
    handleLoggedInUser();
    super.onInit();
  }

  Future<void> login({
    required final String email,
    required final String password,
  }) async {
    loginStatus.value = RequestStatus.loading;

    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final doc = await _firebaseInstance
          .collection('users')
          .doc(result.user!.uid)
          .get();

      if (!doc.exists) {
        loginStatus.value = RequestStatus.error;
        Get.snackbar(
          'Error',
          'User data not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
        );
        return;
      }

      await getUserData(result.user!.uid);

      final role = doc['role'];

      if (role == 'student') {
        loginStatus.value = RequestStatus.success;
        Get.off(() => const StudentsDashboard(),binding: HomeBinding());
      }
      else if (role == 'doctor') {
        loginStatus.value = RequestStatus.success;
        Get.off(() => const DoctorDashboard(),binding: HomeBinding());
      }
      else {
        loginStatus.value = RequestStatus.error;
        Get.snackbar(
          'Error',
          'Unknown role',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      loginStatus.value = RequestStatus.error;
      var message = 'Login failed';
      if (e.code == 'user-not-found') message = 'No user found for this email';
      if (e.code == 'wrong-password') message = 'Incorrect password';
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
    } catch (e){
      loginStatus.value = RequestStatus.error;
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      print(e);
    }
  }

  Future<void> register({
    required final String email,
    required final String password,
    required final String fullName,
  }) async {
    registerStatus.value = RequestStatus.loading;

    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        await _firebaseInstance.collection('users').doc(result.user!.uid).set({
          'email': email,
          'fullName': fullName,
          'role': 'student',
          'uid':result.user!.uid
        });

        registerStatus.value = RequestStatus.success;

        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E3A8A),
          colorText: Colors.white,
        );

        Get.off(() => const LoginView());
      }
    } on FirebaseAuthException catch (e) {
      registerStatus.value = RequestStatus.error;
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') message = 'Email is already registered';
      if (e.code == 'weak-password') message = 'Password is too weak';
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
    } catch (e) {
      registerStatus.value = RequestStatus.error;
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      print(e);
    }
  }

  Future<void> getUserData(String uid) async {
    try {
      final doc = await _firebaseInstance.collection('users').doc(uid).get();

      if (!doc.exists) {
        Get.snackbar(
          'Error',
          'User data not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
        );
        return;
      }

      userModel.value = UserModel.fromJson(doc.data()!);
      await saveUserDataToSharedPref(userData: doc.data()!);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
      print(e);
    }
  }

  Future<void> saveUserDataToSharedPref({required final Map<String,dynamic> userData}) async {
    try{
      SharedPrefHelper.saveJson(value: userData, key: 'user_model');
      SharedPrefHelper.setBool(value: true, key: 'logged_in');
    } catch(error){
      print('Error When Save User Data To Shared Pref ${error.toString()}');
      SharedPrefHelper.setBool(value: false, key: 'logged_in');
      SharedPrefHelper.saveJson(value: {}, key: 'user_model');
    }
  }

  void handleLoggedInUser(){
    try{
      if(SharedPrefHelper.getJson(key: 'user_model')!=null){
        if(SharedPrefHelper.getJson(key: 'user_model')?.isNotEmpty??false)
          userModel(UserModel.fromJson(SharedPrefHelper.getJson(key: 'user_model')!));
      }

    }catch(error){
      print('Error When Handle Login ${error.toString()}');
    }
  }

  void logOut(){
    try{
      SharedPrefHelper.setBool(value: false, key: 'logged_in');
      SharedPrefHelper.saveJson(value: {}, key: 'user_model');
      Get.offAll(const LoginView());
    }catch(error){
      print('Error When Log Out ${error.toString()}');
    }
  }




}
