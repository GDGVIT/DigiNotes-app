import 'package:flutter/material.dart';
import 'package:diginotes_app/src/pres/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diginotes_app/src/pres/screens/home_page.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
        routes: {
          '/': (context) => MyHomePage(),
          "first": (context) => Onboarding(),
        });
  }
}
