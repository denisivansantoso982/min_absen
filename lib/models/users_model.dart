import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:min_absen/models/data/users_data.dart';

class UsersModel extends ChangeNotifier {
  final List<UsersData> _theListOfUsers = <UsersData>[];

  UnmodifiableListView<UsersData> get theListOfUsers =>
      UnmodifiableListView(_theListOfUsers);

  void getAllUsers(UsersData user) {
    _theListOfUsers.add(user);
    notifyListeners();
  }

  void clearAllUsers() {
    _theListOfUsers.clear();
    notifyListeners();
  }
}
