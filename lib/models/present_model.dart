import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:min_absen/models/data/present_data.dart';

class PresentModel extends ChangeNotifier {
  final List<PresentData> _theListOfPresentData = <PresentData>[];

  UnmodifiableListView<PresentData> get theListOfPresentData =>
      UnmodifiableListView(_theListOfPresentData);

  void getAllPresentData(PresentData presentData) {
    _theListOfPresentData.add(presentData);
    notifyListeners();
  }

  void clearAllPresentData() {
    _theListOfPresentData.clear();
    notifyListeners();
  }
}
