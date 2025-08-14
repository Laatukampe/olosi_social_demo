import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/status_set/status_set_page.dart';
import 'features/contacts_list/contacts_list_page.dart';

/// Root widget for the OLOSI social demo. Configures the theme and defines
/// navigation routes between the status setting and contacts list pages.
class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  static const String _statusRoute = '/';
  static const String _contactsRoute = '/contacts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'OLOSI Social Demo',
      theme: buildOlosiTheme(),
      initialRoute: _statusRoute,
      routes: {
        _statusRoute: (_) => const StatusSetPage(),
        _contactsRoute: (_) => const ContactsListPage(),
      },
    );
  }

  /// Navigate to the contacts list from anywhere in the app.
  static void goToContacts(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(_contactsRoute);
  }
}