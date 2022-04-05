import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../providers/trips.provider.dart';
import '../../widgets/trip.widget.dart';
import 'trip.page.dart';

class TripsPage extends StatelessWidget {
  TripsPage({Key? key}) : super(key: key);

  final refreshController = RefreshController(initialRefresh: true);

  void _refresh(BuildContext context) async {
    await Provider.of<TripsProvider>(context, listen: false).readAsync();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    var trips = Provider.of<TripsProvider>(context).getTrips;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(AppLocalizations.of(context)!.trips),
        trailingActions: [
          PlatformIconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/trip',
                arguments: TripPageArgs(createTrip: true),
              );
            },
            icon: Icon(context.platformIcons.add),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      body: SmartRefresher(
        onRefresh: () {
          _refresh(context);
        },
        controller: refreshController,
        child: ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                bottom: 10.0,
              ),
              child: TripWidget(trip: trips[index]),
            );
          },
        ),
      ),
    );
  }
}
