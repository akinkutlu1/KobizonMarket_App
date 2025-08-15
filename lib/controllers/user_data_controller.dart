import 'package:get/get.dart';

class UserDataController extends GetxController {
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  String password = '';

  void updateUserData({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.username = username;
    this.email = email;
    this.password = password;
  }

  void clearData() {
    firstName = '';
    lastName = '';
    username = '';
    email = '';
    password = '';
  }
}

class PhoneInputController extends GetxController {
  String phoneNumber = '';

  void updatePhoneNumber(String number) {
    phoneNumber = number;
  }
}

