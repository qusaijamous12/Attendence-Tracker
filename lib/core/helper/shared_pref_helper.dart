import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{

  static Future<SharedPreferences> get _instance async=>

      _sharedPreferences=await SharedPreferences.getInstance();

  static late SharedPreferences _sharedPreferences;

  static Future<void> init()async{
    _sharedPreferences=await _instance;
  }

  static Future<bool> setString({required String value,required String key})async{
    var x=await _instance;
    return x.setString(key, value);
  }

  static String? getString({required String key}){
    return _sharedPreferences.getString(key);
  }

  static Future<bool> setBool({required bool value,required String key})async{
    var x=await _instance;
    return x.setBool(key, value);
  }

  static bool? getBool({required String key}){
    return _sharedPreferences.getBool(key);
  }

  static Future<bool> saveJson({required Map<String,dynamic> value ,required String key})async{
    var x=await _instance;
    String jsonValue=jsonEncode(value);
    return x.setString(key, jsonValue);


  }

  static Map<String,dynamic>? getJson({required String key}){
    if(_sharedPreferences.getString(key)!=null){
      return jsonDecode(_sharedPreferences.getString(key)!)as Map<String,dynamic>;
    }else{
      return null;
    }

  }



  static void removeKey({required String key})async{
    await _sharedPreferences.remove(key);
  }

}