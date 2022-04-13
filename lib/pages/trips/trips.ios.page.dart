import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:triplanner/pages/trips/trips.shared.page.dart';

import '../../providers/trips.provider.dart';
import '../../widgets/trip.widget.dart';

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
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(AppLocalizations.of(context)!.trips),
            trailing: CupertinoButton(
              onPressed: () => onPressedCreate(context),
              child: const Icon(CupertinoIcons.add),
              padding: EdgeInsets.zero,
            ),
          ),
          tripsList(
            trips: trips,
            state: _state,
            loadingIndicator: const CupertinoActivityIndicator(),
            builder: (trip) => TripWidget(trip: trip),
          ),
        ],
      ),
    );
  }
}
