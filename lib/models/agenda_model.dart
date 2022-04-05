import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:min_absen/models/data/agenda_data.dart';

class AgendaModel extends ChangeNotifier {
  final List<AgendaData> _listAgenda = [];

  UnmodifiableListView<AgendaData> get theListOfAgenda =>
      UnmodifiableListView(_listAgenda);

  void fillAgenda(AgendaData agenda) {
    _listAgenda.add(agenda);
    notifyListeners();
  }

  void clearAgenda() {
    _listAgenda.clear();
    notifyListeners();
  }
}
