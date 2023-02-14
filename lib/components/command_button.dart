import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';

class CommandButton extends StatelessWidget {
  const CommandButton({Key? key, required this.command}) : super(key: key);
  final ElementCommands command;

  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<ElementsType>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: command == ElementCommands.removeElement
                ? Colors.pink
                : command == ElementCommands.loadFile
                    ? Colors.orange
                    : command == ElementCommands.saveFile
                        ? Colors.red
                        : Colors.green),
        child: Text(commandText(command)),
        onPressed: () {
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
          }
        },
      ),
    );
  }
}
