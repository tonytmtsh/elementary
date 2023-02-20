import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';

class CommandButton extends StatelessWidget {
  const CommandButton({Key? key, required this.command, required this.disabled})
      : super(key: key);
  final ElementCommands command;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<ElementsType>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: disabled ? 0 : 4,
            foregroundColor: disabled ? Colors.grey : Colors.white,
            backgroundColor: disabled
                ? Colors.black12
                : command == ElementCommands.removeElement
                    ? Colors.pink
                    : command == ElementCommands.loadFile
                        ? Colors.orange
                        : command == ElementCommands.saveFile
                            ? Colors.red
                            : Colors.green),
        child: Text(commandText(command)),
        onPressed: () {
          if (disabled) {
          } else {
            switch (command) {
              case ElementCommands.clear:
                myModel.clear();
                break;
              case ElementCommands.revert:
                myModel.revert();
                break;
              case ElementCommands.addElement:
                myModel.addElement();
                break;
              case ElementCommands.removeElement:
                myModel.removeElement();
                break;
              case ElementCommands.loadSample:
                myModel.loadSample();
                break;
              case ElementCommands.loadSampleXml:
                myModel.createSampleXMLData();
                break;
              case ElementCommands.loadFile:
                myModel.loadFile();
                break;
              case ElementCommands.saveFile:
                myModel.saveFile();
                break;
              case ElementCommands.positionTop:
                myModel.positionTop();
                break;
              case ElementCommands.positionBottom:
                myModel.positionEnd();
                break;
              case ElementCommands.searchNext:
                myModel.searchNext();
                break;
              case ElementCommands.searchPrevious:
                myModel.searchNext();
                break;
              case ElementCommands.gotoA:
                // TODO: Handle this case.
                break;
              case ElementCommands.gotoB:
                // TODO: Handle this case.
                break;
              case ElementCommands.editElement:
                // TODO: Handle this case.
                break;
            }
          }
        },
      ),
    );
  }
}
