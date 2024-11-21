import 'package:guardian_area/features/home/domain/entities/current_location.dart';

abstract class CurrentLocationDatasource {
  Stream<CurrentLocation> connectToCurrentLocationStream(String roomId);
}
