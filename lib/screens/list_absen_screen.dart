import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:min_absen/widgets/list_item_widget.dart';

class ListAbsenScreen extends StatelessWidget {
  const ListAbsenScreen({Key? key}) : super(key: key);

  static const String route = '/list_absen_screen';
  static DateTime choosenDate = DateTime.now();
  static TextEditingController theDate = TextEditingController(
      text: DateFormat("dd MMMM yyyy").format(choosenDate));
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
      theDate.text = DateFormat("dd MMMM yyyy").format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
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
              Text(
                "17",
                style: TextStyleTemplate.boldGray(size: 32),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "February",
                    style: TextStyleTemplate.mediumPrimary(size: 18),
                  ),
                  Text(
                    "2022",
                    style: TextStyleTemplate.mediumGray(size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 12,
        ),
        child: ListView.builder(
          itemCount: theData.length,
          itemBuilder: (context, index) {
            return ListItemWidget(
              name: theData[index]['name'],
              pretend: theData[index]['pretend'],
              home: theData[index]['home'],
            );
          },
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
                      maxWidth: screenWidth * .45,
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
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                  "4",
                  style: TextStyleTemplate.boldPrimary(size: 24),
                ),
                Text(
                  "/",
                  style: TextStyleTemplate.regularPrimary(size: 14),
                ),
                Text(
                  "20",
                  style: TextStyleTemplate.mediumPrimary(size: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
