import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';

import 'command_button.dart';

class CommandBar extends StatelessWidget {
  const CommandBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ElementsType>(builder: (context, myModel, child) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: ButtonBar(buttonPadding: EdgeInsets.zero, children: [
          const CommandButton(
            command: ElementCommands.positionTop,
            disabled: false,
          ),
          const CommandButton(
            command: ElementCommands.loadFile,
            disabled: false,
          ),
          const CommandButton(
            command: ElementCommands.revert,
            disabled: false,
          ),
          CommandButton(
            command: ElementCommands.removeElement,
            disabled: (myModel.selectedElement == -1),
          ),
          const CommandButton(
            command: ElementCommands.saveFile,
            disabled: false,
          ),
          const CommandButton(
            command: ElementCommands.positionBottom,
            disabled: false,
          ),
        ]),
      );
    });
  }
}
