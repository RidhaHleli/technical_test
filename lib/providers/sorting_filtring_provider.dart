import 'package:flutter/material.dart';

class SortingFilteringProvider extends ChangeNotifier {
  bool _sortByDate = true;
  bool _showOverdue = false;
  bool _showDueToday = false;

  bool get sortByDate => _sortByDate;
  bool get showOverdue => _showOverdue;
  bool get showDueToday => _showDueToday;

  set sortByDate(bool value) {
    _sortByDate = value;
    notifyListeners();
  }

  set showOverdue(bool value) {
    _showOverdue = value;
    notifyListeners();
  }

  set showDueToday(bool value) {
    _showDueToday = value;
    notifyListeners();
  }
}
