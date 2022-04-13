import 'package:flutter/material.dart';
import 'package:triplanner/models/event/event.model.dart';

class EventWidget extends StatefulWidget {
  final Event event;

  const EventWidget({Key? key, required this.event}) : super(key: key);

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  void _expand() {}

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: _expand,
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              Column(
                children: [
                  Text(widget.event.name),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
