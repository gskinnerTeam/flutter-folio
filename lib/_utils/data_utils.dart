import 'package:flutter_folio/data/book_data.dart';

class _IndexPair {
  int index1, index2;
  _IndexPair(this.index1, this.index2);
}

class DataUtils {
  static List<T> sortListById<T extends FirebaseDoc>(List<T> pages, List<String>? pageIds) {
    if (pageIds?.isEmpty ?? true) return pages;
    List<_IndexPair> listIndices = [];
    List<T> sortedList = [];
    for (int i = 0; i < pages.length; ++i) {
      int elementOrder = pageIds!.indexWhere((pageId) => pageId == pages[i].documentId);
      listIndices.add(_IndexPair(elementOrder != -1 ? elementOrder : 1000000000, i));
    }
    listIndices.sort((a, b) => a.index1.compareTo(b.index1));
    for (int i = 0; i < listIndices.length; ++i) {
      sortedList.add(pages[listIndices[i].index2]);
    }
    return sortedList;
  }
}
