import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'dart:html';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

enum ElementCommands {
  clear,
  revert,
  addElement,
  removeElement,
  loadSample,
  loadSampleXml,
  loadFile
}

String commandText(ElementCommands x) {
  String text = "";
  switch (x) {
    case ElementCommands.clear:
      text = "clr";
      break;
    case ElementCommands.revert:
      text = "undo";
      break;
    case ElementCommands.addElement:
      text = "add";
      break;
    case ElementCommands.removeElement:
      text = "del";
      break;
    case ElementCommands.loadSample:
      text = "model";
      break;
    case ElementCommands.loadSampleXml:
      text = "xml";
      break;
    case ElementCommands.loadFile:
      text = "load";
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

  factory Element.fromElement(XmlElement element) {
    return Element(
      1,
      element.getAttribute('name') ?? "",
      element.getAttribute('thumb') ?? "",
      element.innerText,
    );
  }
}

class ElementsType with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  ScrollController scrollAController = ScrollController();
  ScrollController scrollBController = ScrollController();

  String appTitle = "Elementary </XML>";

  List<Element> elements = <Element>[];
  List<Element> sideboard = <Element>[];
  int bookmarkA = -1;
  int bookmarkB = -1;
  List<Element> savedlist = <Element>[];
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

  void createSampleXMLData() {
    const String xmlString = '''<favourites>
  <favourite name="Testing NAME 1" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183304/Fox-News-Channel.png">Data string 1234-ABCD-2345-BCDE-3456-CDEF</favourite>
  <favourite name="Testing NAME 2" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183322/MSNBC.png">Data string 2234-ABCD-2345-BCDE-3456-CDEF</favourite>
  <favourite name="Testing NAME 3" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183339/Univision.png">Data string 3234-ABCD-2345-BCDE-3456-CDEF</favourite>
  <favourite name="Testing NAME 4" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183350/Hallmark-Channel.png">Data string 4234-ABCD-2345-BCDE-3456-CDEF</favourite>
  <favourite name="Testing NAME 5" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183411/History-Channels.png">Data string 5234-ABCD-2345-BCDE-3456-CDEF</favourite>
  <favourite name="Testing NAME 6" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183512/Food-Network.png">Data string 6234-ABCD-2345-BCDE-3456-CDEF</favourite>
  <favourite name="Testing NAME 7" thumb="https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183243/NBC-1.png">Data string 7234-ABCD-2345-BCDE-3456-CDEF</favourite>
</favourites>
''';

    XmlElement? xdoc = XmlDocument.parse(xmlString).getElement('favourites');

    var elementsX = xdoc
        ?.findElements('favourite')
        .map<Element>((e) => Element.fromElement(e))
        .toList();

    elements = elementsX!;
    sideboard.clear();
    savedlist = [...elements];
    notifyListeners();
  }

  void clear() {
    elements.clear();
    sideboard.clear();
    notes = 'cleared';
    notifyListeners();
  }

  void revert() {
    elements.clear();
    sideboard.clear();
    elements = [...savedlist];
    notifyListeners();
  }

  void addElement() {
    elements.add(Element(
        1,
        'added',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183405/Telemundo.png',
        'testdata'));
    notes = 'added item';
    notifyListeners();
  }

  void removeElement() {
    Element x = elements[0];
    sideboard.add(x);
    elements.removeAt(0);
    notes = 'removed element';
    notifyListeners();
  }

  void loadSample() {
    clear();
    createSampleData();
    savedlist = [...elements];
    notes = "sample loaded";
    notifyListeners();
  }

  Future<void> loadFile() async {
    var result = await FilePicker.platform.pickFiles(
        dialogTitle: "Choose XML file to load",
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['xml']);
    if (result != null) {
      clear();
      PlatformFile file = result.files.first;
      String xmlString = String.fromCharCodes(file.bytes as Iterable<int>);
      notes = 'file added ${file.size} string: ${xmlString.length}.';

      XmlElement? xdoc = XmlDocument.parse(xmlString).getElement('favourites');

      var elementsX = xdoc
        ?.findElements('favourite')
        .map<Element>((e) => Element.fromElement(e))
        .toList();

      elements = elementsX!;
      savedlist = [...elements];

      notifyListeners();
    }
  }
}
