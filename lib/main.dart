import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:min_absen/models/present_model.dart';
import 'package:min_absen/models/profile_model.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:min_absen/screens/detail_employee_screen.dart';
import 'package:min_absen/screens/list_employee_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/firebase_options.dart';
import 'package:min_absen/screens/home_screen.dart';
import 'package:min_absen/screens/list_absen_screen.dart';
import 'package:min_absen/screens/login_screen.dart';
import 'package:min_absen/screens/new_employee_screen.dart';
import 'package:min_absen/screens/profile_screen.dart';
import 'package:min_absen/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // static bool isUserDataExist = false;

  // Stream<void> checkUserData() async* {
  //   isUserDataExist = await getCurrentUserData() != null ? true : false;
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersModel>(create: (context) => UsersModel()),
        ChangeNotifierProvider<ProfileModel>(create: (context) => ProfileModel()),
        ChangeNotifierProvider<PresentModel>(create: (context) => PresentModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MinAbsen',
        theme: ThemeData(
          primaryColor: ColourTemplate.primaryColour,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: ColourTemplate.primaryColour),
          fontFamily: 'Ubuntu',
        ),
        initialRoute: SplashScreen.route,
        routes: {
          SplashScreen.route: (context) => const SplashScreen(),
          LoginScreen.route: (context) => const LoginScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          ProfileScreen.route: (context) =>const ProfileScreen(),
          ListAbsenScreen.route: (context) => const ListAbsenScreen(),
          NewEmployeeScreen.route: (context) =>const NewEmployeeScreen(),
          ListEmployeeScreen.route: (context) => const ListEmployeeScreen(),
          DetailEmployeeScreen.route: (context) => const DetailEmployeeScreen(),
        },
      ),
    );
  }
}
