import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:min_absen/models/agenda_model.dart';
import 'package:min_absen/models/data/agenda_data.dart';
import 'package:min_absen/models/data/present_data.dart';
import 'package:min_absen/models/data/users_data.dart';
import 'package:min_absen/models/present_model.dart';
import 'package:min_absen/models/users_model.dart';
import 'package:provider/provider.dart';

DatabaseReference usersReference = FirebaseDatabase.instance.ref('users');
DatabaseReference presentReference = FirebaseDatabase.instance.ref('present');
DatabaseReference agendaReference = FirebaseDatabase.instance.ref('agenda');

Future<DataSnapshot?> checkUserByEmail(String? email) async {
  final DataSnapshot dataSnapshot = await usersReference
      .orderByChild('email')
      .equalTo(email)
      .get()
      .onError((error, stackTrace) => Future.error(error!, stackTrace));
  if (!dataSnapshot.exists
    || dataSnapshot.children.first.child('level').value.toString() != 'Admin'
    || dataSnapshot.children.first.child('is_active').value.toString() != 'true') {
    return null;
  }
  return dataSnapshot;
}

Future<void> getAllUsers(BuildContext context) async {
  usersReference.onValue.listen((event) {
    Provider.of<UsersModel>(context, listen: false).clearAllUsers();
    List<DataSnapshot> data = event.snapshot.children.toList();
    data.sort((a, b) => b.child('is_active').value.toString().compareTo(a.child('is_active').value.toString()));
    for (var element in data) {
      Provider.of<UsersModel>(context, listen: false).getAllUsers(
        UsersData(
          uid: element.key.toString(),
          name: element.child('name').value.toString(),
          birthDate: DateTime.fromMillisecondsSinceEpoch(
              int.parse(element.child('date_of_birth').value.toString())),
          sex: element.child('sex').value.toString(),
          quotes: element.child('quotes').value.toString(),
          email: element.child('email').value.toString(),
          role: element.child('level').value.toString(),
          isActive: element.child('is_active').value as bool,
        ),
      );
    }
  }).onError((error, stackTrace) => Future.error(error, stackTrace));
}

Future<void> doAddUsers(Map<String, dynamic> user) async {
  return await usersReference.push().set(user);
}

Future<void> doUpdateUser(UsersData user) async {
  usersReference.child(user.uid).set(<String, dynamic>{
    'name': user.name,
    'date_of_birth': user.birthDate.millisecondsSinceEpoch,
    'sex': user.sex,
    'email': user.email,
    'level': user.role,
    'quotes': user.quotes,
    'is_active': user.isActive,
  }).catchError((error) => Future.error(error));
}

Future<void> getAllPresentData(BuildContext context, DateTime? theDate) async {
  DateTime today = DateTime.now();
  DateTime firstDate = theDate ?? DateTime(today.year, today.month, today.day);
  DateTime secondDate = theDate != null
      ? theDate.add(const Duration(hours: 24))
      : today.add(const Duration(hours: 24));
  presentReference
      .orderByChild('present_at')
      .endAt(secondDate.millisecondsSinceEpoch, key: 'present_at')
      .startAt(firstDate.millisecondsSinceEpoch, key: 'present_at')
      .onValue
      .listen((event) {
    Provider.of<PresentModel>(context, listen: false).clearAllPresentData();
    List<DataSnapshot> data = event.snapshot.children.toList();
    for (var element in data) {
      Provider.of<PresentModel>(context, listen: false)
          .getAllPresentData(PresentData(
        uid: element.key.toString(),
        users: element.child('users').value.toString(),
        presentTime: int.parse(element.child('present_at').value.toString()),
        homeTime: element.child('home_at').value != null
            ? int.parse(element.child('home_at').value.toString())
            : 0,
      ));
    }
  }).onError((error, stackTrace) => Future.error(error, stackTrace));
}

Future<void> doAddAgenda(Map<String, dynamic> agenda) async {
  return await agendaReference
      .push()
      .set(agenda)
      .onError((error, stackTrace) => Future.error(error!, stackTrace));
}

Future<void> getTheAgenda(BuildContext context, DateTime? theDate) async {
  int timestamp =
      theDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
  agendaReference
      .orderByChild('agenda_end_at')
      .startAt(timestamp, key: 'agenda_end_at')
      .onValue
      .listen((event) {
    Provider.of<AgendaModel>(context, listen: false).clearAgenda();
    final List<DataSnapshot> data = event.snapshot.children.toList();
    data.sort(
      (a, b) => int.parse(a.child('agenda_start_at').value.toString())
          .compareTo(int.parse(b.child('agenda_start_at').value.toString())),
    );
    for (var element in data) {
      Provider.of<AgendaModel>(context, listen: false).fillAgenda(
        AgendaData(
          uid: element.key.toString(),
          agendaName: element.child('agenda_name').value.toString(),
          agendaDetail: element.child('agenda_detail').value.toString(),
          agendaStartAt: DateTime.fromMillisecondsSinceEpoch(int.parse(
            element.child('agenda_start_at').value.toString(),
          )),
          agendaEndAt: DateTime.fromMillisecondsSinceEpoch(int.parse(
            element.child('agenda_end_at').value.toString(),
          )),
          isActive: element.child('is_active').value as bool,
        ),
      );
    }
  }).onError((error, stackTrace) => Future.error(error, stackTrace));
}

Future<void> doEditAgenda(AgendaData agenda) async {
  return await agendaReference.child(agenda.uid).set({
    'agenda_name': agenda.agendaName,
    'agenda_start_at': agenda.agendaStartAt.millisecondsSinceEpoch,
    'agenda_end_at': agenda.agendaEndAt.millisecondsSinceEpoch,
    'agenda_detail': agenda.agendaDetail,
    'is_active': agenda.isActive,
  });
}
