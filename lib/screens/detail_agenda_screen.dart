import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/models/agenda_model.dart';
import 'package:min_absen/models/data/agenda_data.dart';
import 'package:min_absen/templates/alert_dialog_template.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class DetailAgendaScreen extends StatefulWidget {
  const DetailAgendaScreen({Key? key}) : super(key: key);
  static const String route = '/detail_agenda_screen';

  @override
  _DetailAgendaScreenState createState() => _DetailAgendaScreenState();
}

class _DetailAgendaScreenState extends State<DetailAgendaScreen> {
  DateTime today = DateTime.now();
  String uid = '';
  DateTime agendaStartDate = DateTime.now();
  DateTime agendaEndDate = DateTime.now().add(const Duration(days: 1));
  TextEditingController theAgendaName = TextEditingController();
  TextEditingController theAgendaDetail = TextEditingController();
  TextEditingController theAgendaStart = TextEditingController();
  TextEditingController theAgendaEnd = TextEditingController();
  TextEditingController theActive = TextEditingController(text: '');
  FocusNode theFocusName = FocusNode();
  FocusNode theFocusDetail = FocusNode();
  FocusNode theFocusActive = FocusNode();
  bool visibleLoadingPanel = false;
  List<String> statusOptions = <String>['Aktif', 'Nonaktif'];

  void initial() {
    theAgendaStart.text =
        DateFormat("EEEE, dd MMMM yyyy - HH:mm").format(agendaStartDate);
    theAgendaEnd.text =
        DateFormat("EEEE, dd MMMM yyyy - HH:mm").format(agendaEndDate);
  }

  void _doGetAgendaDetail(BuildContext context, String uid) {
    final AgendaData agenda = Provider.of<AgendaModel>(context, listen: false)
        .theListOfAgenda
        .firstWhere((element) => element.uid == uid);
    setState(() {
      this.uid = uid;
      theAgendaName.text = agenda.agendaName;
      theAgendaDetail.text = agenda.agendaDetail;
      agendaStartDate = agenda.agendaStartAt;
      agendaEndDate = agenda.agendaEndAt;
      theAgendaStart.text =
          DateFormat("EEEE, dd MMMM yyyy - HH:mm").format(agendaStartDate);
      theAgendaEnd.text =
          DateFormat("EEEE, dd MMMM yyyy - HH:mm").format(agendaEndDate);
      theActive.text = statusOptions.elementAt(agenda.isActive ? 0 : 1);
    });
  }

