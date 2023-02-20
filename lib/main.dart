import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/homePage.dart';
import 'package:elementary/elements.dart';

void main() => runApp(const MyApp());

// terminal command to build:  flutter build web --web-renderer html --release
// Category version
// then copy contents of folder build/web to C:\Users\tonyt\source\FlutterWebSites\tonytmtsh.github.io
// commit and sync to publish

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElementsType>(
      create: (context) => ElementsType(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '</XML>',
        home: HomePage(),
      ),
    );
  }
}
