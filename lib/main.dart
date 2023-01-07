import 'package:attendance_tracker/screens/navigation.dart';
import 'package:attendance_tracker/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firstRun = await IsFirstRun.isFirstRun();
  runApp(MyApp(firstRun: firstRun,));
}

class MyApp extends StatelessWidget {
  bool firstRun;
  MyApp({super.key, required this.firstRun});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Tracker',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColorDark: Colors.blueGrey,
      ),
      home: firstRun ? OnBoardingPage() : const NavigationPage(),
    );
  }
}