  void _doSelectStartDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: agendaStartDate,
      firstDate: agendaStartDate,
      lastDate: DateTime(2200),
      helpText: "PILIH TANGGAL",
      cancelText: "BATAL",
      confirmText: "PILIH",
      fieldLabelText: "Masukkan Tanggal",
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme:
                const ColorScheme.light(primary: ColourTemplate.primaryColour),
          ),
          child: child!),
    );
    final selectTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: agendaStartDate.hour, minute: agendaStartDate.minute),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "PILIH WAKTU",
      cancelText: "BATAL",
      confirmText: "PILIH",
      hourLabelText: "Masukkan Waktu",
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColourTemplate.primaryColour,
            ),
          ),
          child: child!),
    );
    if (selectedDate != null &&
        selectedDate != agendaStartDate &&
        selectTime != null) {
      DateTime result = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectTime.hour,
        selectTime.minute,
      );
      String resultString =
          DateFormat("EEEE, dd MMMM yyyy - HH:mm").format(result);
      agendaStartDate = result;
      theAgendaStart.text = resultString;
      if (agendaStartDate.isAfter(agendaEndDate)) {
        agendaEndDate = result;
        theAgendaEnd.text = resultString;
      }
    }
  }

  void _doSelectEndDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: agendaStartDate,
      firstDate: agendaStartDate,
      lastDate: DateTime(2200),
      helpText: "PILIH TANGGAL",
      cancelText: "BATAL",
      confirmText: "PILIH",
      fieldLabelText: "Masukkan Tanggal",
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme:
                const ColorScheme.light(primary: ColourTemplate.primaryColour),
          ),
          child: child!),
    );
    final selectTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: agendaEndDate.add(const Duration(seconds: 1)).hour,
          minute: agendaEndDate.minute),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "PILIH WAKTU",
      cancelText: "BATAL",
      confirmText: "PILIH",
      hourLabelText: "Masukkan Waktu",
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColourTemplate.primaryColour,
            ),
          ),
          child: child!),
    );
    if (selectedDate != null &&
        selectedDate != agendaEndDate &&
        selectTime != null) {
      DateTime result = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectTime.hour,
        selectTime.minute,
      );
      String resultString =
          DateFormat("EEEE, dd MMMM yyyy - HH:mm").format(result);
      agendaEndDate = result;
      theAgendaEnd.text = resultString;
    }
  }

  void _doEditAgenda(BuildContext context) async {
    try {
      if (_doValidation(context)) {
        setState(() {
          visibleLoadingPanel = true;
        });
        await doEditAgenda(AgendaData(
          uid: uid,
          agendaName: theAgendaName.text,
          agendaDetail: theAgendaDetail.text,
          agendaStartAt: agendaStartDate,
          agendaEndAt: agendaEndDate,
          isActive: theActive.text == 'Aktif' ? true : false,
        ));
        AlertDialogTemplate().showTheDialog(
          context: context,
          title: "Berhasil",
          content: "Agenda berhasil diubah!",
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              color: ColourTemplate.primaryColour,
              child:
                  Text("OKE", style: TextStyleTemplate.mediumWhite(size: 16)),
            ),
          ],
        );
      }
    } catch (error) {
      AlertDialogTemplate().showTheDialog(
        context: context,
        title: "Terjadi Kesalahan",
        content: error.toString(),
        actions: [
          MaterialButton(
            color: ColourTemplate.primaryColour,
            child: Text(
              "OKE",
              style: TextStyleTemplate.mediumWhite(size: 16),
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    } finally {
      setState(() {
        visibleLoadingPanel = false;
      });
    }
  }

  bool _doValidation(BuildContext context) {
    if (theAgendaName.text == '' || theAgendaName.text.isEmpty) {
      theFocusName.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Nama Agenda tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theAgendaStart.text == '' || theAgendaStart.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Waktu Mulai Agenda tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theAgendaEnd.text == '' || theAgendaEnd.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Waktu Berakhir Agenda tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theAgendaEnd.text == '' || theAgendaEnd.text.isEmpty) {
      theFocusDetail.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Detail Agenda tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments as String;
    initial();
    _doGetAgendaDetail(context, uid);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBarWidget(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 8,
                ),
                child: GestureDetector(
                  onTap: () {
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Detail",
                      style: TextStyle(
                        color: ColourTemplate.grayColour,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Agenda",
                      style: TextStyle(
                        color: ColourTemplate.primaryColour,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 4,
        ),
        child: Form(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 4,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(
              top: 8,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            child: Column(
              children: [
                // *Agenda Name
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Agenda",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        focusNode: theFocusName,
                        controller: theAgendaName,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                          hintText: "Nama Agenda",
                          isDense: true,
                        ),
                        cursorColor: ColourTemplate.primaryColour,
                        style: const TextStyle(
                          color: ColourTemplate.primaryColour,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // *Agenda Start
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Mulai Agenda",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: theAgendaStart,
                        onTap: () => _doSelectStartDate(context),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          suffix: Container(
                            color: Colors.transparent,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () => _doSelectStartDate(context),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColourTemplate.primaryColour,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                          isDense: true,
                        ),
                        readOnly: true,
                        cursorColor: ColourTemplate.primaryColour,
                        style: const TextStyle(
                          color: ColourTemplate.primaryColour,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // *Agenda End
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Berakhir Agenda",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: theAgendaEnd,
                        onTap: () => _doSelectEndDate(context),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          suffix: Container(
                            color: Colors.transparent,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () => _doSelectEndDate(context),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColourTemplate.primaryColour,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                          isDense: true,
                        ),
                        readOnly: true,
                        cursorColor: ColourTemplate.primaryColour,
                        style: const TextStyle(
                          color: ColourTemplate.primaryColour,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // *Quotes
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detail Agenda",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        focusNode: theFocusDetail,
                        controller: theAgendaDetail,
                        maxLines: null,
                        maxLength: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                          hintText: "Detail Agenda",
                          isDense: true,
                        ),
                        cursorColor: ColourTemplate.primaryColour,
                        style: const TextStyle(
                          color: ColourTemplate.primaryColour,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // *Status
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyleTemplate.mediumGray(size: 18),
                      ),
                      DropdownButtonFormField(
                        items: statusOptions
                            .map<DropdownMenuItem<String>>(
                                (element) => DropdownMenuItem<String>(
                                      child: Text(element),
                                      value: element,
                                    ))
                            .toList(),
                        value: theActive.text,
                        focusNode: theFocusActive,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColourTemplate.primaryColour,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColourTemplate.primaryColour,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColourTemplate.primaryColour,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "Status",
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                        ),
                        onChanged: (value) {
                          theActive.text = value as String;
                        },
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                      ),
                    ],
                  ),
                ),
                // *Done Button
                Visibility(
                  visible: !visibleLoadingPanel,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: ColourTemplate.primaryColour,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.black.withOpacity(.25),
                        highlightColor: Colors.black.withOpacity(.25),
                        onTap: () => _doEditAgenda(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: const Text(
                            "PERBARUI",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // *Loading Panel
                Visibility(
                  visible: visibleLoadingPanel,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(12),
                    height: 36,
                    width: 36,
                    child: const CircularProgressIndicator(
                      color: ColourTemplate.primaryColour,
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
