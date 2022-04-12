import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/models/profile_model.dart';
import 'package:min_absen/screens/profile_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:min_absen/widgets/employee_card_widget.dart';
import 'package:min_absen/widgets/agenda_card_widget.dart';
import 'package:min_absen/widgets/today_card_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/home_screen';
  static DateTime today = DateTime.now().toLocal();

  _doGetUsers(BuildContext context) async {
    try {
      await getAllUsers(context);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Terjadi Kesalahan!",
            style: TextStyleTemplate.boldGray(size: 18),
          ),
          content: Text(
            error.toString(),
            style: TextStyleTemplate.regularGray(size: 14),
          ),
          actions: [
            MaterialButton(
              color: ColourTemplate.primaryColour,
              child: Text(
                "OKE",
                style: TextStyleTemplate.mediumWhite(size: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  _doGetPresent(BuildContext context) async {
    try {
      await getAllPresentData(context, null);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Terjadi Kesalahan!",
            style: TextStyleTemplate.boldGray(size: 18),
          ),
          content: Text(
            error.toString(),
            style: TextStyleTemplate.regularGray(size: 14),
          ),
          actions: [
            MaterialButton(
              color: ColourTemplate.primaryColour,
              child: Text(
                "OKE",
                style: TextStyleTemplate.mediumWhite(size: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  _doGetAgenda(BuildContext context) async {
    try {
      await getTheAgenda(context, null);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Terjadi Kesalahan!",
            style: TextStyleTemplate.boldGray(size: 18),
          ),
          content: Text(
            error.toString(),
            style: TextStyleTemplate.regularGray(size: 14),
          ),
          actions: [
            MaterialButton(
              color: ColourTemplate.primaryColour,
              child: Text(
                "OKE",
                style: TextStyleTemplate.mediumWhite(size: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _doGetUsers(context);
    _doGetPresent(context);
    _doGetAgenda(context);
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
                style: TextStyleTemplate.boldGray(size: 32),
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
                    style: TextStyleTemplate.mediumPrimary(size: 18),
                  ),
                  Text(
                    DateFormat('yyyy').format(today),
                    style: TextStyleTemplate.mediumGray(size: 18),
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
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(48)),
                        child: Container(
                          color: ColourTemplate.primaryColour,
                          alignment: Alignment.center,
                          child: Text(
                            context.watch<ProfileModel>().theProfile != null
                              ? context.watch<ProfileModel>().theProfile!.name[0]
                              : '',
                            style: TextStyleTemplate.boldWhite(size: 24),
                          ),
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
            // Agenda Card
            AgendaCardWidget(),
          ],
        ),
      ),
    );
  }
}
