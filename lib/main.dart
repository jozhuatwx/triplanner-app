import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import 'pages/trip/trip.page.dart';
import 'pages/trip/trips.page.dart';
import 'providers/trips.provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) => TripsPage(),
      '/trip': (context) => const TripPage(),
    };

    final themeData = ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        centerTitle: true,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TripsProvider.getInstance(),
        ),
      ],
      child: Theme(
        data: themeData,
        child: PlatformProvider(
          settings: PlatformSettingsData(iosUsesMaterialWidgets: true),
          builder: (context) => PlatformApp(
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: 'Triplanner',
            initialRoute: '/',
            routes: routes,
          ),
        ),
      ),
    );
  }
}
