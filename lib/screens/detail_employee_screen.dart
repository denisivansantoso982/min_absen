import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/models/data/users_data.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:min_absen/templates/alert_dialog_template.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class DetailEmployeeScreen extends StatefulWidget {
  const DetailEmployeeScreen({Key? key}) : super(key: key);

  static const String route = '/detail_employee_screen';

  @override
  State<DetailEmployeeScreen> createState() => _DetailEmployeeScreenState();
}

class _DetailEmployeeScreenState extends State<DetailEmployeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime birthDate = DateTime.now();
  final TextEditingController theUid = TextEditingController(text: '');
  final TextEditingController theName = TextEditingController(text: '');
  final TextEditingController theSex = TextEditingController(text: '');
  final TextEditingController theEmail = TextEditingController(text: '');
  final TextEditingController theRole = TextEditingController(text: '');
  final TextEditingController theQuotes = TextEditingController(text: '');
  final TextEditingController theBirthDate = TextEditingController(text: '');
  final FocusNode theFocusName = FocusNode();
  final FocusNode theFocusSex = FocusNode();
  final FocusNode theFocusEmail = FocusNode();
  final FocusNode theFocusRole = FocusNode();
  final FocusNode theFocusQuotes = FocusNode();
  final FocusNode theFocusBirthDate = FocusNode();
  final List<String> sexOptions = <String>['Pria', 'Wanita'];
  final List<String> roleOptions = <String>['Admin', 'Karyawan'];

  void _initial(BuildContext context) {
    String uid = ModalRoute.of(context)!.settings.arguments as String;
    UsersData data = context
        .watch<UsersModel>()
        .theListOfUsers
        .firstWhere((element) => element.uid == uid);
    setState(() {
      birthDate = data.birthDate;
    });
    theUid.text = uid;
    theName.text = data.name;
    theSex.text = data.sex;
    theEmail.text = data.email;
    theRole.text = data.role;
    theQuotes.text = data.quotes;
    theBirthDate.text = DateFormat('EEEE, dd MMMM yyyy').format(birthDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (selectedDate != null && selectedDate != birthDate) {
      String dateString = DateFormat("EEEE, dd MMMM yyyy").format(selectedDate);
      theBirthDate.text = dateString;
      birthDate = selectedDate;
    }
  }

  void _doUpdateEmployeeData(BuildContext context) async {
    try {
      if (_doValidation(context)) {
        showDialog(
          context: context,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );
        UsersData user = UsersData(
          uid: theUid.text,
          name: theName.text,
          birthDate: birthDate,
          sex: theSex.text,
          quotes: theQuotes.text,
          email: theEmail.text,
          role: theRole.text,
        );
        await doUpdateUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pengguna berhasil diubah!',
              style: TextStyleTemplate.regularWhite(size: 14),
            ),
            backgroundColor: ColourTemplate.primaryColour,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      AlertDialogTemplate().showTheDialog(
        context: context,
        title: 'Terjadi Kesalahan!',
        content: error.toString(),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "OK",
              style: TextStyleTemplate.mediumWhite(size: 16),
            ),
            onPressed: () => Navigator.of(context).pop(),
            color: ColourTemplate.primaryColour,
          ),
        ],
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  bool _doValidation(BuildContext context) {
    if (theUid.text == '' || theUid.text.isEmpty) {
      theFocusName.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nama tidak boleh kosong!',
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    } else if (theBirthDate.text == '' || theBirthDate.text.isEmpty) {
      theFocusBirthDate.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tanggal Lahir tidak boleh kosong!',
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    } else if (theSex.text == '' || theSex.text.isEmpty) {
      theFocusSex.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jenis Kelamin tidak boleh kosong!',
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    } else if (theEmail.text == '' || theEmail.text.isEmpty) {
      theFocusEmail.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email tidak boleh kosong!',
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    } else if (theRole.text == '' || theRole.text.isEmpty) {
      theFocusRole.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Role tidak boleh kosong!',
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    } else if (theQuotes.text == '' || theQuotes.text.isEmpty) {
      theFocusQuotes.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kata-Kata tidak boleh kosong!',
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
    _initial(context);
    return Scaffold(
      backgroundColor: ColourTemplate.whiteColour,
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Detail",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 24,
        ),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withOpacity(.25),
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(
              top: 24,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            child: Column(
              children: [
                // *Name
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama",
                        style: TextStyleTemplate.mediumGray(size: 18),
                      ),
                      TextFormField(
                        controller: theName,
                        focusNode: theFocusName,
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
                          hintText: "Nama Lengkap",
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                        ),
                        cursorColor: ColourTemplate.primaryColour,
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                      ),
                    ],
                  ),
                ),
                // *Date of Birth
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal Lahir",
                        style: TextStyleTemplate.mediumGray(size: 18),
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: theBirthDate,
                        focusNode: theFocusBirthDate,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColourTemplate.primaryColour,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColourTemplate.primaryColour,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColourTemplate.primaryColour,
                              style: BorderStyle.solid,
                            ),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                          suffix: Container(
                            color: Colors.transparent,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: const Icon(
                                    Icons.calendar_today_outlined,
                                    color: ColourTemplate.primaryColour,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        cursorColor: ColourTemplate.primaryColour,
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                        onTap: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
                // *Sex
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jenis Kelamin",
                        style: TextStyleTemplate.mediumGray(size: 18),
                      ),
                      DropdownButtonFormField(
                        items: sexOptions
                            .map<DropdownMenuItem<String>>(
                                (element) => DropdownMenuItem<String>(
                                      child: Text(element),
                                      value: element,
                                    ))
                            .toList(),
                        focusNode: theFocusSex,
                        value: theSex.text,
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
                          hintText: "Jenis Kelamin",
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                        ),
                        onChanged: (value) {
                          theSex.text = value as String;
                        },
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                      ),
                    ],
                  ),
                ),
                // *Email
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email",
                          style: TextStyleTemplate.mediumGray(size: 18)),
                      TextFormField(
                        controller: theEmail,
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
                          hintText: "Alamat Email",
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                        ),
                        cursorColor: ColourTemplate.primaryColour,
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                      ),
                    ],
                  ),
                ),
                // *Role
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Role",
                        style: TextStyleTemplate.mediumGray(size: 18),
                      ),
                      DropdownButtonFormField(
                        items: roleOptions
                            .map<DropdownMenuItem<String>>(
                                (element) => DropdownMenuItem<String>(
                                      child: Text(element),
                                      value: element,
                                    ))
                            .toList(),
                        value: theRole.text,
                        focusNode: theFocusRole,
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
                          hintText: "Role",
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                        ),
                        onChanged: (value) {
                          theRole.text = value as String;
                        },
                        style: TextStyleTemplate.mediumPrimary(size: 16),
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
                      Text(
                        "Kata-Kata",
                        style: TextStyleTemplate.mediumGray(size: 18),
                      ),
                      TextFormField(
                        controller: theQuotes,
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: null,
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
                          hintText: "Kata-Kata",
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            bottom: 4,
                            top: 8,
                          ),
                        ),
                        cursorColor: ColourTemplate.primaryColour,
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                      ),
                    ],
                  ),
                ),
                // *Update Button
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: ColourTemplate.primaryColour,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.black.withOpacity(.15),
                      highlightColor: Colors.black.withOpacity(.15),
                      onTap: () => _doUpdateEmployeeData(context),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("PERBARUI",
                            style: TextStyleTemplate.boldWhite(size: 18)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
