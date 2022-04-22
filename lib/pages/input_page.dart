import 'package:flutter/material.dart';
import 'package:finnapp/database/dbHelper.dart';
import 'package:finnapp/models/breakdown.dart';
import 'package:finnapp/models/breakdowns.dart';
import 'package:provider/provider.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String type = 'spending';
  final costController = TextEditingController();
  final categoryController = TextEditingController();
  final focusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Breakdowns breakdowns = Provider.of<Breakdowns>(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromRGBO(48, 48, 48, 1),
          elevation: 0,
        ),
        body: buildBody(breakdowns),
      ),
    );
  }

  buildBody(Breakdowns breakdowns) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          radio(),
          inputCost(),
          inputCategory(breakdowns),
          addButton(breakdowns)
        ],
      ),
    );
  }

  radio() {
    return Row(
      children: <Widget>[
        Text('Gelir'),
        Radio(
          value: 'income',
          groupValue: type,
          onChanged: (String value) {
            setState(() {
              type = value;
            });
          },
        ),
        Text('Gider'),
        Radio(
          value: 'spending',
          groupValue: type,
          onChanged: (String value) {
            setState(() {
              type = value;
            });
          },
        )
      ],
    );
  }

  inputCost() {
    return TextField(
      controller: costController,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: 'Tutar'),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
    );
  }

  inputCategory(Breakdowns breakdowns) {
    return TextField(
      controller: categoryController,
      maxLength: 10,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'Tutar Sahibi',
      ),
      onEditingComplete: () {
        onSubmit(breakdowns);
      },
    );
  }

  addButton(Breakdowns breakdowns) {
    return RaisedButton(
      child: Text("Kaydet"),
      onPressed: () {
        onSubmit(breakdowns);
      },
    );
  }

  onSubmit(Breakdowns breakdowns) {
    if (costController.text == '') {
      final snackBar = SnackBar(
        content: Text('miktarı yazınız'),
        action: SnackBarAction(
          label: 'closse',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    Breakdown newBreakdown = new Breakdown(
        type, int.parse(costController.text), categoryController.text);
    DBHelper.db.insertBreakdownInDB(newBreakdown);
    breakdowns.getFromDB();
    Navigator.pop(context);
  }
}
