import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'dart:html';
import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

enum ElementCommands {
  clear,
  revert,
  addElement,
  removeElement,
  loadSample,
  loadSampleXml,
  loadFile,
  saveFile,
}

String commandText(ElementCommands x) {
  String text = "";
  switch (x) {
    case ElementCommands.clear:
      text = "clr";
      break;
    case ElementCommands.revert:
      text = "Revert";
      break;
    case ElementCommands.addElement:
      text = "add";
      break;
    case ElementCommands.removeElement:
      text = "Delete";
      break;
    case ElementCommands.loadSample:
      text = "model";
      break;
    case ElementCommands.loadSampleXml:
      text = "xml";
      break;
    case ElementCommands.loadFile:
      text = "load file";
      break;
    case ElementCommands.saveFile:
      text = "save file";
      break;
  }
  return text;
}

class Element {
  String id;
  String name;
  String thumb;
  String data;

  Element(this.id, this.name, this.thumb, this.data);

  factory Element.fromElement(XmlElement element) {
    var uuid = const Uuid();
    return Element(
      uuid.v1(),
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
  int selectedElement = -1;
  List<Element> savedlist = <Element>[];
  String notes = 'init';

  void saveFile() {
    const HtmlEscape htmlEscape = HtmlEscape();
    String xmlData = "<favourites>\n";
    for (Element e in elements) {
      xmlData +=
          "  <favourite name=\"${htmlEscape.convert(e.name)}\" thumb=\"${htmlEscape.convert(e.thumb)}\">${htmlEscape.convert(e.data)}</favourite>\n";
    }
    xmlData += "</favourites>\n";

    AnchorElement()
      ..href =
          '${Uri.dataFromString(xmlData, mimeType: 'text/plain', encoding: utf8)}'
      ..download = 'new_favourites.xml'
      ..style.display = 'none'
      ..click();
  }

  void setSelectedElement(int index) {
    selectedElement = index;
    notifyListeners();
  }

  void setBookMarkA(int index) {
    bookmarkA = index;
    if (bookmarkB == index) {
      bookmarkB = -1;
    }
    notifyListeners();
  }

  void setBookMarkB(int index) {
    bookmarkB = index;
    if (bookmarkA == index) {
      bookmarkA = -1;
    }
    notifyListeners();
  }

  void moveToBookMarkA(int index) {
    if (bookmarkA != -1) {
      final element = elements.removeAt(index);
      elements.insert(bookmarkA, element);
      notifyListeners();
    }
  }

  void moveSideBoardToBookMarkA(int index) {
    if (bookmarkA != -1) {
      final element = sideboard.removeAt(index);
      elements.insert(bookmarkA, element);
      notifyListeners();
    }
  }

  void moveToBookMarkB(int index) {
    if (bookmarkB != -1) {
      final element = elements.removeAt(index);
      elements.insert(bookmarkB, element);
      notifyListeners();
    }
  }

  void moveSideBoardToBookMarkB(int index) {
    if (bookmarkB != -1) {
      final element = sideboard.removeAt(index);
      elements.insert(bookmarkB, element);
      notifyListeners();
    }
  }

  void moveToSideBoard(int index) {
    final element = elements.removeAt(index);
    if (index == bookmarkA) {
      bookmarkA = -1;
    }
    if (index == bookmarkB) {
      bookmarkB = -1;
    }
    sideboard.add(element);
    notifyListeners();
  }

  void clear() {
    elements.clear();
    sideboard.clear();
    bookmarkA = -1;
    bookmarkB = -1;
    notes = 'cleared';
    notifyListeners();
  }

  void revert() {
    elements.clear();
    sideboard.clear();
    elements = [...savedlist];
    notifyListeners();
  }

  void removeElement() {
    Element x = elements[0];
    sideboard.add(x);
    elements.removeAt(0);
    notes = 'removed element';
    notifyListeners();
  }

  void swapElements(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final element = elements.removeAt(oldIndex);
    elements.insert(newIndex, element);
    if (bookmarkA == oldIndex) {
      bookmarkA = newIndex;
    }
    if (bookmarkB == oldIndex) {
      bookmarkB = newIndex;
    }
    notifyListeners();
  }

  void swapSideBoard(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final element = sideboard.removeAt(oldIndex);
    sideboard.insert(newIndex, element);
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

  void addElement() {
    elements.add(Element(
        '1',
        'added',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183405/Telemundo.png',
        'testdata'));
    notes = 'added item';
    notifyListeners();
  }

  void loadSample() {
    clear();
    createSampleData();
    savedlist = [...elements];
    notes = "sample loaded";
    notifyListeners();
  }

  void createSampleData() {
    elements.add(Element(
        '1',
        'Testing NAME 1',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183304/Fox-News-Channel.png',
        'Data string 1234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        '2',
        'Testing NAME 2',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183322/MSNBC.png',
        'Data string 2234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        '3',
        'Testing NAME 3',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183339/Univision.png',
        'Data string 3234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        '4',
        'Testing NAME 4',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183350/Hallmark-Channel.png',
        'Data string 4234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        '5',
        'Testing NAME 5',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183411/History-Channels.png',
        'Data string 5234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        '6',
        'Testing NAME 6',
        'https://bcassetcdn.com/public/blog/wp-content/uploads/2021/11/06183512/Food-Network.png',
        'Data string 6234-ABCD-2345-BCDE-3456-CDEF'));
    elements.add(Element(
        '7',
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
}
