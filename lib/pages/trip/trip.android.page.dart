import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:triplanner/widgets/event.widget.dart';

import '../../models/event/event.model.dart';
import '../../models/trip/trip.model.dart';
import 'trip.shared.page.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key? key}) : super(key: key);

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _state = TripPageState();
  Trip? _trip;

  TextEditingController? _tripNameController;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TripPageArgs;
    _trip ??= args.trip ?? Trip();
    _state.isCreating ??= args.createTrip ?? false;
    _state.isEditing ??= args.editTrip ?? false;

    _tripNameController ??= TextEditingController(text: _trip!.name);

    if (_state.isCreating! || _state.isEditing!) {
      return Scaffold(
        appBar: AppBar(
          title: _state.isCreating!
              ? Text(AppLocalizations.of(context)!.addTrip)
              : Text('${AppLocalizations.of(context)!.edit} ${_trip!.name}'),
          actions: [
            IconButton(
              onPressed: () => onPressedSave(
                formKey: _formKey,
                context: context,
                setState: setState,
                trip: _trip,
                tripNameController: _tripNameController,
                state: _state,
              ),
              icon: const Icon(Icons.save),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tripNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.tripName,
                ),
                validator: (value) =>
                    tripNameValidator(context: context, value: value),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_trip!.name),
          actions: [
            IconButton(
              onPressed: () =>
                  onPressedEdit(setState: setState, state: _state),
              icon: const Icon(Icons.edit),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        body: ListView(
          children: [
            Text(_trip!.name),
            EventWidget(event: Event(name: 'Somewhere'))
          ],
        ),
      );
    }
  }
}
