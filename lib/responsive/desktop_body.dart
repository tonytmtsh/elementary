import 'package:flutter/material.dart';
import '../components/command_bar.dart';
import '../components/display_screen.dart';

class MyDesktopBody extends StatelessWidget {
  const MyDesktopBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          // First column
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    color: Colors.deepOrange[300],
                    child: const DisplayScreen(),
                  ))),

          // second column
          Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple[300],
                        width: double.infinity,
                        child: const Expanded(child: Text('bookmark 1')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple[300],
                        child: const Text('bookmark 2'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple[300],
                        child: const Text('sideboard'),
                      ),
                    ),
                  ])),
        ]),
      ),
    );
  }
}

/*

Scaffold(
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
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const DisplayScreen(),
                Column(children: const [
                  Text('Test 1'),
                  Text('Test 2'),
                ]),
              ],
            ),
          ),
        )
        */