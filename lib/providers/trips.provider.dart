import '../models/trip/trip.model.dart';
import '../services/storage.service.dart';
import 'provider_base.dart';

class TripsProvider extends ProviderListBase<List<Trip>> {
  static final TripsProvider _instance = TripsProvider._internal();

  TripsProvider._internal()
      : super(
          fileName: FileName.trips,
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
    return await getDataAsync(fromJson: Trip.fromJsonList);
  }

  Future updateTripAsync({
    required Trip trip,
  }) async {
    await getLatestDataAsync(fromJson: Trip.fromJsonList, notify: false);
    await updateDataListAsync(
      content: trip,
      index: getData!.indexWhere((element) => element.id == trip.id),
      insert: true,
    );
  }
}
