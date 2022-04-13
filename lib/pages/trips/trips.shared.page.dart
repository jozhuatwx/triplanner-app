import 'package:flutter/widgets.dart';
import 'package:triplanner/pages/trip/trip.shared.page.dart';

import '../../models/trip/trip.model.dart';

class TripsPageState {
  bool? isLoading;
}

void onPressedCreate(BuildContext context) {
  Navigator.pushNamed(
    context,
    '/trip',
    arguments: TripPageArgs(createTrip: true),
  );
}

Widget tripsList({
  required Widget Function(Trip) builder,
  required TripsPageState state,
  required Widget loadingIndicator,
  List<Trip>? trips,
}) {
  if (state.isLoading == null || state.isLoading!) {
    return SliverFillRemaining(
      child: Center(
        child: loadingIndicator,
      ),
    );
  }

  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          child: builder(trips![index]),
        );
      },
      childCount: trips!.length,
    ),
  );
}
