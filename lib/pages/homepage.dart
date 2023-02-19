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
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('</XML>'),
                      CommandBar(),
                    ],
                  ),
                ],
              ),
              Row(children: const [
                Expanded(flex: 1, child: Text('Categories')),
                Expanded(flex: 2, child: Text('Channel Descriptions')),
                Expanded(flex: 2, child: Text('Side Board'))
              ]),
            ],
          )),
      body: const DisplayScreen(),
    );
  }
}
