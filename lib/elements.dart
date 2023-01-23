import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

enum ElementCommands {
  reset,
  clear,
  addElement,
  removeElement,
  loadSample,
  loadFile
}

String commandText(ElementCommands x) {
  String text = "";
  switch (x) {
    case ElementCommands.reset:
      text = "reset";
      break;
    case ElementCommands.clear:
      text = "clear";
      break;
    case ElementCommands.addElement:
      text = "add";
      break;
    case ElementCommands.removeElement:
      text = "remove";
      break;
    case ElementCommands.loadSample:
      text = "sample data";
      break;
    case ElementCommands.loadFile:
      text = "load file";
      break;
  }
  return text;
}

class Element {
  int id;
  String name;
  String thumb;
  String data;

  Element(this.id, this.name, this.thumb, this.data);
}

class ElementsType with ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<Element> elements = <Element>[];
  String notes = 'init';

  void createSampleData() {
    elements.add(Element(
        1,
        'Testing NAME 1',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183304/Fox-News-Channel.png',
        'Data string 1234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        2,
        'Testing NAME 2',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183322/MSNBC.png',
        'Data string 2234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        3,
        'Testing NAME 3',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183339/Univision.png',
        'Data string 3234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        4,
        'Testing NAME 4',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183350/Hallmark-Channel.png',
        'Data string 4234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        5,
        'Testing NAME 5',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183411/History-Channels.png',
        'Data string 5234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        6,
        'Testing NAME 6',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183512/Food-Network.png',
        'Data string 6234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        7,
        'Testing NAME 7',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183243/NBC-1.png',
        'Data string 7234-ABCD-2345-BCDE-3456-CDEF'));
  }

  void clear() {
    elements.clear();
    notes = 'cleared';
    notifyListeners();
  }

  void reset() {
    clear();
  }

  void addElement() {
    elements.add(Element(
        elements.length + 1,
        'added',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183405/Telemundo.png',
        'testdata'));
    notes = 'added item';
    notifyListeners();
  }

  void removeElement() {
    elements.removeAt(0);
    notes = 'removed element';
    notifyListeners();
  }

  void loadSample() {
    clear();
    createSampleData();
    notes = "sample loaded";
    notifyListeners();
  }

  Future<void> loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: "Choose XML file to load",
        type: FileType.any,
        allowedExtensions: ['xml']);
    if (result != null) {
      clear();
      PlatformFile file = result.files.first;
      notes = 'file added with name ${file.path} ${file.name}';
      notifyListeners();
    }
  }
}
