import 'package:intl/intl.dart';

import '../models/enums/directory_name.dart';
import '../models/trip/trip.model.dart';
import '../services/storage.service.dart';
import 'provider_base.dart';

class TripsProvider extends ProviderListBase<List<Trip>> {
  static final TripsProvider _instance = TripsProvider._internal();

  TripsProvider._internal()
      : super(
          directoryName: DirectoryName.trips,
          defaultValue: <Trip>[],
          storageType: StorageType.document,
        );

  static TripsProvider getInstance() {
    return _instance;
  }

  List<Trip>? getTrips() {
    return getData;
  }

  Future<List<Trip>?> getTripsAsync() async {
    return await getDataAsync(fileName: _generateFileName(), fromJson: Trip.fromJsonList);
  }

  Future updateTripAsync({
    required Trip trip,
  }) async {
    await getLatestDataAsync(
      fileName: _generateFileName(date: trip.startDate),
      fromJson: Trip.fromJsonList,
      notify: false,
    );
    await updateDataListAsync(
      fileName: _generateFileName(date: trip.startDate),
      content: trip,
      index: getData!.indexWhere((element) => element.id == trip.id),
      insert: true,
    );
  }

  String _generateFileName({DateTime? date}) {
    final formatter = DateFormat('yyyyMM');
    return "${formatter.format(date ?? DateTime.now())}.json";
  }
}
