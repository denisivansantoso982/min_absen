import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/models/data/users_data.dart';
import 'package:min_absen/models/present_model.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:min_absen/widgets/list_item_widget.dart';
import 'package:provider/provider.dart';

class ListAbsenScreen extends StatelessWidget {
  const ListAbsenScreen({Key? key}) : super(key: key);

  static const String route = '/list_absen_screen';
  static DateTime choosenDate = DateTime.now();
  static TextEditingController theDate = TextEditingController(
      text: DateFormat("EEEE, dd MMMM yyyy").format(choosenDate));

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: choosenDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: "PILIH TANGGAL",
      cancelText: "BATAL",
      confirmText: "PILIH",
      fieldLabelText: "Masukkan Tanggal",
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
              colorScheme: const ColorScheme.light(
            primary: ColourTemplate.primaryColour,
          )),
          child: child!),
    );

    if (selectedDate != null && selectedDate != choosenDate) {
      choosenDate = selectedDate;
      theDate.text = DateFormat("EEEE, dd MMMM yyyy").format(selectedDate);
      _doGetPresent(context);
    }
  }

  String _doGetNameOfUser(BuildContext context, String usersUid) {
    List<UsersData> listUser = context.read<UsersModel>().theListOfUsers;
    late String name;
    for (var element in listUser) {
      if (element.uid == usersUid) {
        name = element.name;
        break;
      }
    }
    return name;
  }

  String _doFormatDate(int timestamp) {
    String result = DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
    return result;
  }

  void _doGetPresent(context) async {
    try {
      await getAllPresentData(context, choosenDate);
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

  void _doHandleOnPop(BuildContext context) {
    DateTime today = DateTime.now();
    choosenDate = DateTime(today.year, today.month, today.day);
    theDate.text = DateFormat("EEEE, dd MMMM yyyy").format(choosenDate);
    _doGetPresent(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        _doHandleOnPop(context);
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: AppBarWidget(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      _doHandleOnPop(context);
                      Navigator.of(context).pop();
                    },
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
                        "Kehadiran",
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
          child: Consumer<PresentModel>(
            builder: (context, present, child) => ListView.builder(
              itemCount: present.theListOfPresentData.length,
              itemBuilder: (context, index) {
                return ListItemWidget(
                  name: _doGetNameOfUser(
                      context, present.theListOfPresentData[index].users),
                  pretend: _doFormatDate(
                      present.theListOfPresentData[index].presentTime),
                  home: present.theListOfPresentData[index].homeTime == 0
                      ? ''
                      : _doFormatDate(
                          present.theListOfPresentData[index].homeTime),
                );
              },
            ),
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColourTemplate.whiteColour,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Filter",
                    style: TextStyleTemplate.boldGray(size: 16),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  TextField(
                    controller: theDate,
                    readOnly: true,
                    style: TextStyleTemplate.mediumPrimary(size: 14),
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * .55,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColourTemplate.primaryColour,
                          width: 2,
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColourTemplate.primaryColour,
                          width: 2,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColourTemplate.primaryColour,
                          width: 2,
                        ),
                      ),
                      isDense: true,
                      suffix: Container(
                        color: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: const Icon(
                                Icons.calendar_today_outlined,
                                color: ColourTemplate.primaryColour,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        bottom: 4,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context
                        .watch<PresentModel>()
                        .theListOfPresentData
                        .length
                        .toString(),
                    style: TextStyleTemplate.boldPrimary(size: 24),
                  ),
                  Text(
                    "/",
                    style: TextStyleTemplate.regularPrimary(size: 14),
                  ),
                  Text(
                    context
                        .watch<UsersModel>()
                        .theListOfUsers
                        .length
                        .toString(),
                    style: TextStyleTemplate.mediumPrimary(size: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
