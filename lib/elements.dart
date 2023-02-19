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
  positionTop,
  positionBottom,
  gotoA,
  gotoB,
  editElement,
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
    case ElementCommands.positionTop:
      text = "top";
      break;
    case ElementCommands.positionBottom:
      text = "end";
      break;
    case ElementCommands.gotoA:
      text = "A";
      break;
    case ElementCommands.gotoB:
      text = "B";
      break;
    case ElementCommands.editElement:
      text = "edit";
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

class Category {
  String id;
  String title;

  Category(this.id, this.title);
}

class ElementsType with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  TextEditingController thumbController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String appTitle = "Elementary </XML>";

  List<Element> elements = <Element>[];
  List<Element> sideboard = <Element>[];
  int bookmarkA = -1;
  int bookmarkB = -1;
  //late RenderObject bookmarkAobj;
  //late RenderObject bookmarkBobj;

  int selectedElement = -1;

  bool editMode = false;
  int editIndex = -1;
  String editThumb = "";
  String editName = "";

  List<Element> savedlist = <Element>[];
  String notes = 'init';

  List<Category> get categories {
    List<Category> c = elements
        .where((e) => ((e.name.startsWith("[COLORyellow]")) &&
            (e.name.endsWith("[/COLOR]")) &&
            (e.name.indexOf("[COLOR", 1) == -1)))
        .map((element) => Category(element.id, element.name))
        .toList();

    return c;
  }

  void enterEditMode(int index) {
    if (index != -1) {
      editMode = true;
      editIndex = index;
      nameController.text = elements[index].name;
      thumbController.text = elements[index].thumb;
      editName = elements[index].name;
      editThumb = elements[index].thumb;
      notifyListeners();
    }
  }

  void updateItem(int index, String thumb, String name) {
    if (index != -1) {
      elements[index].thumb = thumbController.text;
      elements[index].name = nameController.text;
      editMode = false;
      notifyListeners();
    }
  }

  void cancelEditMode() {
    editMode = false;
    notifyListeners();
  }

  void refreshEditForm() {
    notifyListeners();
  }

  int idToIndex(String id) {
    final index = elements.lastIndexWhere((element) => element.id == id);
    return index;
  }

  String indexToId(int index) {
    return elements[index].id;
  }

  void positionTop() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void positionEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void positionCategory(String catId) {
    int itemnumber = idToIndex(catId);
    scrollController.animateTo(itemnumber * 48,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void positionA(BuildContext context) {
    if (bookmarkA != -1) {
//      scrollController.animateTo(
//          scrollController.position.ensureVisible(bookmarkAobj) as double,
//          duration: const Duration(milliseconds: 200),
//          curve: Curves.easeIn);
    }
  }

  void positionB(BuildContext context) {
    if (bookmarkB != -1) {
//      scrollController.animateTo(
//          scrollController.position.ensureVisible(bookmarkBobj) as double,
//          duration: const Duration(milliseconds: 200),
//          curve: Curves.easeIn);
    }
  }

  void saveFile() {
    const HtmlEscapeMode htmlMode = HtmlEscapeMode(
        name: "custom",
        escapeLtGt: true,
        escapeApos: true,
        escapeQuot: true,
        escapeSlash: false);
    const HtmlEscape htmlEscape = HtmlEscape(htmlMode);
    String xmlData = "<favourites>\n";
    for (Element e in elements) {
      xmlData +=
          "    <favourite name=\"${(htmlEscape.convert(e.name)).replaceAll(String.fromCharCode(0x0A), "&#x0A;").replaceAll("&#39;", "&apos;")}\"${(e.thumb != "") ? " thumb=\"${htmlEscape.convert(e.thumb)}\"" : ""}>${htmlEscape.convert(e.data)}</favourite>\n";
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
      String saveId = indexToId(bookmarkA);
      final element = elements.removeAt(index);
      elements.insert(bookmarkA, element);
      bookmarkA = idToIndex(saveId);
      notifyListeners();
    }
  }

  void moveSideBoardToBookMarkA(int index) {
    if (bookmarkA != -1) {
      String saveId = indexToId(bookmarkA);
      final element = sideboard.removeAt(index);
      elements.insert(bookmarkA, element);
      bookmarkA = idToIndex(saveId);
      notifyListeners();
    }
  }

  void moveToBookMarkB(int index) {
    if (bookmarkB != -1) {
      String saveId = indexToId(bookmarkB);
      final element = elements.removeAt(index);
      elements.insert(bookmarkB, element);
      bookmarkB = idToIndex(saveId);
      notifyListeners();
    }
  }

  void moveSideBoardToBookMarkB(int index) {
    if (bookmarkB != -1) {
      String saveId = indexToId(bookmarkB);
      final element = sideboard.removeAt(index);
      elements.insert(bookmarkB, element);
      bookmarkB = idToIndex(saveId);
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
    if (selectedElement != -1) {
      Element x = elements[selectedElement];
      elements.removeAt(0);
      notes = 'removed element';
      notifyListeners();
    }
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
