import 'package:flutter/material.dart';
import 'package:elementary/components/command_bar.dart';
import 'package:elementary/components/display_log.dart';
import 'package:elementary/components/display_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Elementary </XML>'),
              CommandBar(),
            ],
          ),
        ],
      )),
      body: const DisplayScreen(),
    );
  }
}
