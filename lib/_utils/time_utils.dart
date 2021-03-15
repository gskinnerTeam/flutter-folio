// @dart=2.12
class TimeUtils {
  static int get nowMillis => DateTime.now().millisecondsSinceEpoch;
  static int get nowSeconds => (nowMillis * .001).round();
}
