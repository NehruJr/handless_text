import 'package:flutter/material.dart';
import 'package:img_voice_to_text/ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Color(0xff678983),
              secondary: Color(0xff678983),
              onSecondary: Colors.white),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff181D31),
            ),
            bodyText1: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffB8405E),
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              color: Color(0xff181D31),
            ),
          )),
      home: const HomeScreen(),
    );
  }
}
