import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:min_absen/firebase/auth.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/models/data/users_data.dart';
import 'package:min_absen/models/profile_model.dart';
import 'package:min_absen/screens/home_screen.dart';
import 'package:min_absen/screens/login_screen.dart';
import 'package:min_absen/templates/alert_dialog_template.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String route = '/splash_screen';

  void checkIsUserDataExist(BuildContext context) async {
    try {
      User? user = await getCurrentUserData();
      if (user != null) {
        final DataSnapshot? dataSnapshot =
            await checkUserByEmail(user.email);
        if (dataSnapshot != null) {
          Provider.of<ProfileModel>(context, listen: false)
              .fillProfile(UsersData(
            uid: dataSnapshot.children.first.key.toString(),
            name: dataSnapshot.children.first.child('name').value.toString(),
            birthDate: DateTime.fromMillisecondsSinceEpoch(int.parse(dataSnapshot.children.first.child('date_of_birth').value.toString())),
            sex: dataSnapshot.children.first.child('sex').value.toString(),
            quotes: dataSnapshot.children.first.child('quotes').value.toString(),
            email: dataSnapshot.children.first.child('email').value.toString(),
            role: dataSnapshot.children.first.child('level').value.toString(),
            isActive: dataSnapshot.children.first.child('is_active').value as bool,
          ));
        } else {
          user = null;
        }
      }
      Navigator.of(context).pushReplacementNamed(
          user != null ? HomeScreen.route : LoginScreen.route);
    } catch (error) {
      AlertDialogTemplate().showTheDialog(
        context: context,
        title: "Terjadi Kesalahan!",
        content: error.toString(),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "OK",
              style: TextStyleTemplate.mediumWhite(size: 16),
            ),
            color: ColourTemplate.primaryColour,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIsUserDataExist(context);
    return Container(
      alignment: Alignment.center,
      color: ColourTemplate.whiteColour,
      child: const Text(
        "MinAbsen",
        style: TextStyle(
          color: ColourTemplate.primaryColour,
          fontSize: 48,
          fontFamily: 'Ubuntu',
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
