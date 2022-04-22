import 'package:flutter/material.dart';
import 'package:finnapp/models/breakdowns.dart';
import 'package:finnapp/pages/home_page.dart';
import 'package:finnapp/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Breakdowns>(create: (_) => Breakdowns())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Money Management',
        theme: appThemeDark,
        home: HomePage(),
      ),
    );
  }
}
