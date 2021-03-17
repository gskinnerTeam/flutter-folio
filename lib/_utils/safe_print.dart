// @dart=2.12
import 'package:flutter/foundation.dart';

void safePrint(String? value) {
  if (kReleaseMode) return;
  print(value);
}
