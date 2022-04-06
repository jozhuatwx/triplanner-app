import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:triplanner/providers/trips.provider.dart';

import '../../models/trip/trip.model.dart';

class TripPageArgs {
  final Trip? trip;
  final bool? createTrip;
  final bool? editTrip;

  TripPageArgs({this.trip, this.createTrip, this.editTrip});
}

class TripPage extends StatefulWidget {
  const TripPage({Key? key}) : super(key: key);

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? isCreating;
  bool? isEditing;
  Trip? trip;

  TextEditingController? tripNameController;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TripPageArgs;
    trip ??= args.trip ?? Trip();
    isCreating ??= args.createTrip ?? false;
    isEditing ??= args.editTrip ?? false;

    tripNameController ??= TextEditingController(text: trip!.name);

    if (isCreating! || isEditing!) {
      return PlatformScaffold(
        appBar: PlatformAppBar(
          title: isCreating!
              ? Text(AppLocalizations.of(context)!.addTrip)
              : Text('${AppLocalizations.of(context)!.edit} ${trip!.name}'),
          trailingActions: [
            PlatformIconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  trip!.name = tripNameController!.text;
                  Provider.of<TripsProvider>(context, listen: false)
                      .updateTripAsync(trip: trip!)
                      .then((value) {
                    setState(() {
                      isCreating = false;
                      isEditing = false;
                    });
                  });
                }
              },
              icon: Icon(isMaterial(context)
                  ? Icons.save
                  : CupertinoIcons.floppy_disk),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              PlatformTextFormField(
                controller: tripNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.enterTripName;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(trip!.name),
          trailingActions: [
            PlatformIconButton(
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
              icon: Icon(context.platformIcons.edit),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        body: ListView(
          children: [
            // Picture
            Text(trip!.name)
          ],
        ),
      );
    }
  }
}
