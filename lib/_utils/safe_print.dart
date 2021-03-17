import 'package:flutter/foundation.dart';

void safePrint(String? value) {
  if (kReleaseMode) return;
  print(value);
}
