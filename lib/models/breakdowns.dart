import 'package:flutter/material.dart';
import 'package:finnapp/database/dbHelper.dart';
import 'package:finnapp/models/breakdown.dart';

class Breakdowns with ChangeNotifier {
  List<Breakdown> _breakdowns = List<Breakdown>();
  int _totalMoney = 0;

  List<Breakdown> get breakdowns => _breakdowns;

  int get totalMoney => _totalMoney;

  Breakdowns() {
    getFromDB();
  }

  getFromDB() async {
    _breakdowns = await DBHelper.db.getBreakdownsFromDB();
    getTotalMoney();
    notifyListeners();
  }

  void getTotalMoney() {
    _totalMoney = 0;
    for (int i = 0; i < _breakdowns.length; i++) {
      if (_breakdowns[i].type == 'income')
        _totalMoney += _breakdowns[i].cost;
      else
        _totalMoney -= _breakdowns[i].cost;
    }
    notifyListeners();
  }
}
