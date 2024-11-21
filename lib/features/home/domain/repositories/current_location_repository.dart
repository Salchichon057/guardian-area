import 'package:guardian_area/features/home/domain/entities/current_location.dart';

abstract class CurrentLocationRepository {
  Stream<CurrentLocation> connectToCurrentLocationStream(String roomId);
}
