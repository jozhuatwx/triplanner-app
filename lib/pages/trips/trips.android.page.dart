import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/trips.provider.dart';
import '../../widgets/trip.widget.dart';
import 'trips.shared.page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final _state = TripsPageState();

  @override
  void initState() {
    super.initState();
    _state.isLoading = true;
    Provider.of<TripsProvider>(context, listen: false)
        .getTripsAsync()
        .then((_) => setState((() => _state.isLoading = false)));
  }

  @override
  Widget build(BuildContext context) {
    var trips = Provider.of<TripsProvider>(context).getTrips();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(AppLocalizations.of(context)!.trips),
            actions: [
              IconButton(
                onPressed: () => onPressedCreate(context),
                icon: const Icon(Icons.add),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          tripsList(
            trips: trips,
            state: _state,
            loadingIndicator: const CircularProgressIndicator(),
            builder: (trip) => TripWidget(trip: trip),
          ),
        ],
      ),
    );
  }
}
