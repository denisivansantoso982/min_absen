import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/models/agenda_model.dart';
import 'package:min_absen/screens/detail_agenda_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class ListAgendaScreen extends StatelessWidget {
  const ListAgendaScreen({Key? key}) : super(key: key);
  static const String route = '/list_agenda_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBarWidget(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.chevron_left,
                    color: ColourTemplate.primaryColour,
                    size: 32,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Daftar",
                      style: TextStyleTemplate.boldGray(size: 28),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Agenda",
                      style: TextStyleTemplate.boldPrimary(size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
        child: Consumer<AgendaModel>(
          builder: (context, agenda, child) => ListView.builder(
            itemCount: agenda.theListOfAgenda.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 12,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat('dd').format(agenda.theListOfAgenda[index].agendaStartAt),
                            style: TextStyleTemplate.boldPrimary(size: 20),
                          ),
                          Column(
                            children: [
                              Text(
                                DateFormat('MMMM').format(agenda.theListOfAgenda[index].agendaStartAt),
                                style: TextStyleTemplate.regularPrimary(size: 12),
                              ),
                              Text(
                                DateFormat('yyyy').format(agenda.theListOfAgenda[index].agendaStartAt),
                                style: TextStyleTemplate.regularPrimary(size: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        '${DateFormat('HH').format(agenda.theListOfAgenda[index].agendaStartAt)} : ${DateFormat('mm').format(agenda.theListOfAgenda[index].agendaStartAt)}',
                        style: TextStyleTemplate.regularPrimary(size: 14),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(DetailAgendaScreen.route, arguments: agenda.theListOfAgenda[index].uid),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: ColourTemplate.whiteColour,
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.25),
                              offset: const Offset(2, 4),
                              blurRadius: 8,
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    agenda.theListOfAgenda[index].agendaName,
                                    style: TextStyleTemplate.boldGray(size: 16),
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              agenda.theListOfAgenda[index].isActive ? 'Aktif' : 'Nonaktif',
                              style: agenda.theListOfAgenda[index].isActive
                                  ? TextStyleTemplate.regularPrimary(size: 11)
                                  : TextStyleTemplate.regularNegative(size: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat('dd').format(agenda.theListOfAgenda[index].agendaEndAt),
                            style: TextStyleTemplate.boldPrimary(size: 20),
                          ),
                          Column(
                            children: [
                              Text(
                                DateFormat('MMMM').format(agenda.theListOfAgenda[index].agendaEndAt),
                                style: TextStyleTemplate.regularPrimary(size: 12),
                              ),
                              Text(
                                DateFormat('yyyy').format(agenda.theListOfAgenda[index].agendaEndAt),
                                style: TextStyleTemplate.regularPrimary(size: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        '${DateFormat('HH').format(agenda.theListOfAgenda[index].agendaEndAt)} : ${DateFormat('mm').format(agenda.theListOfAgenda[index].agendaEndAt)}',
                        style: TextStyleTemplate.regularPrimary(size: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
