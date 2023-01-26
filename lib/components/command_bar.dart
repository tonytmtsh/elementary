import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/style/styles.dart';
import 'package:elementary/elements.dart';

import 'command_button.dart';

class CommandBar extends StatelessWidget {
  const CommandBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ElementsType>(builder: (context, myModel, child) {
      return Expanded(
          flex: 1,
          child: Column(
            children: [
              Text(myModel.notes),
              Row(children: const [
                CommandButton(command: ElementCommands.clear),
                CommandButton(command: ElementCommands.reset),
                CommandButton(command: ElementCommands.addElement),
                CommandButton(command: ElementCommands.removeElement),
                CommandButton(command: ElementCommands.loadSample),
                CommandButton(command: ElementCommands.loadSampleXml),
                CommandButton(command: ElementCommands.loadFile),
              ]),
            ],
          ));
    });
  }
}
