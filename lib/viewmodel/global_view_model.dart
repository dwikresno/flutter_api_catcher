import 'package:alice/alice.dart';
import 'package:flutter/material.dart';

class GlobalViewModel with ChangeNotifier {
  Alice alice = Alice(
    showNotification: false,
    showInspectorOnShake: true,
    darkTheme: false,
  );
}
