import 'package:flutter/material.dart';
import 'package:elementary/components/command_bar.dart';
import 'package:elementary/components/searchbar.dart';
import 'package:elementary/components/display_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
          toolbarHeight: kToolbarHeight * 2.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Text('</XML>'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Container(
                        color: Colors.white, child: const CommandBar()),
                  ),
                  const SizedBox(width: 500, child: AppSearchBar()),
                ],
              ),
              const Row(children: [
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
