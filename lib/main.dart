import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';
import 'package:elementary/components/command_bar.dart';
import 'package:elementary/components/display_screen.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElementsType>(
      create: (context) => ElementsType(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elementary </XML>',
        home: Scaffold(
          appBar: AppBar(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text('Elementary </XML>'),
              Icon(Icons.data_array),
            ],
          )),
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: const <Widget>[
                CommandBar(),
                DisplayScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}