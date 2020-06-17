import 'package:faarun/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData{

  Future<bool> setUserData({String key,String data}) async{
    SharedPreferences _prefsUser = await SharedPreferences.getInstance();
    var _result  = await _prefsUser.setString(key, data);
    return _result;
  }

  Future<String> getUserData({String key}) async{
    SharedPreferences _prefsUser = await SharedPreferences.getInstance();
    var _result  = await _prefsUser.get(key);
    return _result;
  }

}