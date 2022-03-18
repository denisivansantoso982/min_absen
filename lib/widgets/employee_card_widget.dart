import 'package:flutter/material.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:min_absen/screens/list_employee_screen.dart';
import 'package:min_absen/screens/new_employee_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:provider/provider.dart';
import 'card_menu_widget.dart';

class EmployeeCardWidget extends StatelessWidget {
  const EmployeeCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardMenuWidget(
      startColour: ColourTemplate.accentColour.withOpacity(.8),
      endColour: ColourTemplate.accentColour,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pegawai",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jumlah Pegawai",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Consumer<UsersModel>(
                      builder: (context, users, child) =>  Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 12),
                        child: Text(
                          users.theListOfUsers.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                      onTap: () => Navigator.of(context).pushNamed(ListEmployeeScreen.route),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: const Text(
                          "Lihat Detail",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColourTemplate.accentColour,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "BUANA PAKSA \nINDONESIA",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  color: Colors.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(NewEmployeeScreen.route);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: const Text(
                        "Tambah Pegawai",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColourTemplate.accentColour),
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
