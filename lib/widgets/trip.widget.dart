import 'package:flutter/material.dart';

import '../../models/trip/trip.model.dart';
import '../pages/trip/trip.shared.page.dart';

class TripWidget extends StatefulWidget {
  final Trip trip;

  const TripWidget({Key? key, required this.trip}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripWidgetState();
}

class _TripWidgetState extends State<TripWidget> {
  void _navigateToTrip() {
    Navigator.pushNamed(
      context,
      '/trip',
      arguments: TripPageArgs(trip: widget.trip),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: _navigateToTrip,
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(widget.trip.name),
              Text(widget.trip.id),
            ],
          ),
        ),
      ),
    );
  }
}
