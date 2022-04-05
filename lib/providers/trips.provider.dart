import 'package:flutter/material.dart';

import '../models/trip/trip.model.dart';
import '../services/local_storage.dart';

class TripsProvider extends ChangeNotifier {
  var _trips = <Trip>[];

  List<Trip> get getTrips {
    return _trips;
  }

  Future<List<Trip>> readAsync() async {
    var storage = await LocalStorage.init();
    var data = await storage.readFile(fileName: FileName.trips);
    if (data != null) {
      _trips = Trip.fromJsonList(data);
      notifyListeners();
    }
    return _trips;
  }

  Future<bool> updateTripAsync(
      {required Trip trip, addIfNotExist = true}) async {
    try {
      await readAsync();

      var index = _trips.indexWhere((e) => e.id == trip.id);
      if (index >= 0) {
        _trips[index] = trip;
      } else if (addIfNotExist) {
        _trips.add(trip);
      } else {
        return false;
      }

      var storage = await LocalStorage.init();
      await storage.writeFile(fileName: FileName.trips, content: _trips);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
