import 'package:flutter/foundation.dart';
import 'package:min_absen/models/data/users_data.dart';

class ProfileModel extends ChangeNotifier {
  UsersData? profileData;

  UsersData? get theProfile => profileData;

  void fillProfile(UsersData data) {
    profileData = data;
    notifyListeners();
  }

  void removeAllProfile() {
    profileData = null;
    notifyListeners();
  }
}
