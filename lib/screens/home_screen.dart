import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/screens/profile_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:min_absen/widgets/employee_card_widget.dart';
import 'package:min_absen/widgets/schedule_card_widget.dart';
import 'package:min_absen/widgets/today_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/home_screen';
  static DateTime today = DateTime.now();

  _doGetUsers(context) {
    getAllUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    _doGetUsers(context);
    return Scaffold(
      backgroundColor: ColourTemplate.whiteColour,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBarWidget(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd').format(today),
                style: const TextStyle(
                  fontSize: 32,
                  color: ColourTemplate.grayColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMMM').format(today),
                    style: const TextStyle(
                      color: ColourTemplate.primaryColour,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy').format(today),
                    style: const TextStyle(
                      color: ColourTemplate.grayColour,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(ProfileScreen.route),
                    child: const SizedBox(
                      width: 45,
                      height: 45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                        child: Image(
                          image: AssetImage("assets/images/avatar.jpeg"),
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            // Absen Card
            TodayCardWidget(),
            // Employee Card
            EmployeeCardWidget(),
            // Schedule Card
            ScheduleCardWidget(),
          ],
        ),
      ),
    );
  }
}
