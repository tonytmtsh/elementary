import 'element.dart';

class ElementList {
  final List<Element> _elements = [];

  // Method to add an element to the list
  void add(Element element) {
    _elements.add(element);
  }

  // Method to move an element to the top of the list
  void moveToTop(Element element) {
    _elements.remove(element);
    _elements.insert(0, element);
  }

  // Method to move an element to the bottom of the list
  void moveToBottom(Element element) {
    _elements.remove(element);
    _elements.add(element);
  }

  // Method to remove an element from the list
  void removem(Element element) {
    _elements.remove(element);
  }

  // Method to move an element to a specific position in the list
  void moveToPosition(Element element, int position) {
    _elements.remove(element);
    _elements.insert(position, element);
  }

  // Method to return the list of elements
  List<Element> get elements => _elements;
}
