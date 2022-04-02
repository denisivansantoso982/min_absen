import 'package:flutter/material.dart';
import 'package:min_absen/models/present_model.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:min_absen/screens/list_absen_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:provider/provider.dart';
import 'card_menu_widget.dart';

class TodayCardWidget extends StatelessWidget {
  const TodayCardWidget({Key? key}) : super(key: key);

  Text countThePersentation(int usersPresent, int totalUsers) {
    double result = usersPresent / totalUsers * 100;
    return Text(
      result.toStringAsFixed(2),
      style:  TextStyleTemplate.boldWhite(size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardMenuWidget(
      startColour: ColourTemplate.primaryColour.withOpacity(.8),
      endColour: ColourTemplate.primaryColour,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hari Ini",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Jumlah Kehadiran",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        context
                            .watch<PresentModel>()
                            .theListOfPresentData
                            .length
                            .toString(),
                        style: TextStyleTemplate.boldWhite(size: 24),
                      ),
                      const Text(
                        "/",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w200),
                      ),
                      Text(
                        context
                            .watch<UsersModel>()
                            .theListOfUsers
                            .length
                            .toString(),
                        style: TextStyleTemplate.regularWhite(size: 14),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  color: Colors.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(ListAbsenScreen.route),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: Text(
                        "Lihat Detail",
                        style: TextStyleTemplate.regularPrimary(size: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  countThePersentation(
                    context.watch<PresentModel>().theListOfPresentData.length,
                    context.watch<UsersModel>().theListOfUsers.length,
                  ),
                  Text(
                    "%",
                    style: TextStyleTemplate.mediumWhite(size: 24),
                  )
                ],
              ),
              Container(),
            ],
          ),
        ],
      ),
    );
  }
}
