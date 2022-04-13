import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/trip/trip.ios.page.dart';
import 'pages/trips/trips.ios.page.dart';
import 'providers/trips.provider.dart';

void main() {
  runApp(const IosApp());
}

class IosApp extends StatelessWidget {
  const IosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/': (context) => const TripsPage(),
      '/trip': (context) => const TripPage(),
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TripsProvider.getInstance(),
        ),
      ],
      child: CupertinoApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          title: 'Triplanner',
          initialRoute: '/',
          routes: routes,
        )
    );
  }
}
