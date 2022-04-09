import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/models/agenda_model.dart';
import 'package:min_absen/screens/list_agenda_screen.dart';
import 'package:min_absen/screens/new_agenda_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:provider/provider.dart';
import 'card_menu_widget.dart';

class AgendaCardWidget extends StatelessWidget {
  const AgendaCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardMenuWidget(
      startColour: ColourTemplate.negativeColour.withOpacity(.8),
      endColour: ColourTemplate.negativeColour,
      child: Consumer<AgendaModel>(
        builder: (context, agenda, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Agenda",
                  style: TextStyleTemplate.boldWhite(size: 20),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.38,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Agenda Selanjutnya",
                        style: TextStyleTemplate.mediumWhite(size: 16),
                      ),
                      const SizedBox(height: 4,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            agenda.theListOfAgenda.isNotEmpty
                              ? DateFormat('dd').format(agenda.theListOfAgenda[0].agendaStartAt)
                              : "Tidak Ada Agenda",
                            style: TextStyleTemplate.boldWhite(size: 28),
                          ),
                          const SizedBox(width: 4,),
                          Column(
                            children: [
                              Text(
                                agenda.theListOfAgenda.isNotEmpty
                                  ? DateFormat('MMMM').format(agenda.theListOfAgenda[0].agendaStartAt)
                                  : '',
                                style: TextStyleTemplate.mediumWhite(size: 14),
                              ),
                              Text(
                                agenda.theListOfAgenda.isNotEmpty
                                  ? DateFormat('yyyy').format(agenda.theListOfAgenda[0].agendaStartAt)
                                  : '',
                                style: TextStyleTemplate.regularWhite(size: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      onTap: () => Navigator.of(context).pushNamed(ListAgendaScreen.route),
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
                const SizedBox(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    agenda.theListOfAgenda.isNotEmpty
                      ? agenda.theListOfAgenda[0].agendaName
                      : 'Tidak Ada Agenda',
                    style: TextStyleTemplate.mediumWhite(size: 20),
                    textAlign: TextAlign.center,
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
      ),
    );
  }
}
