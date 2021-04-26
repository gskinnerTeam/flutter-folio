class ListUtils {
  static List<T> interleave<T>(List<T> listA, List<T> listB) {
    List<T> result = [];
    for (var i = 0; i < listA.length; i++) {
      result..add(listA[i])..add(listB[i]);
    }
    return result;
  }
}
