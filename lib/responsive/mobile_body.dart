import 'package:flutter/material.dart';
import '../components/command_bar.dart';
import '../components/display_screen.dart';
import '../components/display_log.dart';


class MyMobileBody extends StatelessWidget {
  const MyMobileBody({Key? key}) : super(key: key);

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
              Text('</XML>'),
              CommandBar(),
            ],
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
              color: Colors.deepPurple[300],
              height: 220,
              child: const Text('bookmark 1'),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
              color: Colors.deepPurple[300],
              height: 220,
              child: const Text('bookmark 1'),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
              color: Colors.deepPurple[300],
              height: 220,
              child: const Text('sideboard'),
                      ),
              ),
            ),
          ]),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.deepPurple,
                child: const DisplayLog(),
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.deepOrange[300],
                    child: const DisplayScreen(),
                  ))),
        ]),
      ),
    );
  }
}
