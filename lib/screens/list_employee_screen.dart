import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:min_absen/screens/detail_employee_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:min_absen/widgets/list_item_widget.dart';
import 'package:provider/provider.dart';

class ListEmployeeScreen extends StatelessWidget {
  const ListEmployeeScreen({Key? key}) : super(key: key);

  static const String route = '/list_employee_screen';
  static List<Map<String, dynamic>> theData = <Map<String, dynamic>>[
    {
      "name": "Denis",
      "pretend": "7:30",
      "home": "17:03"
    },
    {
      "name": "Epan",
      "pretend": "7:30",
      "home": "17:03"
    },
    {
      "name": "Bagus",
      "pretend": "7:30",
      "home": "17:03"
    },
    {
      "name": "Yoel",
      "pretend": "7:30",
      "home": "17:03"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourTemplate.whiteColour,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBarWidget(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      "Pegawai",
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
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 24,
        ),
        child: Consumer<UsersModel>(
          builder: (context, users, child) => ListView.builder(
            itemCount: users.theListOfUsers.length,
            itemBuilder: (contex, index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  DetailEmployeeScreen.route,
                  arguments: users.theListOfUsers.elementAt(index).uid,
                ),
                child: ListItemWidget(
                  name: users.theListOfUsers.elementAt(index).name,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
