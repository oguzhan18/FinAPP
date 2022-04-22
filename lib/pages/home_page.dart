import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:finnapp/database/dbHelper.dart';
import 'package:finnapp/models/breakdown.dart';
import 'package:finnapp/models/breakdowns.dart';
import 'package:finnapp/pages/input_page.dart';
import 'package:finnapp/pages/updatePage.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> _selection = [true, false, false];

  @override
  Widget build(BuildContext context) {
    Breakdowns breakdowns = Provider.of<Breakdowns>(context);
    return Scaffold(
      body: buildBody(breakdowns),
      floatingActionButton: floatingButton(breakdowns),
    );
  }

  buildBody(Breakdowns breakdowns) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
        ),
        _typePicker(),
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
        ),
        Expanded(
          child: breakdownsList(breakdowns),
        ),
        totalMoney(breakdowns)
      ],
    ));
  }

  _typePicker() {
    return Container(
      height: 40,
      child: ToggleButtons(
        isSelected: _selection,
        children: <Widget>[
          Container(
              width: (MediaQuery.of(context).size.width - 54) / 3,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Tüm Kayıtlar",
                  )
                ],
              )),
          Container(
              width: (MediaQuery.of(context).size.width - 36) / 3,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("Gelirler")],
              )),
          Container(
              width: (MediaQuery.of(context).size.width - 36) / 3,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("Giderler")],
              )),
        ],
        borderColor: Colors.white,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        borderWidth: 1,
        fillColor: Colors.grey,
        selectedColor: Colors.white,
        onPressed: (int index) {
          setState(() {
            _selection[index] = true;
            if (index == 0) {
              _selection[1] = false;
              _selection[2] = false;
            } else if (index == 1) {
              _selection[0] = false;
              _selection[2] = false;
            } else {
              _selection[0] = false;
              _selection[1] = false;
            }
          });
        },
      ),
    );
  }

  breakdownsList(Breakdowns breakdowns) {
    List<Breakdown> list = breakdowns.breakdowns;
    if (_selection[0]) {
      return ListView(
          children: List.generate(list.length, (i) => breakdownCard(list[i])));
    } else if (_selection[1]) {
      return ListView(
          children: List.generate(
              list.length,
              (i) => list[i].type == 'income'
                  ? breakdownCard(list[i])
                  : Container()));
    } else if (_selection[2]) {
      return ListView(
          children: List.generate(
              list.length,
              (i) => list[i].type == 'income'
                  ? Container()
                  : breakdownCard(list[i])));
    }
  }

  breakdownCard(Breakdown breakdown) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        color: breakdown.type == 'income'
            ? Color.fromRGBO(120, 180, 120, 1)
            : Color.fromRGBO(180, 120, 120, 1),
        child: ListTile(
          onTap: () {
            itemClick(breakdown);
          },
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${breakdown.month}/${breakdown.day}',
                  style: TextStyle(fontSize: 14)),
              Text('${addZero(breakdown.hour)}:${addZero(breakdown.minute)}',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
          title: Text(breakdown.category, style: TextStyle(fontSize: 21)),
          trailing: breakdown.type == 'income'
              ? Text(
                  '${FlutterMoneyFormatter(amount: breakdown.cost.toDouble()).output.withoutFractionDigits}₺ kâr (vergi hesapla)',
                  style: TextStyle(fontSize: 18))
              : Text(
                  '-${FlutterMoneyFormatter(amount: breakdown.cost.toDouble()).output.withoutFractionDigits}₺ zaradasın',
                  style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  floatingButton(Breakdowns breakdowns) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        size: 30,
      ),
      backgroundColor: Colors.white,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InputPage()));
      },
    );
  }

  totalMoney(Breakdowns breakdowns) {
    int height = MediaQuery.of(context).size.height.toInt();
    double width = MediaQuery.of(context).size.width.toDouble();
    return Container(
      height: height * 0.1,
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: <Widget>[
            Text(
              'Toplam Kasa : ${FlutterMoneyFormatter(amount: breakdowns.totalMoney.toDouble()).output.withoutFractionDigits}₺',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String addZero(int num) {
    if (num < 10)
      return '0' + num.toString();
    else
      return num.toString();
  }

  itemClick(Breakdown breakdown) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdatePage(
                  breakdown: breakdown,
                )));
  }
}
