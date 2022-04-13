import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/trip/trip.model.dart';
import '../../providers/trips.provider.dart';

class TripPageArgs {
  final Trip? trip;
  final bool? createTrip;
  final bool? editTrip;

  TripPageArgs({this.trip, this.createTrip, this.editTrip});
}

class TripPageState {
  bool? isCreating;
  bool? isEditing;
}

void onPressedEdit({
  required void Function(void Function()) setState,
  required TripPageState state,
}) {
  setState(() => state.isEditing = true);
}

void onPressedSave({
  required GlobalKey<FormState> formKey,
  required BuildContext context,
  required Trip? trip,
  required TextEditingController? tripNameController,
  required void Function(void Function()) setState,
  required TripPageState state,
}) {
  if (formKey.currentState!.validate()) {
    trip!.name = tripNameController!.text;
    Provider.of<TripsProvider>(context, listen: false)
        .updateTripAsync(trip: trip)
        .then((value) {
      setState(() {
        state.isCreating = false;
        state.isEditing = false;
      });
    });
  }
}

String? tripNameValidator({required BuildContext context, required String? value}) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.enterTripNameError;
  }
  return null;
}
