import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_absen/firebase/auth.dart';
import 'package:min_absen/models/profile_model.dart';
import 'package:min_absen/screens/login_screen.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';
import 'package:min_absen/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String route = '/profile_screen';

  void _doLogout(BuildContext context) async {
    await signOut();
    Provider.of<ProfileModel>(context, listen: false).removeAllProfile();
    bool isStored =
        Provider.of<ProfileModel>(context, listen: false).theProfile != null
            ? true
            : false;
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (!isStored) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "Profil",
                      style: TextStyleTemplate.boldGray(size: 28),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Saya",
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
        child: Column(
          children: [
            Form(
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
                child: Consumer<ProfileModel?>(
                  builder: (context, profile, child) {
                    return Column(
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
                                readOnly: true,
                                initialValue: profile!.theProfile != null
                                    ? profile.theProfile!.name
                                    : '',
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
                                style:
                                    TextStyleTemplate.mediumPrimary(size: 16),
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
                                initialValue: DateFormat('EEEE, dd MMMM yyyy')
                                    .format(profile.profileData != null
                                        ? profile.profileData!.birthDate
                                        : DateTime.now()),
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
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    bottom: 4,
                                    top: 8,
                                  ),
                                ),
                                cursorColor: ColourTemplate.primaryColour,
                                readOnly: true,
                                style:
                                    TextStyleTemplate.mediumPrimary(size: 16),
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
                              TextFormField(
                                readOnly: true,
                                initialValue: profile.profileData != null
                                    ? profile.profileData!.sex
                                    : '',
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
                                cursorColor: ColourTemplate.primaryColour,
                                style:
                                    TextStyleTemplate.mediumPrimary(size: 16),
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
                                  style:
                                      TextStyleTemplate.mediumGray(size: 18)),
                              TextFormField(
                                readOnly: true,
                                initialValue: profile.profileData != null
                                    ? profile.profileData!.email
                                    : '',
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
                                style:
                                    TextStyleTemplate.mediumPrimary(size: 16),
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
                              Text("Role",
                                  style:
                                      TextStyleTemplate.mediumGray(size: 18)),
                              TextFormField(
                                initialValue: profile.theProfile != null
                                    ? profile.theProfile!.role
                                    : '',
                                readOnly: true,
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
                                cursorColor: ColourTemplate.primaryColour,
                                style:
                                    TextStyleTemplate.mediumPrimary(size: 16),
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
                                readOnly: true,
                                initialValue: profile.theProfile != null
                                    ? profile.theProfile!.quotes
                                    : '',
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
                                style:
                                    TextStyleTemplate.mediumPrimary(size: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // *Logout Button
            Container(
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: ColourTemplate.negativeColour,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.black.withOpacity(.25),
                  highlightColor: Colors.black.withOpacity(.25),
                  onTap: () => _doLogout(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text("KELUAR",
                        style: TextStyleTemplate.boldWhite(size: 20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
