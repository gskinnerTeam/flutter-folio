void Function(String value)? onPrint;
String logHistory = "";

class PrintLogger {}

void logPrint(String? value) {
  String v = value ?? "";
  //if (kReleaseMode) return;
  logHistory = v + "\n" + logHistory;
  onPrint?.call(v);
}
