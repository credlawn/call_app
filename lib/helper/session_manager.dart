import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static SharedPreferences? _preferences;

  static const _isLogin = "isLogin";
  static const _isPunchedIn = "isPunchedIn";
  static const _userId = "id";
  static const _employeeId = "employee_id";
  static const _userName = "user_name";
  static const _userEmail = "email";
  static const _userPwd = "password";
  static const _token = "token";
  static const _mobile = "mobile";

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static dynamic setUserLoggedIn(bool isLogin){
    _preferences!.setBool(_isLogin, isLogin);
  }
  static dynamic isLoggedIn(){
    return _preferences!.getBool(_isLogin)?? false;
  }


  static dynamic setUserId(String userId){
    _preferences!.setString(_userId, userId);
  }
  static dynamic getUserId(){
    return _preferences!.getString(_userId);
  }

  static dynamic setEmployeeId(String empId){
    _preferences!.setString(_employeeId, empId);
  }

  static dynamic getEmployeeId(){
    _preferences!.getString(_employeeId);
  }

  static dynamic setUserName(String name){
    _preferences!.setString(_userName, name);
  }

  static dynamic getUserName(){
    return _preferences!.getString(_userName);
  }

  static dynamic setUserEmail(String email){
    _preferences!.setString(_userEmail, email);
  }

  static dynamic getUserEmail(){
    return _preferences!.getString(_userEmail);
  }

  static dynamic setCurrentPwd(String pwd){
    _preferences!.setString(_userPwd, pwd);
  }

  static dynamic getCurrentPwd(){
    return _preferences!.getString(_userPwd);
  }

  static dynamic setToken(String token){
    _preferences!.setString(_token, token);
  }
  static dynamic getToken(){
    return _preferences!.getString(_token);
  }
  static dynamic setMobile(String mobile){
    _preferences!.setString(_mobile, mobile);
  }
  static dynamic getMobile(){
    return _preferences!.getString(_mobile);
  }

  static dynamic setUserPunchedIn(bool isPunchedIn){
    _preferences!.setBool(_isPunchedIn, isPunchedIn);
  }

  static dynamic isPunchedIn(){
    return _preferences!.getBool(_isPunchedIn);
  }






  static dynamic logout(){
    _preferences!.remove(_isLogin);
    _preferences!.remove(_userId);
    _preferences!.remove(_userName);
    _preferences!.remove(_userEmail);
    _preferences!.remove(_userPwd);
    _preferences!.remove(_employeeId);
    _preferences!.remove(_mobile);
    _preferences!.remove(_isPunchedIn);
    _preferences!.remove(_token);
  }


}