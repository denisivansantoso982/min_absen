import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:min_absen/firebase/auth.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/models/data/users_data.dart';
import 'package:min_absen/models/profile_model.dart';
import 'package:min_absen/screens/home_screen.dart';
import 'package:min_absen/templates/alert_dialog_template.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = '/login_screen';

  void checkUser(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      GoogleSignInAccount? googleUser = await signInWithGoogle();
      if (googleUser != null) {
        final DataSnapshot? userOnDatabase =
            await checkUserByEmail(googleUser.email);
        if (userOnDatabase != null) {
          await authenticateEmail(googleUser);
          final dataUser = userOnDatabase.children.first.children.toSet();
          late String name, email, sex, level, quotes, uid;
          late DateTime birthDate;
          for (var element in dataUser) {
            uid = userOnDatabase.children.first.key ?? '';
            if (element.key == 'name') {
              name = element.value.toString();
            } else if (element.key == 'sex') {
              sex = element.value.toString();
            } else if (element.key == 'level') {
              level = element.value.toString();
            } else if (element.key == 'quotes') {
              quotes = element.value.toString();
            } else if (element.key == 'email') {
              email = element.value.toString();
            } else if (element.key == 'date_of_birth') {
              birthDate = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(element.value.toString()));
            }
          }
          Provider.of<ProfileModel>(context, listen: false).fillProfile(
            UsersData(
              uid: uid,
              name: name,
              birthDate: birthDate,
              sex: sex,
              quotes: quotes,
              email: email,
              role: level,
            ),
          );
          bool isStored = Provider.of<ProfileModel>(context, listen: false)
                      .theProfile!
                      .uid !=
                  ''
              ? true
              : false;
          Navigator.of(context).pop();
          if (isStored) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.route);
          }
        } else {
          Navigator.of(context).pop();
          signOut();
          throw Exception('Pengguna tidak ditemukan!');
        }
      }
    } on PlatformException catch (error) {
      print(error);
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
    return Scaffold(
      backgroundColor: ColourTemplate.whiteColour,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: ColourTemplate.primaryColour,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Loginnya Pakai Google Ya!!!",
                    style: TextStyle(
                      color: ColourTemplate.primaryColour,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => checkUser(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Image(
                              image: AssetImage(
                                  'assets/images/Google__G__Logo.png'),
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Login Dengan Google",
                              style: TextStyle(
                                color: ColourTemplate.grayColour,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
