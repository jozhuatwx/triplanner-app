import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/trip/trip.android.page.dart';
import 'pages/trips/trips.android.page.dart';
import 'providers/trips.provider.dart';

void main() {
  runApp(const AndroidApp());
}

class AndroidApp extends StatelessWidget {
  const AndroidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) => const TripsPage(),
      '/trip': (context) => const TripPage(),
    };

    final themeData = ThemeData();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TripsProvider.getInstance(),
        ),
      ],
      child: Theme(
        data: themeData,
        child: MaterialApp(
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: 'Triplanner',
            initialRoute: '/',
            routes: routes,
          ),
      ),
    );
  }
}
