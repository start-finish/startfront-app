import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  final String authDataKey = 'authDataXYZ';
  final String accessTokenKey = 'accessTokenXYZ';
  final String rsaPublicKey = 'rsaPublicKeyXYZ';
  final String userNameKey = 'userNameKeyXYZ';
  final String firstNameKey = 'firstNameKeyXYZ';
  final String lastNameKey = 'lastNameKeyXYZ';
  final String unitIdKey = 'unitIdKeyXYZ';
  final String roleIdKey = 'roleIdKeyXYZ';
  final String appListKey = 'appListKeyXYZ';
  final String roleListKey = 'roleListKeyXYZ';
  final String employeeIdKey = 'employeeIdKeyXYZ';
  final String nationKey = 'nationKeyXYZ';
  final String phoneKey = 'phoneKeyXYZ';
  final String positionKey = 'positionKeyXYZ';
  final String emailKey = 'emailKeyXYZ';
  final String dobKey = 'dobKeyXYZ';
  final String unitNameKey = 'unitNameKeyXYZ';
  final String branchKey = 'branchKeyXYZ';

  List<dynamic> appListJson = [];

  Future<String?> getRSAPublicKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(rsaPublicKey);
    return dataString;
  }

  Future<void> setRSAPublicKey(String publicKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(rsaPublicKey, publicKey);
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString(firstNameKey) ?? '';
    final lastName = prefs.getString(lastNameKey) ?? '';
    final unitId = prefs.getString(unitIdKey) ?? '';
    final roleId = prefs.getString(roleIdKey) ?? '';
    final token = prefs.getString(accessTokenKey) ?? '';
    final employeeId = prefs.getString(employeeIdKey) ?? '';
    final nation = prefs.getString(nationKey) ?? '';
    final phone = prefs.getString(phoneKey) ?? '';
    final position = prefs.getString(positionKey) ?? '';
    final email = prefs.getString(emailKey) ?? '';
    final dob = prefs.getString(dobKey) ?? '';
    final unitName = prefs.getString(unitNameKey) ?? '';
    final branch = prefs.getString(branchKey) ?? '';

    return {
      'firstName': firstName,
      'lastName': lastName,
      'unitId': unitId,
      'roleId': roleId,
      'accessToken': token,
      'employeeId': employeeId,
      'nation': nation,
      'phone': phone,
      'position': position,
      'email': email,
      'dob': dob,
      'unitName': unitName,
      'branch': branch,
    };
  }

  Future<void> setAuthData(data, String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(firstNameKey, data.userInfo!.firstName.toString());
    await prefs.setString(lastNameKey, data.userInfo!.lastName.toString());
    await prefs.setString(roleIdKey, data.userInfo!.position.toString());
    await prefs.setString(positionKey, data.userInfo!.position.toString());
    await prefs.setString(unitIdKey, data.userInfo!.unit.toString());
    await prefs.setString(employeeIdKey, data.userInfo!.employeeId.toString());
    await prefs.setString(nationKey, data.userInfo!.nationality.toString());
    await prefs.setString(phoneKey, data.userInfo!.telephoneNumber.toString());
    await prefs.setString(emailKey, data.userInfo!.email.toString());
    await prefs.setString(dobKey, data.userInfo!.birthday.toString());
    await prefs.setString(branchKey, data.userInfo!.branchName.toString());
    await prefs.setString(unitNameKey, data.userInfo!.unitName.toString());

    await prefs.setString(accessTokenKey, data.tokenJWT.toString());
    await prefs.setString(rsaPublicKey, data.publicKey.toString());
    await prefs.setString(appListKey, json.encode(data.applications));
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(accessTokenKey);
    await prefs.remove(rsaPublicKey);
    await prefs.remove(appListKey);

    await prefs.remove(userNameKey);
    await prefs.remove(firstNameKey);
    await prefs.remove(lastNameKey);
    await prefs.remove(employeeIdKey);
    await prefs.remove(roleIdKey);
    await prefs.remove(unitIdKey);
    await prefs.remove(nationKey);
    await prefs.remove(phoneKey);
    await prefs.remove(authDataKey);
    await prefs.remove(appListKey);
    await prefs.remove(emailKey);
    await prefs.remove(dobKey);
    await prefs.remove(unitNameKey);
    await prefs.remove(positionKey);
    await prefs.remove(branchKey);
    await prefs.remove('roleList');
  }
}
