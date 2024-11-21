import 'package:guardian_area/features/home/domain/datasources/current_location_datasource.dart';
import 'package:guardian_area/features/home/domain/entities/current_location.dart';
import 'package:guardian_area/features/home/domain/repositories/current_location_repository.dart';

class CurrentLocationRepositoryImpl extends CurrentLocationRepository {
  final CurrentLocationDatasource datasource;

  CurrentLocationRepositoryImpl({required this.datasource});

  @override
  Stream<CurrentLocation> connectToCurrentLocationStream(String roomId) {
    return datasource.connectToCurrentLocationStream(roomId);
  }
}
