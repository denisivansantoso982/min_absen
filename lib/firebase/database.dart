import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:min_absen/models/data/present_data.dart';
import 'package:min_absen/models/data/users_data.dart';
import 'package:min_absen/models/present_model.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:provider/provider.dart';

DatabaseReference usersReference = FirebaseDatabase.instance.ref('users');
DatabaseReference presentReference = FirebaseDatabase.instance.ref('present');

Future<DataSnapshot?> checkUserByEmail(String? email) async {
  final DataSnapshot dataSnapshot =
      await usersReference.orderByChild('email').equalTo(email).get();
  if (dataSnapshot.children.first.child('level').value.toString() != 'Admin' ||
      !dataSnapshot.exists) {
    return null;
  }
  return dataSnapshot;
}

Future<void> getAllUsers(BuildContext context) async {
  try {
    usersReference.onValue.listen((event) {
      Provider.of<UsersModel>(context, listen: false).clearAllUsers();
      List<DataSnapshot> data = event.snapshot.children.toList();
      for (var element in data) {
        Provider.of<UsersModel>(context, listen: false).getAllUsers(
          UsersData(
            uid: element.key.toString(),
            name: element.child('name').value.toString(),
            birthDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse(element.child('date_of_birth').value.toString())),
            sex: element.child('sex').value.toString(),
            quotes: element.child('quotes').value.toString(),
            email: element.child('email').value.toString(),
            role: element.child('level').value.toString(),
          ),
        );
      }
    });
  } catch (error) {
    Future.error(error);
  }
}

Future<void> doAddUsers(Map<String, dynamic> user) async {
  return await usersReference.push().set(user);
}

Future<void> doUpdateUser(UsersData user) async {
  usersReference.child(user.uid).set(<String, dynamic>{
    'name': user.name,
    'date_of_birth': user.birthDate.millisecondsSinceEpoch,
    'sex': user.sex,
    'email': user.email,
    'level': user.role,
    'quotes': user.quotes,
  }).catchError((error) => Future.error(error));
}

Future<void> getAllPresentData(BuildContext context) async {
  try {
    presentReference.onValue.listen((event) {
      Provider.of<PresentModel>(context, listen: false).clearAllPresentData();
      List<DataSnapshot> data = event.snapshot.children.toList();
      for (var element in data) {
        Provider.of<PresentModel>(context).getAllPresentData(
          PresentData(
            uid: element.key.toString(),
            users: element.child('users').toString(),
            presentTime: int.parse(element.child('present_time').toString()),
            homeTime: int.parse(element.child('home_time').toString()),
          )
        );
      }
    });
  } catch (error) {
    Future.error(error);
  }
}
