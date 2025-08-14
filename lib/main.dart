import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Entry point for the OLOSI social demo. The application uses Riverpod for
/// state management and Material3 for styling. See [App] for the root
/// configuration.
void main() {
  runApp(const ProviderScope(child: App()));
}