import 'package:flutter/material.dart';
import 'package:min_absen/screens/new_agenda_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'card_menu_widget.dart';

class AgendaCardWidget extends StatelessWidget {
  const AgendaCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardMenuWidget(
      startColour: ColourTemplate.negativeColour.withOpacity(.8),
      endColour: ColourTemplate.negativeColour,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Agenda",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Agenda Selanjutnya",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "18",
                        style: TextStyleTemplate.boldWhite(size: 24),
                      ),
                      Column(
                        children: [
                          Text(
                            "Feb",
                            style: TextStyleTemplate.mediumWhite(size: 14),
                          ),
                          Text(
                            "2022",
                            style: TextStyleTemplate.regularWhite(size: 14),
                          ),
                        ],
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
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: Text(
                        "Lihat Detail",
                        style: TextStyleTemplate.mediumNegative(size: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "08:00 - 17:00",
                  style: TextStyleTemplate.regularWhite(size: 12),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kerja Bakti",
                  style: TextStyleTemplate.regularWhite(size: 18),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  color: Colors.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(NewAgendaScreen.route),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: Text(
                        "Tambah Agenda",
                        style: TextStyleTemplate.mediumNegative(size: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
