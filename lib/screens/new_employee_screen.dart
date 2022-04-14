import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/database.dart';
import 'package:min_absen/templates/alert_dialog_template.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';

class NewEmployeeScreen extends StatefulWidget {
  const NewEmployeeScreen({Key? key}) : super(key: key);

  static const String route = '/new_employee_screen';

  @override
  State<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends State<NewEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController theName = TextEditingController(text: "");
  TextEditingController theDateOfBirth = TextEditingController(text: "");
  TextEditingController theSex = TextEditingController(text: "");
  TextEditingController theQuotes = TextEditingController(text: "");
  TextEditingController theEmail = TextEditingController(text: "");
  TextEditingController theLevel = TextEditingController(text: "");
  DateTime dob = DateTime.now();
  FocusNode theFocusName = FocusNode();
  FocusNode theFocusSex = FocusNode();
  FocusNode theFocusQuotes = FocusNode();
  FocusNode theFocusEmail = FocusNode();
  FocusNode theFocusLevel = FocusNode();
  bool visibleLoadingPanel = false;

  @override
  void initState() {
    super.initState();
    String initDate = DateFormat("EEEE, dd MMMM yyyy").format(dob);
    setState(() {
      theDateOfBirth.text = initDate;
    });
  }

  void _addNewEmployee(BuildContext context) async {
    try {
      if (_doValidation(context)) {
        setState(() {
          visibleLoadingPanel = true;
        });
        await checkUserByEmail(theEmail.text).then((value) async {
          if (value != null) {
            AlertDialogTemplate().showTheDialog(
              context: context,
              title: "Perhatian!",
              content: "Pengguna dengan alamat email ini sudah terdaftar!",
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
          } else {
            await doAddUsers({
              "name": theName.text,
              "date_of_birth": dob.millisecondsSinceEpoch,
              "sex": theSex.text,
              "quotes": theQuotes.text,
              "email": theEmail.text,
              "level": theLevel.text,
              "is_active": true
            }).then((value) {
              AlertDialogTemplate().showTheDialog(
                context: context,
                title: "Berhasil",
                content: "Data pengguna berhasil ditambahkan!",
                actions: [
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: ColourTemplate.primaryColour,
                    child: Text("OKE",
                        style: TextStyleTemplate.mediumWhite(size: 16)),
                  ),
                ],
              );
            });
          }
        });
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
    if (theName.text == '' || theName.text.isEmpty) {
      theFocusName.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Nama tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theDateOfBirth.text.isEmpty || theDateOfBirth.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Tanggal Lahir tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theSex.text == '' || theSex.text.isEmpty) {
      theFocusSex.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Jenis Kelamin tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theEmail.text == '' || theEmail.text.isEmpty) {
      theFocusEmail.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Alamat Email tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theQuotes.text == '' || theQuotes.text.isEmpty) {
      theFocusQuotes.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Kata-Kata tidak boleh kosong!",
            style: TextStyleTemplate.regularWhite(size: 14),
          ),
          backgroundColor: ColourTemplate.negativeColour,
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (theLevel.text == '' || theLevel.text.isEmpty) {
      theFocusLevel.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Level Pengguna tidak boleh kosong!",
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

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dob,
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
    if (selectedDate != null && selectedDate != dob) {
      String dateString = DateFormat("EEEE, dd MMMM yyyy").format(selectedDate);
      dob = selectedDate;
      theDateOfBirth.text = dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "Tambah",
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
                      "Anggota",
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
          key: _formKey,
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
                // *Name
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        focusNode: theFocusName,
                        controller: theName,
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
                          hintText: "Nama Lengkap",
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
                // *Date Of Birth
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Lahir",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: theDateOfBirth,
                        onTap: () => _selectDate(context),
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
                                onTap: () => _selectDate(context),
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
                // *Sex
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        items: <String>["Pria", "Wanita"]
                            .map<DropdownMenuItem<String>>(
                                (value) => DropdownMenuItem<String>(
                                      child: Text(value),
                                      value: value,
                                    ))
                            .toList(),
                        onChanged: (value) => theSex.text = value!,
                        focusNode: theFocusSex,
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintStyle: TextStyle(fontWeight: FontWeight.w600),
                          isDense: true,
                          hintText: "Jenis Kelamin Anda",
                        ),
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
                      const Text(
                        "Email",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        focusNode: theFocusEmail,
                        controller: theEmail,
                        keyboardType: TextInputType.emailAddress,
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
                          hintText: "Alamat Email",
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
                // *Quotes
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kata-Kata",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        focusNode: theFocusQuotes,
                        controller: theQuotes,
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
                          hintText: "Kata-kata",
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
                // *Level
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Level",
                        style: TextStyle(
                          color: ColourTemplate.grayColour,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        items: <String>["Admin", "Karyawan"]
                            .map<DropdownMenuItem<String>>(
                                (value) => DropdownMenuItem<String>(
                                      child: Text(value),
                                      value: value,
                                    ))
                            .toList(),
                        onChanged: (value) => theLevel.text = value!,
                        focusNode: theFocusLevel,
                        style: TextStyleTemplate.mediumPrimary(size: 16),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColourTemplate.primaryColour,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintStyle: TextStyle(fontWeight: FontWeight.w600),
                          isDense: true,
                          hintText: "Level Keanggotaan",
                        ),
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
                        onTap: () => _addNewEmployee(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: const Text(
                            "TAMBAHKAN",
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
