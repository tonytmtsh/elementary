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
            tip: 'Move to top of list.',
            disabled: false,
          ),
          const CommandButton(
            command: ElementCommands.loadFile,
            tip: 'Load a favourites file.',
            disabled: false,
          ),
          const CommandButton(
            command: ElementCommands.revert,
            tip: 'Discard all changes made.',
            disabled: false,
          ),
          CommandButton(
            command: ElementCommands.removeElement,
            tip: 'Delete selected item.',
            disabled: (myModel.selectedElement == -1),
          ),
          const CommandButton(
            command: ElementCommands.saveFile,
            tip: 'Save current list to new file.',
            disabled: false,
          ),
          const CommandButton(
            command: ElementCommands.positionBottom,
            tip: 'Move to bottom of list.',
            disabled: false,
          ),
        ]),
      );
    });
  }
}
