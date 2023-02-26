import 'package:elementary/components/command_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ElementsType>(builder: (context, myModel, child) {
      return Row(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
                controller: myModel.searchController,
                minLines: 1,
                maxLines: 1,
                onChanged: (text) {
                  myModel.searchText = text.toLowerCase();
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search Text:",
                    hintText: "Type text and hit next or previous.")),
          ),
          const CommandButton(command: ElementCommands.searchNext, tip: 'Continue search', disabled: false),
          const CommandButton(command: ElementCommands.searchPrevious, tip: 'Find previous', disabled: false),
        ],
      );
    });
  }
}

